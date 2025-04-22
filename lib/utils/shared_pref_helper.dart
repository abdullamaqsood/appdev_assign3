import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';

class SharedPrefHelper {
  static const _notesKey = 'NOTES';

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = Note.encode(notes);
    await prefs.setString(_notesKey, encoded);
  }

  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_notesKey);
    if (json == null || json.isEmpty) return [];
    return Note.decode(json);
  }
}
