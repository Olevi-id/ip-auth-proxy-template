const router = require('express').Router();

router.get('/userAttributes', function (req, res) {
  if (process.env.RUNTIME_ENV === 'local') {
    console.log('Headers: ', req.headers);
  }
  const resp = [];
  const filteredHeaderKeys = Object.keys(req.headers)
    .sort()
    .filter((str) => str !== 'access_token');

  filteredHeaderKeys.forEach((headerKey) => {
    resp.push({ [headerKey]: req.header(headerKey) });
  });
  res.send(resp);
});

router.use('*', function (req, res, next) {
  res.status(400).send('Not Found');
});

module.exports = {
  router
};
