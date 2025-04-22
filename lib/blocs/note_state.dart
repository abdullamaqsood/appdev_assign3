part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NotesLoaded extends NoteState {
  final List<Note> notes;
  NotesLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}
