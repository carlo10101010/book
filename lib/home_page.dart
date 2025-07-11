import 'package:flutter/material.dart';
import 'add_book_page.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List books = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Initial demo books
  List get initialBooks => [
    {
      'title': 'The Great Gatsby',
      'author': 'F. Scott Fitzgerald',
      'publishedYear': 1925,
      'image': 'assets/gatsby.jpg',
    },
    {
      'title': 'To Kill a Mockingbird',
      'author': 'Harper Lee',
      'publishedYear': 1960,
      'image': 'assets/mockingbird.jpg',
    },
    {
      'title': '1984',
      'author': 'George Orwell',
      'publishedYear': 1949,
      'image': 'assets/1984.jpg',
    },
    {
      'title': 'Pride and Prejudice',
      'author': 'Jane Austen',
      'publishedYear': 1813,
      'image': 'assets/pride-prejudice.jpg',
    },
  ];

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
    books = List.from(initialBooks);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void addBook(String title, String author, int year, {String? image}) {
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
    // Collect images already used in the current session
    final usedImages = books.map((b) => b['image'] as String?).where((img) => img != null).toSet();
    // Find unused images
    final unusedImages = availableBookImages.where((img) => !usedImages.contains(img)).toList();
    String assignedImage;
    if (unusedImages.isNotEmpty) {
      assignedImage = unusedImages[Random().nextInt(unusedImages.length)];
    } else {
      assignedImage = defaultBookImage;
    }
    setState(() {
      books.add({
        'title': title,
        'author': author,
        'publishedYear': year,
        'image': image ?? assignedImage,
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

  Widget buildBeautifulBookIcon(Map book, {bool isLarge = false}) {
    final baseSize = isLarge ? 100.0 : 60.0;
    final width = baseSize;
    final height = baseSize * 1.4;

    if (book['image'] != null && book['image'].toString().isNotEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            book['image'],
            fit: BoxFit.cover,
            width: width,
            height: height,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/brownbook.jpg',
                fit: BoxFit.cover,
                width: width,
                height: height,
              );
            },
          ),
        ),
      );
    }
    final titleHash = book['title'].hashCode;
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
                  width: width * 0.5,
                  margin: EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                Container(
                  height: 2,
                  width: width * 0.4,
                  margin: EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                Container(
                  height: 2,
                  width: width * 0.45,
                  margin: EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
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
              Colors.black.withOpacity(0.45), // Optional: darken for readability
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements (remain on top of the image)
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFF8B4513).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Color(0xFFA0522D).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFCD853F).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Book pattern background
            Positioned.fill(
              child: CustomPaint(
                painter: BookPatternPainter(),
              ),
            ),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Beautiful header
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
                                'My Library',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${books.length} books in collection',
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
                books = List.from(initialBooks);
              });
            },
            tooltip: 'Reset to demo data',
          ),
        ],
      ),
                  ),
                  
                  // Book list
                  Expanded(
                    child: books.isEmpty
                        ? FadeTransition(
                            opacity: _fadeAnimation,
                            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                                    padding: EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5E9DA), // light brown
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
                                      {'title': 'Demo', 'publishedYear': 2020},
                                      isLarge: true,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                  Text(
                                    'Your library is empty',
                                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                                    'Start building your collection by adding your first book!',
                                    style: Theme.of(context).textTheme.bodyMedium,
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
                                    color: Color(0xFFF5E9DA), // light brown
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
                      book['title'] ?? 'Unknown Title',
                                                  style: Theme.of(context).textTheme.titleLarge,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  book['author'] ?? 'Unknown Author',
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
                                                    '${book['publishedYear'] ?? 'Unknown Year'}',
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
          ],
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
            addBook(result['title'], result['author'], result['year']);
          }
        },
        tooltip: 'Add new book',
        ),
      ),
    );
  }
}

// Custom painter for book pattern background
class BookPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF8B4513).withOpacity(0.03)
      ..strokeWidth = 1;

    // Draw subtle book spine lines
    for (int i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    // Draw page lines
    for (int i = 0; i < size.height; i += 60) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    // Draw decorative dots
    final dotPaint = Paint()
      ..color = Color(0xFF8B4513).withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < size.width; i += 80) {
      for (int j = 0; j < size.height; j += 80) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}