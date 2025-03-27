const express = require('express');
const cors = require('cors');
const multer = require('multer');
const path = require('path');

const app = express();
const port = 3000;

// Enable CORS for all domains
app.use(cors());

// Configure multer to store uploaded files
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });

// Route for file upload
app.post('/upload', upload.single('file'), (req, res) => {
  if (!req.file) {
    return res.status(400).send('No file uploaded.');
  }
  res.status(200).send({
    message: 'File uploaded successfully!',
    filePath: `http://localhost:${port}/uploads/${req.file.filename}`
  });
});

// Serve static files from 'uploads' folder
app.use('/uploads', express.static('uploads'));

// Start the server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});