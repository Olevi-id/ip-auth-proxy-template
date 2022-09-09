const express = require('express');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const routes = require('./routes').router;
const app = express();

app.use(logger(process.env.RUNTIME_ENV === 'local' ? 'dev' : 'combined'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.use('/', routes);

module.exports = {
  app
};
