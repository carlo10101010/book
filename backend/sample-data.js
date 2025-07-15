const Book = require('./models/Book');

const sampleBooks = [
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    publishedYear: 1960,
    isRead: true
  },
  {
    title: "1984",
    author: "George Orwell",
    publishedYear: 1949,
    isRead: false
  },
  {
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    publishedYear: 1925,
    isRead: true
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    publishedYear: 1813,
    isRead: false
  },
  {
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    publishedYear: 1937,
    isRead: true
  }
];

const seedDatabase = async () => {
  try {
    // Clear existing data
    await Book.deleteMany({});
    
    // Insert sample books
    const insertedBooks = await Book.insertMany(sampleBooks);
    console.log(`Successfully inserted ${insertedBooks.length} sample books`);
    
    // Display inserted books
    insertedBooks.forEach(book => {
      console.log(`- ${book.title} by ${book.author}`);
    });
    
  } catch (error) {
    console.error('Error seeding database:', error);
  }
};

// Run the seeding function if this file is executed directly
if (require.main === module) {
  require('dotenv').config();
  const connectDB = require('./config/database');
  
  connectDB().then(() => {
    seedDatabase().then(() => {
      console.log('Database seeding completed');
      process.exit(0);
    });
  });
}

module.exports = { sampleBooks, seedDatabase }; 