# Book Management Backend

A RESTful API backend for managing books built with Node.js, Express, and MongoDB.

## Features

- CRUD operations for books
- Search functionality
- Filter by genre and read status
- MongoDB database integration
- RESTful API design
- Error handling and validation

## Prerequisites

- Node.js (v14 or higher)
- MongoDB (local or cloud instance)
- npm or yarn

## Installation

1. Install dependencies:
```bash
npm install
```

2. Create a `.env` file in the root directory with the following variables:
```
PORT=5000
MONGODB_URI=mongodb://localhost:27017/bookstore
NODE_ENV=development
HOST=0.0.0.0
```

3. Start the server:
```bash
npm start
```

## API Endpoints

### Books

#### GET /api/books
Get all books
- **Response**: Array of book objects

#### GET /api/books/:id
Get a specific book by ID
- **Parameters**: `id` - Book ID
- **Response**: Book object

#### POST /api/books
Create a new book
- **Body**: Book object with required fields (title, author)
- **Response**: Created book object

#### PUT /api/books/:id
Update a book
- **Parameters**: `id` - Book ID
- **Body**: Updated book object
- **Response**: Updated book object

#### DELETE /api/books/:id
Delete a book
- **Parameters**: `id` - Book ID
- **Response**: Success message

#### GET /api/books/genre/:genre
Get books by genre
- **Parameters**: `genre` - Genre name
- **Response**: Array of books in the specified genre

#### GET /api/books/status/:status
Get books by read status
- **Parameters**: `status` - "read" or "unread"
- **Response**: Array of books with the specified status

#### GET /api/books/search/:query
Search books by title, author, or description
- **Parameters**: `query` - Search term
- **Response**: Array of matching books

### Health Check

#### GET /api/health
Check server status
- **Response**: Server status object

## Book Schema

```javascript
{
  title: String (required),
  author: String (required),
  description: String,
  isbn: String,
  publishedYear: Number,
  genre: String,
  coverImage: String,
  rating: Number (0-5),
  isRead: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

## Project Structure

```
backend/
├── config/
│   └── database.js
├── models/
│   └── Book.js
├── routes/
│   └── books.js
├── server.js
├── package.json
└── README.md
```

## Development

To run in development mode with auto-restart:
```bash
npm install -g nodemon
nodemon server.js
```

## Error Handling

The API includes comprehensive error handling:
- 400: Bad Request (validation errors)
- 404: Not Found (resource not found)
- 500: Internal Server Error

All error responses include a message and details about the error. 