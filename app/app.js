// app.js
'use strict';
const express = require('express');

const app = express();

app.use(express.urlencoded({ extended: true }))
app.use(express.json())


const PORT = 3000;
const HOST = '0.0.0.0';

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.get('/health', (req, res) => {
  res.send('App is running fine!')
})

app.listen(PORT, HOST, () => {
  console.log(`Example app listening on port ${PORT}`)
});

module.exports = app;