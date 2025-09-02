import '../main.dart';

class DefaultNotesGenerator {
  static List<NoteCategory> generateDefaultNotes() {
    return [
      NoteCategory(
        title: '📚 学术/学习类',
        items: [
          NoteItem(
            'Flutter开发入门',
            'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400',
          ),
          NoteItem(
            '数学笔记',
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          ),
          NoteItem(
            '历史学习指南',
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
          ),
          NoteItem(
            '科学实验报告',
            'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=400',
          ),
          NoteItem(
            '语言学习',
            'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400',
          ),
        ],
      ),
      NoteCategory(
        title: '💼 职业/技能类',
        items: [
          NoteItem(
            '项目管理',
            'https://images.unsplash.com/photo-1517180102446-f3ece451e9d8?w=400',
          ),
          NoteItem(
            '团队会议总结',
            'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400',
          ),
          NoteItem(
            '技能发展计划',
            'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400',
          ),
          NoteItem(
            '面试准备',
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          ),
          NoteItem(
            '职业规划',
            'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=400',
          ),
        ],
      ),
      NoteCategory(
        title: '🧠 记忆/个人成长类',
        items: [
          NoteItem(
            '每日日记',
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
          ),
          NoteItem(
            '2025个人目标',
            'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=400',
          ),
          NoteItem(
            '读书反思',
            'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400',
          ),
          NoteItem(
            '正念练习',
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
          ),
          NoteItem(
            '感恩日记',
            'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400',
          ),
        ],
      ),
      NoteCategory(
        title: '🎮 趣味/儿童类',
        items: [
          NoteItem(
            '动物与自然',
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
          ),
          NoteItem(
            '食物与饮品',
            'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=400',
          ),
          NoteItem(
            '国家与首都',
            'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400',
          ),
          NoteItem(
            '数字与颜色',
            'https://images.unsplash.com/photo-1495521821757-a2efac64471b?w=400',
          ),
          NoteItem(
            '故事角色',
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
          ),
        ],
      ),
    ];
  }

  /// 为特定类型生成单个默认笔记
  static NoteItem generateSingleNote(String category, String title, {String? customImageUrl}) {
    final imageUrls = {
      'academic': 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400',
      'career': 'https://images.unsplash.com/photo-1517180102446-f3ece451e9d8?w=400',
      'personal': 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
      'fun': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    };
    
    final imageUrl = customImageUrl ?? imageUrls[category.toLowerCase()] ?? imageUrls['fun']!;
    
    return NoteItem(title, imageUrl);
  }

  /// 为每个类型生成一个默认笔记的简化版本
  static List<NoteCategory> generateMinimalDefaultNotes() {
    return [
      NoteCategory(
        title: '📚 学术/学习类',
        items: [
          generateSingleNote('academic', '我的学习笔记'),
        ],
      ),
      NoteCategory(
        title: '💼 职业/技能类',
        items: [
          generateSingleNote('career', '工作与职业笔记'),
        ],
      ),
      NoteCategory(
        title: '🧠 记忆/个人成长类',
        items: [
          generateSingleNote('personal', '个人日记'),
        ],
      ),
      NoteCategory(
        title: '🎮 趣味/儿童类',
        items: [
          generateSingleNote('fun', '趣味学习笔记'),
        ],
      ),
    ];
  }
}
