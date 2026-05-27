const express = require('express');
const axios = require('axios');
const path = require('path');

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.use(express.static('public'));

app.set('view engine', 'ejs');

app.get('/', (req, res) => {
    res.render('index', { response: null });
});

app.post('/submit', async (req, res) => {
    try {
        const response = await axios.post('http://127.0.0.1:5000/submit', {
            name: req.body.name,
            email: req.body.email,
            message: req.body.message
        });

        res.render('index', { response: response.data });

    } catch (error) {
        res.render('index', {
            response: { message: 'Backend connection failed' }
        });
    }
});

app.listen(3000, '0.0.0.0', () => {
    console.log('Frontend running on port 3000');
});
