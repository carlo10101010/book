const express = require('express');
const router = express.Router();
const Book = require('../models/Book');

// GET all books
router.get('/', async (req, res) => {
  try {
    const books = await Book.find().sort({ createdAt: -1 });
    res.json({
      success: true,
      count: books.length,
      data: books
    });
  } catch (error) {
    res.status(500).json({ 
      success: false,
      message: 'Error fetching books', 
      error: error.message 
    });
  }
});

// POST create new book
router.post('/', async (req, res) => {
  try {
    const { title, author, publishedYear, isRead } = req.body;
    
    // Validate required fields
    if (!title || !author) {
      return res.status(400).json({
        success: false,
        message: 'Title and author are required'
      });
    }

    const book = new Book({
      title,
      author,
      publishedYear,
      isRead: isRead || false
    });

    const savedBook = await book.save();
    res.status(201).json({
      success: true,
      message: 'Book created successfully',
      data: savedBook
    });
  } catch (error) {
    res.status(400).json({ 
      success: false,
      message: 'Error creating book', 
      error: error.message 
    });
  }
});

// GET single book by ID
router.get('/:id', async (req, res) => {
  try {
    const book = await Book.findById(req.params.id);
    if (!book) {
      return res.status(404).json({ 
        success: false,
        message: 'Book not found' 
      });
    }
    res.json({
      success: true,
      data: book
    });
  } catch (error) {
    res.status(500).json({ 
      success: false,
      message: 'Error fetching book', 
      error: error.message 
    });
  }
});

// PUT update book
router.put('/:id', async (req, res) => {
  try {
    const { title, author, publishedYear, isRead } = req.body;
    
    const updatedBook = await Book.findByIdAndUpdate(
      req.params.id,
      {
        title,
        author,
        publishedYear,
        isRead
      },
      { new: true, runValidators: true }
    );
    
    if (!updatedBook) {
      return res.status(404).json({ 
        success: false,
        message: 'Book not found' 
      });
    }
    
    res.json({
      success: true,
      message: 'Book updated successfully',
      data: updatedBook
    });
  } catch (error) {
    res.status(400).json({ 
      success: false,
      message: 'Error updating book', 
      error: error.message 
    });
  }
});

// DELETE book
router.delete('/:id', async (req, res) => {
  try {
    const deletedBook = await Book.findByIdAndDelete(req.params.id);
    if (!deletedBook) {
      return res.status(404).json({ 
        success: false,
        message: 'Book not found' 
      });
    }
    res.json({ 
      success: true,
      message: 'Book deleted successfully' 
    });
  } catch (error) {
    res.status(500).json({ 
      success: false,
      message: 'Error deleting book', 
      error: error.message 
    });
  }
});

module.exports = router; 