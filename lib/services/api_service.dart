import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

/// Book data model class
/// Represents a book in the application with all its properties
/// 
/// This class handles:
/// - JSON serialization/deserialization
/// - Data validation
/// - Type safety for book properties
class Book {
  /// Unique identifier for the book (from database)
  final String? id;
  
  /// Title of the book (required)
  final String title;
  
  /// Author of the book (required)
  final String author;
  
  /// Year the book was published
  final int? publishedYear;
  
  /// Description or summary of the book
  final String? description;
  
  /// Genre or category of the book
  final String? genre;
  
  /// Rating from 0.0 to 5.0
  final double? rating;
  
  /// Whether the book has been read
  final bool? isRead;
  
  /// Book cover image (base64 string or URL)
  final String? image;
  
  /// When the book was added to the database
  final DateTime? createdAt;

  /// Constructor for creating a new Book instance
  /// 
  /// [title] and [author] are required parameters
  /// All other parameters are optional with default values
  Book({
    this.id,
    required this.title,
    required this.author,
    this.publishedYear,
    this.description,
    this.genre,
    this.rating,
    this.isRead,
    this.image,
    this.createdAt,
  });

  /// Factory constructor to create a Book from JSON data
  /// 
  /// This is used when receiving data from the API
  /// Handles type conversion and null safety
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'], // MongoDB ObjectId
      title: json['title'],
      author: json['author'],
      publishedYear: json['publishedYear'],
      description: json['description'],
      genre: json['genre'],
      rating: json['rating']?.toDouble(), // Convert to double for precision
      isRead: json['isRead'],
      image: json['image'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) // Parse ISO date string
          : null,
    );
  }

  /// Convert Book object to JSON for API requests
  /// 
  /// This is used when sending data to the API
  /// Excludes id and createdAt as they're managed by the server
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'publishedYear': publishedYear,
      'description': description,
      'genre': genre,
      'rating': rating,
      'isRead': isRead,
      'image': image,
    };
  }
}

/// API Service class for communicating with the backend
/// 
/// This class handles all HTTP requests to the book management API
/// Provides methods for CRUD operations (Create, Read, Update, Delete)
/// Includes error handling and response validation
class ApiService {
  /// Base URL for all API endpoints
  /// Configured in app_config.dart for different environments
  static const String baseUrl = AppConfig.apiBaseUrl;

  // ========================================
  // CRUD OPERATIONS
  // ========================================

  /// Get all books from the server
  /// 
  /// Returns a list of Book objects
  /// Throws exception if server is unreachable or returns error
  static Future<List<Book>> getBooks() async {
    try {
      // Make GET request to /api/books endpoint
      final response = await http.get(Uri.parse('$baseUrl/books'));
      
      // Check if request was successful (200 OK)
      if (response.statusCode == 200) {
        // Parse JSON response
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Check if API returned success status
        if (data['success'] == true) {
          // Extract books array from response
          final List<dynamic> booksJson = data['data'];
          
          // Convert each JSON object to Book object
          return booksJson.map((json) => Book.fromJson(json)).toList();
        }
      }
      
      // If we reach here, something went wrong
      throw Exception('Failed to load books');
    } catch (e) {
      // Provide user-friendly error message
      throw Exception('Error connecting to server: $e');
    }
  }

  /// Create a new book on the server
  /// 
  /// [book] - The Book object to create
  /// Returns the created Book with server-generated ID
  /// Throws exception if creation fails
  static Future<Book> createBook(Book book) async {
    try {
      // Make POST request to /api/books endpoint
      final response = await http.post(
        Uri.parse('$baseUrl/books'),
        headers: {
          'Content-Type': 'application/json', // Tell server we're sending JSON
        },
        body: json.encode(book.toJson()), // Convert Book to JSON string
      );

      // Check if creation was successful (201 Created)
      if (response.statusCode == 201) {
        // Parse JSON response
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Check if API returned success status
        if (data['success'] == true) {
          // Return the created book with server-generated ID
          return Book.fromJson(data['data']);
        }
      }
      
      throw Exception('Failed to create book');
    } catch (e) {
      throw Exception('Error creating book: $e');
    }
  }

  /// Update an existing book on the server
  /// 
  /// [id] - The unique identifier of the book to update
  /// [book] - The updated Book object
  /// Returns the updated Book object
  /// Throws exception if update fails
  static Future<Book> updateBook(String id, Book book) async {
    try {
      // Make PUT request to /api/books/:id endpoint
      final response = await http.put(
        Uri.parse('$baseUrl/books/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(book.toJson()),
      );

      // Check if update was successful (200 OK)
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          return Book.fromJson(data['data']);
        }
      }
      
      throw Exception('Failed to update book');
    } catch (e) {
      throw Exception('Error updating book: $e');
    }
  }

  /// Delete a book from the server
  /// 
  /// [id] - The unique identifier of the book to delete
  /// Throws exception if deletion fails
  static Future<void> deleteBook(String id) async {
    try {
      // Make DELETE request to /api/books/:id endpoint
      final response = await http.delete(Uri.parse('$baseUrl/books/$id'));

      // Check if deletion was successful (200 OK)
      if (response.statusCode != 200) {
        throw Exception('Failed to delete book');
      }
    } catch (e) {
      throw Exception('Error deleting book: $e');
    }
  }

  // ========================================
  // UTILITY METHODS
  // ========================================

  /// Check if the server is running and accessible
  /// 
  /// Returns true if server responds to health check
  /// Returns false if server is unreachable
  static Future<bool> checkServerHealth() async {
    try {
      // Make GET request to health check endpoint
      final response = await http.get(Uri.parse('$baseUrl/health'));
      
      // Return true if server responds with 200 OK
      return response.statusCode == 200;
    } catch (e) {
      // Return false if any error occurs (network, timeout, etc.)
      return false;
    }
  }

  /// Get detailed error information from API response
  /// 
  /// [response] - The HTTP response from the server
  /// Returns a user-friendly error message
  static String _getErrorMessage(http.Response response) {
    try {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['message'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'Error parsing server response';
    }
  }
} 