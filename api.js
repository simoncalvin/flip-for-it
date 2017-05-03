var log = function (msg) {
    console.log((new Date()) + " " + msg);
}

var httpServer = require("http").createServer(function (request, response) { });

httpServer.listen(1234,
    function () {
        log("Listening on port 1234");
    });

var wsServer = new (require("websocket").server)({ httpServer: httpServer });

wsServer.on("request",
    function (r) {

        log("Request received");

        var connection = r.accept("", r.origin);
    });

wsServer.on("connect",
    function (connection) {

        log("Connection established");

        connection.on("message",
            function (message) {

                log("Message received: " + message.utf8Data);

                connection.sendUTF(message.utf8Data);
            });
    });

log("HTTP server started");