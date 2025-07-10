import 'package:flutter/material.dart';

class AddBookPage extends StatefulWidget {
  final bool isEditing;
  final String initialTitle;
  final String initialAuthor;
  final int initialYear;

  const AddBookPage({
    Key? key,
    this.isEditing = false,
    this.initialTitle = '',
    this.initialAuthor = '',
    this.initialYear = 0,
  }) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  late final TextEditingController titleCtrl;
  late final TextEditingController authorCtrl;
  late final TextEditingController yearCtrl;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.initialTitle);
    authorCtrl = TextEditingController(text: widget.initialAuthor);
    yearCtrl = TextEditingController(text: widget.initialYear.toString());
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    authorCtrl.dispose();
    yearCtrl.dispose();
    super.dispose();
  }

  void addBook() {
    if (titleCtrl.text.isEmpty || authorCtrl.text.isEmpty || yearCtrl.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      return;
    }

    // Return the book data to parent page
    Navigator.pop(context, {
      'title': titleCtrl.text.trim(),
      'author': authorCtrl.text.trim(),
      'year': int.tryParse(yearCtrl.text) ?? 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? '✏️ Edit Book' : '➕ Add New Book'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
                hintText: 'Enter book title',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: authorCtrl,
              decoration: InputDecoration(
                labelText: 'Author',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                hintText: 'Enter author name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: yearCtrl,
              decoration: InputDecoration(
                labelText: 'Published Year',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
                hintText: 'Enter publication year',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red.shade800),
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton(
              onPressed: addBook,
              child: Text(widget.isEditing ? 'Update Book' : 'Add Book'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}