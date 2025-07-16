/// Application configuration class
/// Contains all the configuration settings for the Book Library app
class AppConfig {
  // ========================================
  // API CONFIGURATION
  // ========================================
  
  /// Base URL for the backend API
  /// This is the main endpoint that the Flutter app will connect to
  /// 
  /// Network IP Configuration:
  /// - Use this IP address for devices on the same network
  /// - Allows physical devices (phones, tablets) to connect to the backend
  /// - Works for both Android and iOS devices on the same network
  static const String apiBaseUrl = 'http://192.168.192.170:5000/api';
  
  // Alternative configurations for different environments:
  
  /// Development environment (localhost)
  /// Use this for development on the same machine
  // static const String apiBaseUrl = 'http://localhost:5000/api';
  
  /// Android Emulator configuration
  /// Special IP that Android emulator uses to access host machine
  // static const String apiBaseUrl = 'http://10.0.2.2:5000/api';
  
  /// iOS Simulator configuration
  /// iOS simulator can use localhost to access host machine
  // static const String apiBaseUrl = 'http://localhost:5000/api';
  
  /// Production environment
  /// Use this for deployed applications with a real domain
  // static const String apiBaseUrl = 'https://your-server.com/api';
  
  // ========================================
  // APP METADATA
  // ========================================
  
  /// Application name displayed in the UI
  static const String appName = 'Book Library';
  
  /// Application version for tracking updates
  static const String appVersion = '1.0.0';
  
  // ========================================
  // NETWORK TIMEOUT CONFIGURATION
  // ========================================
  
  /// Connection timeout in milliseconds
  /// How long to wait for initial connection to server
  static const int connectionTimeout = 10000; // 10 seconds
  
  /// Receive timeout in milliseconds
  /// How long to wait for data from server after connection
  static const int receiveTimeout = 10000; // 10 seconds
  
  // ========================================
  // DEBUG CONFIGURATION
  // ========================================
  
  /// Enable debug logging for API calls
  /// Set to true to see detailed API request/response logs
  static const bool enableApiLogging = true;
  
  /// Enable network error details
  /// Set to true to see detailed error messages
  static const bool enableErrorDetails = true;
} 