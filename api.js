var log = function(msg) {
    console.log((new Date()) + " " + msg);
}

var server = require("http").createServer(function(request, response) {
    log(request.url + " requested");
    response.end("{ message: 'request received' }");
});

server.listen(1234, function() {
    log("Listening on port 1234");
});

log("HTTP server started");