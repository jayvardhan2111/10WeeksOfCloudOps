#!/bin/bash

sudo su
sudo yum install -y gcc-c++ make 
sudo curl -sL https://rpm.nodesource.com/setup_19.x | sudo -E bash - 
sudo yum install git -y
sudo yum install -y nodejs 


mkdir /home/ec2-user/app
cd app/
npm init -y
npm i express mongoose
cat <<EOF > app.js
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



app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
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
EOF

cat <<EOF > index.html
<!DOCTYPE html>
<html>
<head>
  <title>Counter App</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      text-align: center;
      margin-top: 100px;
    }

    h1 {
      color: #333;
    }

    #counterValue {
      font-size: 24px;
      margin-bottom: 20px;
    }

    #value {
      font-weight: bold;
    }

    .button {
      padding: 10px 20px;
      font-size: 16px;
      background-color: #007bff;
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }

    .button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>
  <h1>Counter App</h1>
  <p id="counterValue">Counter Value: <span id="value"></span></p>
  <button id="incrementButton" class="button">Increment</button>
  <button id="decrementButton" class="button">Decrement</button>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.24.0/axios.min.js"></script>
  <script>
    // Fetch the counter value from the server
    
    const host = "";  // enter you public ALB dns 
    
    
    async function fetchCounterValue() {
      try {
        const response = await axios.get("http://"+host+":/counter");
        return response.data.value;
      } catch (error) {
        console.error('Error retrieving counter value:', error);
        throw error;
      }
    }

    // Update the counter value on the page
    function updateCounterValue(value) {
      const valueElement = document.getElementById('value');
      valueElement.textContent = value;
    }

    // Increment the counter value via the server
    async function incrementCounter() {
      try {
        const response = await axios.post("http://"+host+"/increment");
        updateCounterValue(response.data.value);
      } catch (error) {
        console.error('Error incrementing counter:', error);
      }
    }

    // Decrement the counter value via the server
    async function decrementCounter() {
      try {
        const response = await axios.post("http://"+host+"/decrement");
        updateCounterValue(response.data.value);
      } catch (error) {
        console.error('Error decrementing counter:', error);
      }
    }

    // Initialize the counter app
    async function initializeCounterApp() {
      try {
        // Fetch the initial counter value
        const initialValue = await fetchCounterValue();

        // Update the counter value on the page
        updateCounterValue(initialValue);

        // Add event listeners to the increment and decrement buttons
        const incrementButton = document.getElementById('incrementButton');
        const decrementButton = document.getElementById('decrementButton');

        incrementButton.addEventListener('click', incrementCounter);
        decrementButton.addEventListener('click', decrementCounter);
      } catch (error) {
        console.error('Error initializing counter app:', error);
      }
    }

    // Run the counter app initialization
    initializeCounterApp();
  </script>
</body>
</html>
EOF 


