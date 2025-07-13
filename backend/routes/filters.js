const express = require('express');
const router = express.Router();
const Book = require('../models/Book');

// GET books by genre
router.get('/genre/:genre', async (req, res) => {
  try {
    const books = await Book.find({ genre: req.params.genre }).sort({ title: 1 });
    res.json(books);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching books by genre', error: error.message });
  }
});

// GET read/unread books
router.get('/status/:status', async (req, res) => {
  try {
    const isRead = req.params.status === 'read';
    const books = await Book.find({ isRead }).sort({ title: 1 });
    res.json(books);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching books by status', error: error.message });
  }
});

module.exports = router; 