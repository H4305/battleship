var express = require('express');
var app = express();

var socketio = require('socket.io');
var mustacheExpress = require('mustache-express');

var j1 = "bernardo";
var j2;

var cases = [];
for(var i = 0; i<10;i++) {
  cases[i] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
}

//App

app.get('/', function(req, res){
  res.render('play', {nomJoueur: "Modou"});
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
  socket.on('gogogo', function () {
    console.log("STAAAAAARRRRRTTTTTTT!!!!!!");
  })
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
        lineDefault(line);
    }
  });
});
/*
terminal.stderr.on('data', function (data) {
    console.log('stderr: ' + data);
});
*/
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