
//Qt.include("SetIE.js")

var globalzones=[];
var countresults=0;
var vars=["1","2","3","4","5","6","7","8","9"];
var board;
var idText;
var spisok=[];

function setState(message){
    idText.text=message;
}


function func(startBoard,zones,id) {
    var i;

    idText=id;  //for setState

//    var ss= new Set([1,2,3]);

    setState("Prestart...");

    countresults=0;
    spisok=[];

    for (i=0;i<81;++i){
        globalzones[i]=zones.reduce(function(_curr,_item){
            return ~_item.indexOf(i)?_curr.concat(_item):_curr;},[])
        .filter(function(__item,__index,__arr){
            return __arr.indexOf(__item)===__index && __item!==i;
        });
    }

    board=startBoard.map(function(_e,_i,_arr){
        var t1=globalzones[_i].map(function(__e){return _arr[__e];});
        var t2=vars.filter(function(__e){return t1.indexOf(__e)<0;});
//        var s=new Set();
//        if (t2.length===1){_e=t2[0];}
//        console.log("t2: =",t2);
        if (_e!=="") {
            if (t1.indexOf(_e)>=0) countresults=-1;
            return {v:_e, vs:[] /*, toString : function() {return "v="+this.v;}*/};
        }else{
            spisok.push(_i);
//            s.add(t2);
            return {v:"", vs:t2 /*, toString : function() {return "v="+this.v+" vs=["+this.vs.toString()+"]";}*/};
        }
//        return {v:_e ,vs:s};
    });

//        globalzones=board.map(function(_e,_i,_board){
//            if (_e.v!=="") return [];
//            else return zones.reduce(function(_curr,_item){
//                return ~_item.indexOf(i)?_curr.concat(_item):_curr;},[])
//            .filter(function(__item,__index){return _board[_index].v==="";})
//            .filter(function(__item,__index,__arr){
//                return __arr.indexOf(__item)===__index && __item!==_i;
//            });
//        });

//    console.log("spisok: =",spisok);
//    console.log("board: =",board);

    if (countresults<0){
        setState("BAD");
        return;
    }

    if (spisok.length===0) {
        setState("");
        return;
    }

    countresults=0;

    setState("Start calculate");

    nextStep(0);

    if (countresults===0) setState("NO RESULTS");
    if (countresults===1) setState("Only one result");
    if (countresults>1)   setState("More then one result");
}

function nextStep(n){

    if (n>=spisok.length){
        ++countresults;
        if (countresults===1) setState("Found one result, find next");
        return countresults>1;
    }

    var index=spisok[n];
//    console.log("board[index=",index,"]:",board[index]," vs=",board[index].vs);
//    console.log("before :",board);

    return board[index].vs.some(function(_elem){

        if (_elem==="") return false;

        var emptyvs=false;

        var temp=globalzones[index].reduce(function(__ret,__item){
            var k;
            if (emptyvs) return __ret;
            if (spisok.slice(0,n).indexOf(__item)<0)
                if ((k=board[__item].vs.indexOf(_elem))>=0){
                    board[__item].vs[k]="";
                    emptyvs=board[__item].vs.join("")==="";
                    return __ret.concat({e:__item, i:k/*, toString : function() {return this.e;}*/});
                }
            return __ret;
        },[]);

        if (!emptyvs) if (nextStep(n+1)) return true;

        temp.forEach(function (__e){board[__e.e].vs[__e.i]=_elem;});

        return false;
    });

}
