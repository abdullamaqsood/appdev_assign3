import 'dart:convert';

class Note {
  String title;
  String content;
  String category;
  bool isPinned;
  List<String> imagePaths;

  Note({
    required this.title,
    required this.content,
    required this.category,
    this.isPinned = false,
    this.imagePaths = const [],
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        title: json['title'],
        content: json['content'],
        category: json['category'],
        isPinned: json['isPinned'] ?? false,
        imagePaths: List<String>.from(json['imagePaths'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'category': category,
        'isPinned': isPinned,
        'imagePaths': imagePaths,
      };

  static List<Note> decode(String notes) => (jsonDecode(notes) as List<dynamic>)
      .map((e) => Note.fromJson(e))
      .toList();

  static String encode(List<Note> notes) =>
      jsonEncode(notes.map((e) => e.toJson()).toList());
}
