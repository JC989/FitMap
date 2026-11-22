import express from 'express';

const app = express(); // Create an instance of the Express application

// Serve static files from the 'public' directory
app.use('/public', express.static('public'));
app.use('/scripts', express.static('./public/scripts'));

// Define a route for the root URL
app.get('/', (req, res) => {
    res.status(200).send('<h1 style="text-align: center; margin-top: 50px;"> FitMap API is running! </h1>')
})

// Start the server and listen on port 3000
const PORT = process.env.PORT || 3000

//Listen for incoming requests
app.listen(PORT, () => {
    console.log(`Server listening on http://localhost:${PORT}`)
})