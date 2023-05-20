const express = require('express');
const mongoose = require('mongoose');

// Create Express app
const app = express();
const port = 4000;


app.use(function (req, res, next) {
    res.header("Access-Control-Allow-origin", "*")
    res.setHeader('Access-Control-Allow-Methods', "GET,POST,OPTIONS")
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept")
    next();
})


// MongoDB connection URL
const url = ''; // your database url 

// Define the counter schema
const counterSchema = new mongoose.Schema({
  value: {
    type: Number,
    default: 0
  }
});

// Define the counter model
const Counter = mongoose.model('Counter', counterSchema);

// Connect to MongoDB
mongoose.connect(url, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('Connected to MongoDB');
  })
  .catch((error) => {
    console.error('Error connecting to MongoDB:', error);
  });


// Get counter value
app.get('/counter',async (req, res) => {
  try {
    const counter = await Counter.findOne();
    res.json({ value: counter.value });
  } catch (error) {
    console.error('Error retrieving counter value:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Increment the counter value
app.post('/increment', async (req, res) => {
  try {
    // Find the counter document and increment the value
    const counter = await Counter.findOneAndUpdate({}, { $inc: { value: 1 } }, { new: true, upsert: true });

    // Send the updated counter value as response
    res.json({ value: counter.value });
  } catch (error) {
    console.error('Error incrementing counter:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.post('/decrement', async (req, res) => {
  try {
    
    const counter = await Counter.findOneAndUpdate({}, { $inc: { value: -1 } }, { new: true, upsert: true });
    res.json({ value: counter.value });
  } catch (error) {
    console.error('Error decrementing counter:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
