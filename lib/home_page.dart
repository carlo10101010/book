import 'package:flutter/material.dart';
import 'add_book_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List books = [];

  // Initial demo books
  List get initialBooks => [
    {'title': 'The Great Gatsby', 'author': 'F. Scott Fitzgerald', 'publishedYear': 1925},
    {'title': 'To Kill a Mockingbird', 'author': 'Harper Lee', 'publishedYear': 1960},
    {'title': '1984', 'author': 'George Orwell', 'publishedYear': 1949},
    {'title': 'Pride and Prejudice', 'author': 'Jane Austen', 'publishedYear': 1813},
  ];

  void addBook(String title, String author, int year) {
    setState(() {
      books.add({
        'title': title,
        'author': author,
        'publishedYear': year,
      });
    });
  }

  void editBook(int index, String title, String author, int year) {
    setState(() {
      books[index] = {
        'title': title,
        'author': author,
        'publishedYear': year,
      };
    });
  }

  void deleteBook(int index) {
    setState(() {
      books.removeAt(index);
    });
  }

  Widget buildBookIcon(Map book, {bool isLarge = false}) {
    // Use consistent brown color scheme for all books
    final coverColor = Colors.brown.shade400;
    final spineColor = Colors.brown.shade700;
    final accentColor = Colors.brown.shade200;
    
    // Use consistent size for all books
    final baseSize = isLarge ? 80.0 : 40.0;
    final width = baseSize;
    final height = baseSize * 1.25;
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: coverColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Book spine
          Positioned(
            left: width * 0.2,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: spineColor,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
          // Book pages
          Positioned(
            left: width * 0.25,
            top: 2,
            right: 2,
            bottom: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Book title lines (consistent design)
          Positioned(
            left: width * 0.3,
            top: height * 0.15,
            right: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 2,
                  width: width * 0.5,
                  margin: EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                Container(
                  height: 2,
                  width: width * 0.4,
                  margin: EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                Container(
                  height: 2,
                  width: width * 0.45,
                  margin: EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
          // Decorative corner design (consistent for all books)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          // Subtle border design
          Positioned(
            top: 2,
            left: 2,
            right: 2,
            bottom: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: accentColor, width: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    books = List.from(initialBooks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📚 Book Viewer'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                books = List.from(initialBooks);
              });
            },
            tooltip: 'Reset to demo data',
          ),
        ],
      ),
      body: books.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 100,
                    child: buildBookIcon({'title': 'Demo', 'publishedYear': 2020}, isLarge: true),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No books found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your first book!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (_, index) {
                final book = books[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      book['title'] ?? 'Unknown Title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${book['author'] ?? 'Unknown Author'} (${book['publishedYear'] ?? 'Unknown Year'})',
                    ),
                    leading: buildBookIcon(book),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddBookPage(
                                  isEditing: true,
                                  initialTitle: book['title'] ?? '',
                                  initialAuthor: book['author'] ?? '',
                                  initialYear: book['publishedYear'] ?? 0,
                                ),
                              ),
                            );
                            if (result != null) {
                              editBook(index, result['title'], result['author'], result['year']);
                            }
                          },
                          tooltip: 'Edit book',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteBook(index),
                          tooltip: 'Delete book',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddBookPage()),
          );
          if (result != null) {
            addBook(result['title'], result['author'], result['year']);
          }
        },
        tooltip: 'Add new book',
      ),
    );
  }
}