import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/note_bloc.dart';
import 'pages/notes_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoteBloc()..add(LoadNotes()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NoteIt',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFFFEF6FF),
        ),
        home: const NotesListPage(),
      ),
    );
  }
}
