part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {}

class AddNote extends NoteEvent {
  final Note note;
  AddNote(this.note);
}

class UpdateNote extends NoteEvent {
  final Note oldNote;
  final Note updatedNote;
  UpdateNote(this.oldNote, this.updatedNote);
}

class DeleteNote extends NoteEvent {
  final Note note;
  DeleteNote(this.note);
}

class TogglePinNote extends NoteEvent {
  final Note note;
  TogglePinNote(this.note);
}
