.pragma library



//history

//HISTORY= n
var history = [];
var currStep = [];
var currIndex = 0;
var stepStarted=false;

function initHistory(){
    history=[];
    currIndex=0;
    stepStarted=false;
}

function startStep(){
    currStep=[];
    stepStarted=true;
//    console.log("START STEP");
}

function stopStep(){
    if (!stepStarted) return;
    if (currIndex<history.length) history.length=currIndex;
    history.push(currStep);
    ++currIndex;
//    console.log("START STOP, was add:",currStep[0].field,",",currStep[0].number);
}

function addIntoStep(a , b){
    if (!stepStarted) return;
    currStep.push({field:a, number:b});
}

function backStep(){
    console.log("backStep:",history.length,",",currIndex);
    if (currIndex===0) return[];
//    console.log("backStep   :",history[currIndex-1].length);
    --currIndex;
    return history[currIndex];
}

function frontStep(){
    var l=history.length;
    if (currIndex<l){
          return history[++currIndex];
    } else return [];
}

