var path = require('path');
var express = require('express');
var app = express();

var socketio = require('socket.io');
var mustacheExpress = require('mustache-express');

var j1 = "bernardo";
var j2;

var ia;

var myBoats = [];
resetTable(myBoats);

var enemyBoats = [];
resetTable(enemyBoats);

//App

app.route('/').get(function(req,res,next){
  res.render('home');
});

app.route('/play/:username/:ia').get(function (req, res, next){
  res.render('play', {playerName: req.params.username, iaName: req.params.ia});
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
var socket;
io.on('connection', function (sock) {
  socket = sock;
  socket.emit('news', { hello: 'world' });
  socket.on('my other event', function (data) {
    console.log(data);
  });
  socket.on('start-game', function (data) {
    console.log("addPlayer("+ data.player +").\n");
    terminal.stdin.write("addPlayer("+ data.player +").\n");
    Object.keys(data.boats).forEach(function(boat) {
      var direction = data.boats[boat].direction=="vertical" ? 1 : 0;
      console.log('placeShipManual('+data.player+', '+ boat +', '+ data.boats[boat].size +', '+ data.boats[boat].X +', '+ data.boats[boat].Y +', '+direction+').\n');
      terminal.stdin.write('placeShipManual('+data.player+', '+ boat +', '+ data.boats[boat].size +', '+  data.boats[boat].X +', '+ data.boats[boat].Y +', '+direction+').\n');
    });
    resetTable(myBoats);
    ia = data.ia;
    var funcIA;
    if(ia == "easyIA") {
      funcIA = "addEasyIA";
    } else {
      funcIA = "addStrongIA";
    }

    console.log(funcIA+".\n");
    terminal.stdin.write(funcIA + ".\n");
    setTimeout(function() {
      console.log("displayPlayer(" + ia + ").\n");
      terminal.stdin.write("displayPlayer("+ia+").\n");
    }, 1000);
  });

  socket.on('user-shot', function (data) {
    console.log("shot("+data.X+","+data.Y+").\n");
    terminal.stdin.write("shot("+data.X+","+data.Y+").\n");
  });
});

//Terminal

var args = ['-s', '../Game/Game.pl'];

//var terminal = require('child_process').spawn('/Applications/SWI-Prolog.app/Contents/MacOS/swipl', args);

var terminal = require('child_process').spawn('C:\\Program Files\\swipl\\bin\\swipl.exe', args);
terminal.stdout.on('data', function (data) {
  data.toString().split('\n').forEach(function (line){
    if(line.length == 0)
      return;
    var msgType = line.substr(0, line.indexOf(':'));
    var msg = line.substr(line.indexOf(':')+1);
    switch(msgType) {
      case 'PLACE':
        placeBoat(msg);
        break;
      case 'END':
        printTable(myBoats);
        break;
      case 'SHOT':
        treatShot(msg);
        break;
      case 'WON':
        victoryCondition(msg);
      default:
        console.log(line);
    }
  });
});

terminal.stderr.on('data', function (data) {
    console.log('stderr: ' + data);
});

terminal.on('exit', function (code) {
    console.log('child process exited with code ' + code);
});
/*
setTimeout(function() {
    //console.log('Sending stdin to terminal');
    //terminal.stdin.write("displayPlayer(" + j1 + ").\n");
    //console.log('Ending terminal session');
    //terminal.stdin.end();
}, 2000);
*/
function placeBoat(line) {
  if(line[0] == '[') {
    var lineA;
    try {
      lineA = JSON.parse(line);
    } catch (e) {
      return false;
    }
    myBoats[lineA[0]-1][lineA[1]-1] = {
      id: lineA[3].substr(1, lineA[3].length-2),
      touched: lineA[2]
    }
  }
}

function treatShot(msg) {
  var array = msg.split('.');
  var player = array[0];
  var result = array[1];
  var coords;
  if(result == "S") {
    coords = [];
    for(var i = 2; i<array.length-1; i++) {
      coords.push(JSON.parse(array[i]));
    }
  } else {
    coords = JSON.parse(array[2]);
  }
  console.log(msg);
  if(player == "strongIA1" ||
     player == "strongIA2" ||
     player == "easyIA1"   ||
     player == "easyIA2"   ) {
    socket.emit('shot-taken', {
      result: result,
      coords: coords
    });
  } else {
    socket.emit('shot-result', {
      result: result,
      coords: coords
    });
  }
}

function resetTable(table) {
  for(var i = 0; i<10;i++) {
    table[i] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  }
};

function victoryCondition(msg) {
  if(msg == "strongIA1" ||
     msg == "strongIA2" ||
     msg == "easyIA1"   ||
     msg == "easyIA2"   ) {
    socket.emit('lost');
  } else {
    socket.emit('won');
  }
}

function printTable(table) {
  var p = '';
  p += " ---------------------------------------\n";
  table.forEach(function (row) {
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