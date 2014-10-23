var path = require('path');
var express = require('express');
var app = express();

var socketio = require('socket.io');
var mustacheExpress = require('mustache-express');

var j1 = "bernardo";
var j2;

var cases = [];

function clearTable() {
  for(var i = 0; i<10;i++) {
    cases[i] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  }
};
clearTable();

//App

app.route('/play/:username').get(function (req, res, next){
  res.render('play', {playerName: req.params.username});
});

app.engine('mustache', mustacheExpress());

app.set('view engine', 'mustache');
app.set('views', __dirname + '/views');
app.use(express.static('public'));

//Socket

var server = app.listen(3000, function () {

  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);

});

var io = socketio(server);

io.on('connection', function (socket) {
  socket.emit('news', { hello: 'world' });
  socket.on('my other event', function (data) {
    console.log(data);
  });
  socket.on('start-game', function (data) {
    console.log(data.player);
    console.log(data.boats);
    Object.keys(data.boats).forEach(function(boat) {
      var direction = data.boats[boat].direction=="vertical" ? 1 : 0;
      console.log('placeShipManual('+data.player+', '+ boat +', '+ data.boats[boat].size +', '+ data.boats[boat].X +', '+ data.boats[boat].Y +', '+direction+').\n');
      terminal.stdin.write('placeShipManual('+data.player+', '+ boat +', '+ data.boats[boat].size +', '+  data.boats[boat].X +', '+ data.boats[boat].Y +', '+direction+').\n');
    });
    clearTable();
    setTimeout(function() {
      console.log("displayPlayer(" + data.player + ").\n");
      terminal.stdin.write("displayPlayer(" + data.player + ").\n");
      terminal.stdin.write("displayPlayer(" + data.player + ").\n");
    }, 5000);
  });
});

//Terminal

var args = ['-s', '../pose/poseBateaux.pl', '-g', 'placeShipsAuto('+j1+').'];

var terminal = require('child_process').spawn('/Applications/SWI-Prolog.app/Contents/MacOS/swipl', args);

terminal.stdout.on('data', function (data) {
  data.toString().split('\n').forEach(function (line){
    if(line.length == 0)
      return;
    switch(line) {
      case 'end':
        printTable();
        break;
      default:
        console.log(line);
        lineDefault(line);
    }
  });
});

terminal.stderr.on('data', function (data) {
    console.log('stderr: ' + data);
});

terminal.on('exit', function (code) {
    console.log('child process exited with code ' + code);
});

setTimeout(function() {
    console.log('Sending stdin to terminal');
    terminal.stdin.write("displayPlayer(" + j1 + ").\n");
    //console.log('Ending terminal session');
    //terminal.stdin.end();
}, 2000);

function lineDefault(line) {
  if(line[0] == '[') {
    var lineA;
    try {
      lineA = JSON.parse(line);
    } catch (e) {
      return false;
    }
    cases[lineA[0]-1][lineA[1]-1] = {
      id: lineA[3].substr(1, lineA[3].length-2),
      touched: lineA[2]
    }
  }
}

function printTable() {
  var p = '';
  p += " ---------------------------------------\n";
  cases.forEach(function (row) {
    row.forEach(function (cell) {
      if(cell.id) {
        p += '| '+ cell.id[0] +' ';
      } else {
        p += '|   ';
      }
    });
    p += '|\n';
  });
  p += " ---------------------------------------";
  console.log(p);
}