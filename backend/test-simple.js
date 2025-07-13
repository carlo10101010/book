const axios = require('axios');

const BASE_URL = 'http://192.168.192.155:5000/api';

// Test data matching user's format
const testBook = {
  "title": "To Kill a Mockingbird",
  "author": "Harper Leeeee",
  "publishedYear": 1960
};

async function testSimpleAPI() {
  try {
    console.log('🧪 Testing Simple Book API...\n');

    // Test 1: Health Check
    console.log('1. Testing health check...');
    const healthResponse = await axios.get(`${BASE_URL}/health`);
    console.log('✅ Health check passed:', healthResponse.data);

    // Test 2: Create a book with user's format
    console.log('\n2. Testing book creation with your JSON format...');
    const createResponse = await axios.post(`${BASE_URL}/books`, testBook);
    console.log('✅ Book created successfully!');
    console.log('📖 Book details:', createResponse.data.data);
    const bookId = createResponse.data.data._id;

    // Test 3: Get all books
    console.log('\n3. Testing get all books...');
    const getAllResponse = await axios.get(`${BASE_URL}/books`);
    console.log(`✅ Found ${getAllResponse.data.count} books`);

    // Test 4: Get specific book
    console.log('\n4. Testing get specific book...');
    const getOneResponse = await axios.get(`${BASE_URL}/books/${bookId}`);
    console.log('✅ Retrieved book:', getOneResponse.data.data.title);

    // Test 5: Update book
    console.log('\n5. Testing book update...');
    const updateData = {
      "title": "To Kill a Mockingbird (Updated)",
      "author": "Harper Leeeee",
      "publishedYear": 1960,
      "rating": 5
    };
    const updateResponse = await axios.put(`${BASE_URL}/books/${bookId}`, updateData);
    console.log('✅ Book updated successfully!');

    // Test 6: Delete book
    console.log('\n6. Testing book deletion...');
    const deleteResponse = await axios.delete(`${BASE_URL}/books/${bookId}`);
    console.log('✅ Book deleted successfully!');

    console.log('\n🎉 All tests passed! Your API is working perfectly with your JSON format.');

  } catch (error) {
    console.error('❌ Test failed:', error.response?.data || error.message);
  }
}

// Run tests if this file is executed directly
if (require.main === module) {
  testSimpleAPI();
}

module.exports = { testSimpleAPI }; 