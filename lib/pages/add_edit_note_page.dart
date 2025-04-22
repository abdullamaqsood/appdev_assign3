import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../models/note_model.dart';
import '../blocs/note_bloc.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'Personal';
  bool _isPinned = false;
  List<XFile> _images = [];

  final List<String> _categories = ['Personal', 'Work', 'Study'];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedCategory = widget.note!.category;
      _isPinned = widget.note!.isPinned;
      _images = widget.note!.imagePaths.map((path) => XFile(path)).toList();
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFFFF6FB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Future<void> _pickImages() async {
    final picked = await ImagePicker().pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(
          picked.where(
              (img) => !_images.any((existing) => existing.path == img.path)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FB),
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Note' : 'Add Note'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: _inputDecoration('Title'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _contentController,
              decoration: _inputDecoration('Content'),
              maxLines: 6,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
              decoration: _inputDecoration('Category'),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Checkbox(
                  value: _isPinned,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _isPinned = val);
                    }
                  },
                ),
                const Text('Pin this note'),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text('Add Image'),
            ),
            const SizedBox(height: 10),
            if (_images.isNotEmpty)
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final image = _images[index];
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(File(image.path),
                              width: 80, height: 80, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: -8,
                          right: -8,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _images.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final note = Note(
                  title: _titleController.text.trim(),
                  content: _contentController.text.trim(),
                  category: _selectedCategory,
                  isPinned: _isPinned,
                  imagePaths: _images.map((x) => x.path).toList(),
                );

                if (_titleController.text.trim().isEmpty ||
                    _contentController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title or content cannot be empty!'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                if (isEdit) {
                  context.read<NoteBloc>().add(UpdateNote(widget.note!, note));
                } else {
                  context.read<NoteBloc>().add(AddNote(note));
                }

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade200,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(isEdit ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
