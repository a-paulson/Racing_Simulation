var input = {
  race1: [["horse1", .5],
          ["horse2", .5]],
  race2: [["horse1", .5],
          ["horse2", .4],
          ["horse3", .6],
          ["horse4", .7]],
  race3: [["horse1", 1],
          ["horse2", 4]],
  race4: [["horse1", .22],
          ["horse2", .25],
          ["horse3", .20],
          ["horse4", .21],
          ["horse5", .19]]
        };

var EQUALITY_DISTANCE = .011;


function sortRaces(inputRaces){
  var races = {};

  Object.keys(inputRaces).forEach(function(key){
    races[key] = inputRaces[key].sort(function(a, b){
      return b[1] - a[1];
    });
  });

  Object.keys(races).forEach(function(key){
    var currentRace = races[key];
    var raceBlock = [
                      [
                        currentRace[0]
                      ]
                    ];

    // console.log(currentRace[0]);
    // console.log(raceBlock);
    for (var i = 1; i < currentRace.length; i++) {
      var lastBlock = raceBlock[raceBlock.length - 1];
      var lastRace = lastBlock[lastBlock.length - 1];

      if (lastRace[1] - currentRace[i][1] <= EQUALITY_DISTANCE){
        lastBlock.push(currentRace[i]);
      } else {
        raceBlock.push([currentRace[i]]);
      }
    }
    // console.log(raceBlock);
    races[key] = raceBlock;
  });

  return races;
}

 function generateTickets(inputRaces, number_of_tickets) {
   var races = sortRaces(inputRaces);

   var probsList = [];
   var raceNames = Object.keys(races);

   races[raceNames[0]].forEach(function(block, idx){
     probsList.push([idx]);
   });

   for (var i = 1; i < raceNames.length; i++) {
     var newProbsList = [];
     races[raceNames[i]].forEach(function(block, idx){
       for (var j = 0; j < probsList.length; j++) {
         newProbsList.push(probsList[j].concat(idx));
       }
     });
     probsList = newProbsList;
   }

   var finalProbList = [];

   newProbsList.forEach(function(idxs){
     var probability = idxs.reduce(function(prob, blockIdx, raceIdx){
       return prob * races[raceNames[raceIdx]][blockIdx][0];
     }, 1);
     finalProbList.push([probability, idxs]);
   });

   finalProbList.sort(function(a,b){
     return b[0] - a[0];
   });

    return finalProbList;
 }

// var output = sortRaces(input);
// Object.keys(output).forEach(function(key){
//   console.log(output[key]);
//   console.log("\n");
// });

console.log(generateTickets(input, 100));
