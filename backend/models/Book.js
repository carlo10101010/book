const mongoose = require('mongoose');

const bookSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  author: {
    type: String,
    required: true,
    trim: true
  },
  publishedYear: {
    type: Number
  },
  description: {
    type: String,
    trim: true,
    default: ""
  },
  genre: {
    type: String,
    trim: true,
    default: "General"
  },
  rating: {
    type: Number,
    min: 0,
    max: 5,
    default: 0
  },
  isRead: {
    type: Boolean,
    default: false
  },
  image: {
    type: String, // URL or base64 string for the book cover image
    default: ""
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Book', bookSchema); 