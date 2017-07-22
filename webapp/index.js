// ------------------------------------------------------
// Import all required packages and files
// ------------------------------------------------------

let Pusher     = require('pusher');
let express    = require('express');
let app        = express();
let bodyParser = require('body-parser')
let pusher     = new Pusher(require('./config.js')['config']);

// ------------------------------------------------------
// Set up Express
// ------------------------------------------------------

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

// ------------------------------------------------------
// Define routes and logic
// ------------------------------------------------------

app.post('/like', (req, res, next) => {
  let payload = {uuid: req.body.uuid}
  pusher.trigger('likes', 'like', payload)
  res.json({success: 200})
})

app.get('/', (req, res) => {
  res.json("It works!");
});


// ------------------------------------------------------
// Catch errors
// ------------------------------------------------------

app.use((req, res, next) => {
    let err = new Error('Not Found');
    err.status = 404;
    next(err);
});


// ------------------------------------------------------
// Start application
// ------------------------------------------------------

app.listen(4000, function() {
    console.log('App listening on port 4000!')
});