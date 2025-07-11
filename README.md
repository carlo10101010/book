# Book Library Flutter App

A beautiful Flutter app for managing your book collection, connected to a Node.js backend.

## Features

- 📚 **Book Management**: Add, edit, and delete books
- 🎨 **Beautiful UI**: Modern, book-themed design with animations
- 🔄 **Real-time Sync**: Connected to backend API
- 📱 **Cross-platform**: Works on Android, iOS, and web
- 🌐 **API Integration**: Full CRUD operations with backend

## Prerequisites

- Flutter SDK (latest version)
- Node.js backend running (see backend README)
- MongoDB database

## Setup Instructions

### 1. Install Dependencies

```bash
cd book
flutter pub get
```

### 2. Configure API URL

Edit `lib/config/app_config.dart` to match your backend URL:

```dart
// For different environments:
static const String apiBaseUrl = 'http://192.168.192.155:5000/api'; // Network IP
// static const String apiBaseUrl = 'http://localhost:5000/api'; // Development
// static const String apiBaseUrl = 'http://10.0.2.2:5000/api'; // Android Emulator
// static const String apiBaseUrl = 'https://your-server.com/api'; // Production
```

### 3. Start the Backend

Make sure your Node.js backend is running:

```bash
cd ../backend
npm start
```

### 4. Run the Flutter App

```bash
# For development
flutter run

# For specific platform
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS
```

## API Integration

The app connects to the backend API with these endpoints:

- `GET /api/books` - Get all books
- `POST /api/books` - Create new book
- `PUT /api/books/:id` - Update book
- `DELETE /api/books/:id` - Delete book
- `GET /api/health` - Health check

## Book Data Structure

```json
{
  "title": "To Kill a Mockingbird",
  "author": "Harper Lee",
  "publishedYear": 1960
}
```

## Features

### 📖 Book Management
- Add new books with title, author, and year
- Edit existing book details
- Delete books from your collection
- View all books in a beautiful list

### 🎨 UI Features
- Book-themed design with brown color scheme
- Animated book covers with gradient colors
- Smooth transitions and animations
- Responsive layout for different screen sizes

### 🔄 Real-time Updates
- Automatic refresh when data changes
- Error handling for network issues
- Loading states and progress indicators
- Success/error notifications

## Troubleshooting

### Connection Issues
1. **Check backend is running**: Ensure the Node.js server is started
2. **Verify API URL**: Check `lib/config/app_config.dart` for correct URL
3. **Network permissions**: For Android, add internet permission to `android/app/src/main/AndroidManifest.xml`

### Platform-specific Issues
- **Network IP**: Use `http://192.168.192.155:5000/api`
- **Android Emulator**: Use `http://10.0.2.2:5000/api`
- **iOS Simulator**: Use `http://localhost:5000/api`
- **Physical Device**: Use your computer's IP address

### Common Errors
- **"Cannot connect to server"**: Backend not running or wrong URL
- **"Error adding book"**: Check network connection and backend logs
- **Build errors**: Run `flutter clean` and `flutter pub get`

## Development

### Project Structure
```
lib/
├── config/
│   └── app_config.dart      # API configuration
├── services/
│   └── api_service.dart     # API communication
├── main.dart                # App entry point
├── home_page.dart           # Main screen
└── add_book_page.dart       # Add/edit book screen
```

### Adding Features
1. **New API endpoints**: Update `api_service.dart`
2. **UI changes**: Modify `home_page.dart` or `add_book_page.dart`
3. **Configuration**: Edit `app_config.dart`

## Deployment

### Web Deployment
```bash
flutter build web
# Deploy the build/web folder to your hosting service
```

### Mobile Deployment
```bash
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the MIT License.
