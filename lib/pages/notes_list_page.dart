import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/note_bloc.dart';
import '../models/note_model.dart';
import 'add_edit_note_page.dart';
import '../widgets/note_tile.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  String selectedCategory = 'All';

  List<String> getCategories(List<Note> notes) {
    final categories = notes.map((n) => n.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'NoteIt',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              if (state is NotesLoaded) {
                final categories = getCategories(state.notes);
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      items: categories
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(
                                  c,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedCategory = val);
                      },
                      underline: const SizedBox(),
                      isDense: true,
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NotesLoaded) {
            final filteredNotes = selectedCategory == 'All'
                ? state.notes
                : state.notes
                    .where((n) => n.category == selectedCategory)
                    .toList();

            if (filteredNotes.isEmpty) {
              return const Center(child: Text('Start adding notes!'));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
              child: GridView.builder(
                itemCount: filteredNotes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];

                  return Transform.rotate(
                    angle: -0.052,
                    child: NoteTile(note: note),
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade200,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditNotePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
