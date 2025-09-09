package main

import (
	"log"
	"net/http"
	"path/filepath"
	"strings"
	"sync"

	"github.com/gorilla/websocket"
)

// Y.js WebSocket message types
const (
	MessageSync       = 0
	MessageAwareness  = 1
	MessageAuth       = 2
	MessageQueryAware = 3
)

type Server struct {
	rooms    map[string]*Room
	roomsMux sync.RWMutex
	upgrader websocket.Upgrader
}

type Room struct {
	name    string
	clients map[*Client]bool
	state   []byte
	mux     sync.RWMutex
}

type Client struct {
	conn   *websocket.Conn
	room   *Room
	server *Server
}

func NewServer() *Server {
	return &Server{
		rooms: make(map[string]*Room),
		upgrader: websocket.Upgrader{
			CheckOrigin: func(r *http.Request) bool {
				return true // Allow all origins for development
			},
			Subprotocols: []string{"y-websocket"},
		},
	}
}

func (s *Server) getOrCreateRoom(name string) *Room {
	s.roomsMux.Lock()
	defer s.roomsMux.Unlock()

	room, exists := s.rooms[name]
	if !exists {
		room = &Room{
			name:    name,
			clients: make(map[*Client]bool),
			state:   make([]byte, 0),
		}
		s.rooms[name] = room
		log.Printf("Created new room: %s", name)
	}
	return room
}

func (r *Room) addClient(client *Client) {
	r.mux.Lock()
	defer r.mux.Unlock()
	
	r.clients[client] = true
	log.Printf("Client joined room %s. Total clients: %d", r.name, len(r.clients))
}

func (r *Room) removeClient(client *Client) {
	r.mux.Lock()
	defer r.mux.Unlock()
	
	delete(r.clients, client)
	log.Printf("Client left room %s. Total clients: %d", r.name, len(r.clients))
}

func (r *Room) broadcast(data []byte, sender *Client) {
	r.mux.RLock()
	defer r.mux.RUnlock()

	for client := range r.clients {
		if client != sender {
			if err := client.conn.WriteMessage(websocket.BinaryMessage, data); err != nil {
				log.Printf("Error broadcasting to client: %v", err)
				delete(r.clients, client)
			}
		}
	}
}

func (c *Client) readPump() {
	defer c.conn.Close()

	for {
		_, data, err := c.conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("WebSocket error: %v", err)
			} else {
				log.Printf("Read error: %v", err)
			}
			break
		}

		if len(data) == 0 {
			continue
		}

		// Y.js protocol: first byte is message type
		msgType := data[0]

		switch msgType {
		case MessageSync:
			log.Printf("Received sync message in room %s, length: %d", c.room.name, len(data))
			c.room.mux.Lock()
			c.room.state = append(c.room.state, data...)
			c.room.mux.Unlock()
			c.room.broadcast(data, c)

		case MessageAwareness:
			log.Printf("Received awareness message in room %s", c.room.name)
			c.room.broadcast(data, c)

		default:
			log.Printf("Unknown message type: %d", msgType)
		}
	}
}

func (s *Server) handleWebSocket(w http.ResponseWriter, r *http.Request) {
	// Add CORS headers for WebSocket
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
	
	path := strings.TrimPrefix(r.URL.Path, "/")
	if path == "" {
		path = "default"
	}

	log.Printf("WebSocket connection request for room: %s", path)

	conn, err := s.upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Printf("WebSocket upgrade failed: %v", err)
		return
	}
	defer conn.Close()

	room := s.getOrCreateRoom(path)
	client := &Client{
		conn:   conn,
		room:   room,
		server: s,
	}

	room.addClient(client)
	defer room.removeClient(client)

	// Send existing state to new client
	room.mux.RLock()
	if len(room.state) > 0 {
		if err := conn.WriteMessage(websocket.BinaryMessage, room.state); err != nil {
			log.Printf("Error sending state to new client: %v", err)
		}
	}
	room.mux.RUnlock()

	client.readPump()
}

func (s *Server) handleStaticFiles(w http.ResponseWriter, r *http.Request) {
	// Add CORS headers for cross-origin requests
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
	
	// Handle preflight requests
	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusOK)
		return
	}
	
	path := r.URL.Path
	if path == "/" {
		path = "/crdt_note_editor.html"
	}

	fullPath := filepath.Join("../web", path)

	log.Printf("Serving file: %s", fullPath)
	http.ServeFile(w, r, fullPath)
}

func main() {
	server := NewServer()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if websocket.IsWebSocketUpgrade(r) {
			server.handleWebSocket(w, r)
		} else {
			server.handleStaticFiles(w, r)
		}
	})

	log.Println("=== Y.js WebSocket + Static File Server ===")
	log.Println("Server starting on :8800")
	log.Println("Static files: http://localhost:8800/")
	log.Println("WebSocket: ws://localhost:8800/{roomname}")
	log.Println("Subprotocol: y-websocket")
	log.Println("Y.js compatible protocol")
	log.Println("CORS enabled for cross-origin requests")
	log.Println("==========================================")

	if err := http.ListenAndServe(":8800", nil); err != nil {
		log.Fatal("Server failed to start:", err)
	}
}
