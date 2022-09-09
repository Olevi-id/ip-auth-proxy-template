const appFile = require('./app');
const http = require('http');

const server = http.createServer(appFile.app);
server.listen(8000, () => {
  console.log('NodeJs Server listening on port 8000');
});
module.exports = {
  server
};
