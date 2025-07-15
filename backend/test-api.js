const axios = require('axios');

const BASE_URL = 'http://192.168.192.155:5000/api';

// Test data
const testBook = {
  title: "Test Book",
  author: "Test Author",
  description: "A test book for API testing",
  genre: "Test",
  rating: 4.0
};

async function testAPI() {
  try {
    console.log('🧪 Testing Book Management API...\n');

    // Test 2: Create a book
    console.log('\n2. Testing book creation...');
    const createResponse = await axios.post(`${BASE_URL}/books`, testBook);
    console.log('✅ Book created:', createResponse.data.title);
    const bookId = createResponse.data._id;

    // Test 3: Get all books
    console.log('\n3. Testing get all books...');
    const getAllResponse = await axios.get(`${BASE_URL}/books`);
    console.log(`✅ Found ${getAllResponse.data.length} books`);

    // Test 4: Get specific book
    console.log('\n4. Testing get specific book...');
    const getOneResponse = await axios.get(`${BASE_URL}/books/${bookId}`);
    console.log('✅ Retrieved book:', getOneResponse.data.title);

    // Test 5: Update book
    console.log('\n5. Testing book update...');
    const updateResponse = await axios.put(`${BASE_URL}/books/${bookId}`, {
      ...testBook,
      rating: 5.0
    });
    console.log('✅ Book updated, new rating:', updateResponse.data.rating);

    // Test 6: Search books
    console.log('\n6. Testing book search...');
    const searchResponse = await axios.get(`${BASE_URL}/books/search/test`);
    console.log(`✅ Search found ${searchResponse.data.length} books`);

    // Test 7: Delete book
    console.log('\n7. Testing book deletion...');
    const deleteResponse = await axios.delete(`${BASE_URL}/books/${bookId}`);
    console.log('✅ Book deleted:', deleteResponse.data.message);

    console.log('\n🎉 All tests passed! API is working correctly.');

  } catch (error) {
    console.error('❌ Test failed:', error.response?.data || error.message);
  }
}

// Run tests if this file is executed directly
if (require.main === module) {
  testAPI();
}

module.exports = { testAPI }; 