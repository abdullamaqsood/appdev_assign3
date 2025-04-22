import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/note_model.dart';
import '../utils/shared_pref_helper.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  List<Note> _notes = [];

  NoteBloc() : super(NoteInitial()) {
    on<LoadNotes>((event, emit) async {
      _notes = await SharedPrefHelper.loadNotes();
      _sortNotes();
      emit(NotesLoaded(List.from(_notes)));
    });

    on<AddNote>((event, emit) async {
      _notes.add(event.note);
      _sortNotes();
      await SharedPrefHelper.saveNotes(_notes);
      emit(NotesLoaded(List.from(_notes)));
    });

    on<UpdateNote>((event, emit) async {
      final index = _notes.indexOf(event.oldNote);
      if (index != -1) {
        _notes[index] = event.updatedNote;
        _sortNotes();
        await SharedPrefHelper.saveNotes(_notes);
        emit(NotesLoaded(List.from(_notes)));
      }
    });

    on<DeleteNote>((event, emit) async {
      _notes.remove(event.note);
      _sortNotes();
      await SharedPrefHelper.saveNotes(_notes);
      emit(NotesLoaded(List.from(_notes)));
    });

    on<TogglePinNote>((event, emit) async {
      final index = _notes.indexOf(event.note);
      if (index != -1) {
        _notes[index].isPinned = !_notes[index].isPinned;
        _sortNotes();
        await SharedPrefHelper.saveNotes(_notes);
        emit(NotesLoaded(List.from(_notes)));
      }
    });
  }

  void _sortNotes() {
    _notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });
  }
}
