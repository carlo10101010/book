import 'package:flutter/material.dart';
import 'add_book_page.dart';
import 'services/api_service.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Book> books = [];
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> availableBookImages = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
    'assets/4.jpg',
    'assets/5.jpg',
    'assets/addbooks.jpg',
    'assets/books.jpg',
  ];

  final String defaultBookImage = 'assets/brownbook.jpg';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadBooks();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedBooks = await ApiService.getBooks();
      setState(() {
        books = loadedBooks;
        isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addBook(String title, String author, int year) async {
    final nameRegExp = RegExp(r'^[A-Za-z ]+[0-9]*[A-D]*$');
    String? error;
    if (title.trim().isEmpty || !nameRegExp.hasMatch(title)) {
      error = 'Title must only contain letters and spaces.';
    } else if (author.trim().isEmpty || !nameRegExp.hasMatch(author)) {
      error = 'Author must only contain letters and spaces.';
    } else if (year == 0 || year > 2025) {
      error = 'Year must be a number and 2025 or below.';
    }
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    try {
      final newBook = Book(
        title: title.trim(),
        author: author.trim(),
        publishedYear: year,
      );

      final createdBook = await ApiService.createBook(newBook);
      setState(() {
        books.insert(0, createdBook);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding book: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> editBook(int index, String title, String author, int year) async {
    try {
      final bookToUpdate = books[index];
      final updatedBook = Book(
        title: title.trim(),
        author: author.trim(),
        publishedYear: year,
      );

      final result = await ApiService.updateBook(bookToUpdate.id!, updatedBook);
      setState(() {
        books[index] = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating book: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deleteBook(int index) async {
    try {
      final bookToDelete = books[index];
      await ApiService.deleteBook(bookToDelete.id!);
      setState(() {
        books.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting book: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildBeautifulBookIcon(Book book, {bool isLarge = false}) {
    final baseSize = isLarge ? 100.0 : 60.0;
    final width = baseSize;
    final height = baseSize * 1.4;
    // Always show a colored/gradient book cover (no image field)
    return _buildGradientCover(book, width, height);
  }

  Widget _buildGradientCover(Book book, double width, double height) {
    final titleHash = book.title.hashCode;
    final colors = [
      Color(0xFF8B4513),
      Color(0xFFA0522D),
      Color(0xFFCD853F),
      Color(0xFFD2691E),
      Color(0xFFB8860B),
      Color(0xFFDAA520),
    ];
    final coverColor = colors[titleHash.abs() % colors.length];
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            coverColor,
            coverColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: coverColor.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: width * 0.15,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    coverColor.withOpacity(0.7),
                    coverColor.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            left: width * 0.2,
            top: 3,
            right: 3,
            bottom: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: width * 0.25,
            top: height * 0.2,
            right: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 2,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    color: coverColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                SizedBox(height: 2),
                Container(
                  height: 1,
                  width: width * 0.3,
                  decoration: BoxDecoration(
                    color: coverColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  height: 1,
                  width: width * 0.35,
                  decoration: BoxDecoration(
                    color: coverColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFF8B4513),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.library_books,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Book Library',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Manage your collection',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        _loadBooks();
                      },
                      tooltip: 'Refresh data',
                    ),
                  ],
                ),
              ),
              
              // Book list
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : books.isEmpty
                        ? FadeTransition(
                            opacity: _fadeAnimation,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5E9DA),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: buildBeautifulBookIcon(
                                      Book(title: 'Demo', author: 'Demo Author', publishedYear: 2020),
                                      isLarge: true,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    'Your library is empty',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Colors.white, // <-- changed to white
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Start building your collection by adding your first book!',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white, // <-- changed to white
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                final book = books[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  child: Card(
                                    color: Color(0xFFF5E9DA),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          buildBeautifulBookIcon(book),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  book.title,
                                                  style: Theme.of(context).textTheme.titleLarge,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  book.author,
                                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                    color: Color(0xFF8B4513),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF8B4513).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    '${book.publishedYear ?? 'Unknown Year'}',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: Color(0xFF8B4513),
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit, color: Color(0xFF8B4513)),
                                                onPressed: () async {
                                                  final result = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => AddBookPage(
                                                        isEditing: true,
                                                        initialTitle: book.title,
                                                        initialAuthor: book.author,
                                                        initialYear: book.publishedYear ?? 0,
                                                      ),
                                                    ),
                                                  );
                                                  if (result != null) {
                                                    await editBook(index, result['title'], result['author'], result['year']);
                                                  }
                                                },
                                                tooltip: 'Edit book',
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete, color: Color(0xFFEF4444)),
                                                onPressed: () => deleteBook(index),
                                                tooltip: 'Delete book',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8B4513),
              Color(0xFFA0522D),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF8B4513).withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          child: Icon(Icons.add, size: 28),
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddBookPage()),
            );
            if (result != null) {
              await addBook(result['title'], result['author'], result['year']);
            }
          },
          tooltip: 'Add new book',
        ),
      ),
    );
  }
}