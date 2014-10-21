var j1 = "bernardo";
var j2;

var terms = [];
for(var i = 0; i<10;i++) {
  terms[i] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
}

var args = ['-s', '../pose/poseBateaux.pl', '-g', 'placeShipsAuto('+j1+').'];

var terminal = require('child_process').spawn('/Applications/SWI-Prolog.app/Contents/MacOS/swipl', args);

terminal.stdout.on('data', function (data) {
  console.log(data.toString());
    data.toString().split('\n').forEach(function (line){
      if(line.length > 0) {
        var lineArray = JSON.parse(line);
        terms[lineArray[0]-1][lineArray[1]-1] = {
          id: lineArray[3].substr(1, lineArray[3].length-2),
          touched: lineArray[2]
        }
        console.log(terms[lineArray[0]][lineArray[1]]);
      }
    });
    printTable();
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
    terminal.stdin.write("displayGrid(" + j1 + ").\n");
    //console.log('Ending terminal session');
    //terminal.stdin.end();
}, 1000);

function printTable() {
  var p = '';
  p += " ---------------------------------------\n";
  terms.forEach(function (row) {
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