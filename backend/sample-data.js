const Book = require('./models/Book');

const sampleBooks = [
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    description: "A powerful story of racial injustice and loss of innocence in the American South.",
    isbn: "978-0-06-112008-4",
    publishedYear: 1960,
    genre: "Fiction",
    coverImage: "Mockingbird.jpg",
    rating: 4.5,
    isRead: true
  },
  {
    title: "1984",
    author: "George Orwell",
    description: "A dystopian novel about totalitarianism and surveillance society.",
    isbn: "978-0-452-28423-4",
    publishedYear: 1949,
    genre: "Science Fiction",
    coverImage: "1984.jpg",
    rating: 4.3,
    isRead: false
  },
  {
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    description: "A story of the Jazz Age and the American Dream.",
    isbn: "978-0-7432-7356-5",
    publishedYear: 1925,
    genre: "Fiction",
    coverImage: "gatsby.jpg",
    rating: 4.2,
    isRead: true
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    description: "A classic romance novel about love and marriage in Georgian-era England.",
    isbn: "978-0-14-143951-8",
    publishedYear: 1813,
    genre: "Romance",
    coverImage: "pride-prejudice.jpg",
    rating: 4.4,
    isRead: false
  },
  {
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    description: "A fantasy novel about a hobbit's journey with dwarves to reclaim their homeland.",
    isbn: "978-0-261-10221-4",
    publishedYear: 1937,
    genre: "Fantasy",
    coverImage: "hobbit.jpg",
    rating: 4.6,
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