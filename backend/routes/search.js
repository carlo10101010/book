const express = require('express');
const router = express.Router();
const Book = require('../models/Book');

// Search books
router.get('/:query', async (req, res) => {
  try {
    const query = req.params.query;
    const books = await Book.find({
      $or: [
        { title: { $regex: query, $options: 'i' } },
        { author: { $regex: query, $options: 'i' } },
        { description: { $regex: query, $options: 'i' } }
      ]
    }).sort({ title: 1 });
    res.json(books);
  } catch (error) {
    res.status(500).json({ message: 'Error searching books', error: error.message });
  }
});

module.exports = router; 