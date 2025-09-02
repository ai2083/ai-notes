#!/usr/bin/env dart

/// 初始化脚本：为AI笔记应用生成默认数据
/// 使用方法：dart run scripts/init_default_notes.dart

import 'dart:io';
import 'dart:convert';

void main() {
  print('🚀 正在初始化AI笔记应用的默认数据...\n');
  
  // 生成默认笔记数据
  final defaultNotes = generateDefaultNotesJson();
  
  // 创建数据目录
  final dataDir = Directory('assets/data');
  if (!dataDir.existsSync()) {
    dataDir.createSync(recursive: true);
    print('📁 创建了数据目录：${dataDir.path}');
  }
  
  // 写入默认笔记JSON文件
  final notesFile = File('assets/data/default_notes.json');
  notesFile.writeAsStringSync(defaultNotes);
  print('✅ 生成默认笔记数据文件：${notesFile.path}');
  
  // 生成用户指南
  generateUserGuide();
  
  print('\n🎉 初始化完成！');
  print('📝 生成了以下内容：');
  print('   • 4个笔记类别，每个类别包含1个默认笔记');
  print('   • Academic/Learning: 我的学习笔记');
  print('   • Career/Skills: 工作与职业笔记');
  print('   • Memory/Personal Growth: 个人日记');
  print('   • Quick Notes: 快速想法');
  print('\n💡 提示：您可以在应用中编辑、删除或添加更多笔记！');
}

String generateDefaultNotesJson() {
  final notes = {
    "version": "1.0",
    "generatedAt": DateTime.now().toIso8601String(),
    "categories": [
      {
        "id": "academic",
        "title": "📚 学术/学习类",
        "description": "学习相关的笔记，包括课程内容、研究资料等",
        "color": "#4A90E2",
        "icon": "school",
        "notes": [
          {
            "id": "academic_001",
            "title": "我的学习笔记",
            "content": "# 学习笔记\n\n这是您的第一个学习笔记！\n\n## 今天学到的内容\n- 新概念和知识点\n- 重要的公式或理论\n- 需要复习的内容\n\n## 下次学习计划\n- [ ] 复习今天的内容\n- [ ] 预习下一章节\n- [ ] 完成练习题",
            "imageUrl": "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400",
            "createdAt": DateTime.now().toIso8601String(),
            "updatedAt": DateTime.now().toIso8601String(),
            "tags": ["学习", "笔记", "知识"],
          }
        ]
      },
      {
        "id": "career",
        "title": "💼 职业/技能类",
        "description": "职业发展和技能提升相关内容",
        "color": "#50C878",
        "icon": "work",
        "notes": [
          {
            "id": "career_001",
            "title": "工作与职业笔记",
            "content": "# 职业发展笔记\n\n记录工作中的重要内容和职业规划。\n\n## 本周工作总结\n- 完成的项目和任务\n- 遇到的挑战和解决方案\n- 学到的新技能\n\n## 职业目标\n- 短期目标（3个月）\n- 中期目标（1年）\n- 长期职业规划\n\n## 技能提升计划\n- [ ] 学习新技术\n- [ ] 参加培训课程\n- [ ] 建立专业网络",
            "imageUrl": "https://images.unsplash.com/photo-1517180102446-f3ece451e9d8?w=400",
            "createdAt": DateTime.now().toIso8601String(),
            "updatedAt": DateTime.now().toIso8601String(),
            "tags": ["工作", "职业", "技能"],
          }
        ]
      },
      {
        "id": "personal",
        "title": "🧠 记忆/个人成长类",
        "description": "个人成长、回忆和自我反思的空间",
        "color": "#FF6B9D",
        "icon": "favorite",
        "notes": [
          {
            "id": "personal_001",
            "title": "个人日记",
            "content": "# 个人成长日记\n\n记录生活中的点点滴滴和内心感悟。\n\n## 今日感悟\n写下今天最有意义的一件事...\n\n## 感恩清单\n- 感恩的人或事\n- 今天的小确幸\n- 值得庆祝的进步\n\n## 自我反思\n- 今天做得好的地方\n- 需要改进的方面\n- 明天的目标\n\n## 美好回忆\n记录值得珍藏的时刻...",
            "imageUrl": "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400",
            "createdAt": DateTime.now().toIso8601String(),
            "updatedAt": DateTime.now().toIso8601String(),
            "tags": ["日记", "成长", "反思"],
          }
        ]
      },
      {
        "id": "fun",
        "title": "🎮 趣味/儿童类",
        "description": "娱乐、游戏和儿童教育相关内容",
        "color": "#FFA500",
        "icon": "lightbulb",
        "notes": [
          {
            "id": "fun_001",
            "title": "🎮 趣味游戏笔记",
            "content": "# 趣味游戏与娱乐记录\n\n欢迎来到趣味/儿童类笔记！这里是记录游戏、娱乐和儿童教育内容的地方。\n\n## 🎯 游戏记录\n- 喜欢的游戏类型\n- 游戏心得体会\n- 有趣的游戏发现\n\n## 🎈 儿童教育\n- 教育游戏推荐\n- 亲子活动想法\n- 儿童学习方法\n\n## 🎭 娱乐活动\n- 有趣的电影或书籍\n- 娱乐活动计划\n- 创意项目想法\n\n## 🎪 趣味发现\n记录生活中有趣的发现和体验...",
            "imageUrl": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400",
            "createdAt": DateTime.now().toIso8601String(),
            "updatedAt": DateTime.now().toIso8601String(),
            "tags": ["游戏", "娱乐", "儿童"],
          }
        ]
      }
    ]
  };
  
  return JsonEncoder.withIndent('  ').convert(notes);
}

void generateUserGuide() {
  final guide = '''
# AI笔记应用 - 用户指南

## 🎯 应用概述
AI笔记应用是一个智能的笔记管理工具，帮助您组织学习、工作和生活中的各种信息。

## 📂 默认笔记类别

### 1. 📚 学术/学习类
**用途**：记录学习内容、课程笔记、研究资料
**包含子类别**：
- 学科学习：数学、语文、英语、科学等各学科知识点
- 考试准备：复习计划、重点难点、模拟练习
- 学习方法：高效学习技巧、记忆方法、时间管理
- 知识库：收集整理的有用知识和信息
**示例内容**：
- 课堂笔记和总结
- 学习计划和进度
- 重要概念和公式
- 复习要点

### 2. 💼 职业/技能类
**用途**：职业发展、工作记录、技能提升
**包含子类别**：
- 工作记录：日常工作内容、项目进展、会议纪要
- 职业规划：职业目标、发展路径、技能提升计划
- 技能学习：专业技能、软技能、工具使用方法
- 行业动态：行业趋势、最新技术、市场信息
**示例内容**：
- 工作总结和反思
- 职业规划和目标
- 技能学习记录
- 会议纪要

### 3. 🧠 记忆/个人成长类
**用途**：个人反思、生活记录、情感表达
**包含子类别**：
- 生活记录：日常生活、重要事件、人生感悟
- 个人成长：自我反思、目标设定、进步记录
- 记忆训练：记忆力练习、方法技巧、效果记录
- 情感日记：心情记录、情感表达、心理健康
**示例内容**：
- 日常生活记录
- 个人感悟和思考
- 目标设定和进展
- 感恩日记

### 4. 🎮 趣味/儿童类
**用途**：娱乐活动、游戏记录、儿童教育
**包含子类别**：
- 游戏娱乐：游戏攻略、娱乐活动、兴趣爱好
- 儿童教育：儿童学习方法、教育游戏、亲子活动
- 创意项目：手工制作、艺术创作、DIY项目
- 趣味发现：有趣的事物、新奇体验、娱乐资讯
**示例内容**：
- 游戏心得体会
- 儿童教育方法
- 创意项目记录
- 趣味活动安排

## 🚀 使用建议

1. **定期整理**：建议每周花时间整理和回顾笔记
2. **使用标签**：为笔记添加相关标签，便于搜索和分类
3. **及时记录**：有想法时立即记录，避免遗忘
4. **定期备份**：重要笔记建议定期备份

## 💡 小贴士

- 使用Markdown语法让笔记更美观
- 添加图片和链接丰富笔记内容
- 利用搜索功能快速找到所需信息
- 设置提醒确保重要事项不被遗漏

---
生成时间：${DateTime.now()}
''';

  final guideFile = File('assets/data/user_guide.md');
  guideFile.writeAsStringSync(guide);
  print('📖 生成用户指南：${guideFile.path}');
}
