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

class _AddBookPageState extends State<AddBookPage> with TickerProviderStateMixin {
  late final TextEditingController titleCtrl;
  late final TextEditingController authorCtrl;
  late final TextEditingController yearCtrl;
  String errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  /// Initialize controllers and animation
  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.initialTitle);
    authorCtrl = TextEditingController(text: widget.initialAuthor);
    // Set yearCtrl to empty if initialYear is 0
    yearCtrl = TextEditingController(text: widget.initialYear == 0 ? '' : widget.initialYear.toString());
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _animationController.forward();
  }

  /// Dispose controllers
  @override
  void dispose() {
    titleCtrl.dispose();
    authorCtrl.dispose();
    yearCtrl.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Handle book addition and return data to parent
  void addBook() {
    if (titleCtrl.text.isEmpty || authorCtrl.text.isEmpty || yearCtrl.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      return;
    }

    // Return the book data to parent page (no image)
    Navigator.pop(context, {
      'title': titleCtrl.text.trim(),
      'author': authorCtrl.text.trim(),
      'year': int.tryParse(yearCtrl.text) ?? 0,
      'image': null,
    });
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
              Colors.black.withOpacity(0.45),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements (remain on top of the image)
            Positioned(
              top: -30,
              left: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFF8B4513).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Color(0xFFA0522D).withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 300,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFCD853F).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Book pattern background
            Positioned.fill(
              child: CustomPaint(
                painter: BookFormPatternPainter(),
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
                            widget.isEditing ? Icons.edit : Icons.add,
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
                                widget.isEditing ? 'Edit Book' : 'Add New Book',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.isEditing ? 'Update your book details' : 'Add a new book to your library',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  
                  // Form content
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Only show text fields and button
                              TextField(
                                controller: titleCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Book Title',
                                  prefixIcon: Icon(Icons.text_fields),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: authorCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Author Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: yearCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Published Year',
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                              SizedBox(height: 24),
                              if (errorMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Text(
                                    errorMessage,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ElevatedButton(
                                onPressed: addBook,
                                child: Text(widget.isEditing ? 'Update Book' : 'Add Book'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for book form pattern background
class BookFormPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF8B4513).withOpacity(0.02)
      ..strokeWidth = 1;

    // Draw subtle grid pattern
    for (int i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    for (int i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    // Draw decorative corner elements
    final cornerPaint = Paint()
      ..color = Color(0xFF8B4513).withOpacity(0.04)
      ..style = PaintingStyle.fill;

    // Top-left corner decoration
    canvas.drawCircle(Offset(50, 50), 3, cornerPaint);
    canvas.drawCircle(Offset(100, 50), 2, cornerPaint);
    canvas.drawCircle(Offset(50, 100), 2, cornerPaint);

    // Bottom-right corner decoration
    canvas.drawCircle(Offset(size.width - 50, size.height - 50), 3, cornerPaint);
    canvas.drawCircle(Offset(size.width - 100, size.height - 50), 2, cornerPaint);
    canvas.drawCircle(Offset(size.width - 50, size.height - 100), 2, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}