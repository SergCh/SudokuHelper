import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import 'funcs.js' as Library

Rectangle {
        id: myBoard
        color: "black"

        signal sendSetNumber(int num, variant l)

        property variant mask:[0,0,0,1,1,1,0,0,0,
                               0,0,0,1,1,1,0,0,0,
                               0,0,0,1,1,1,0,0,0,
                               1,1,1,0,0,0,1,1,1,
                               1,1,1,0,0,0,1,1,1,
                               1,1,1,0,0,0,1,1,1,
                               0,0,0,1,1,1,0,0,0,
                               0,0,0,1,1,1,0,0,0,
                               0,0,0,1,1,1,0,0,0]

        property variant result: [  "","","","","","","","","",
                                    "","","","","","","","","",
                                    "","","","","","","","","",
                                    "","","","","","","","","",
                                    "","","","","","","","","",
                                    "","","","","","","","","",
                                    "","","","","","","","","",
                                    "","","","","","","","","",
                                    "","","","","","","","",""]

        property variant groups:[   [ 0, 1, 2, 3, 4, 5, 6, 7, 8],
                                    [ 9,10,11,12,13,14,15,16,17],
                                    [18,19,20,21,22,23,24,25,26],
                                    [27,28,29,30,31,32,33,34,35],
                                    [36,37,38,39,40,41,42,43,44],
                                    [45,46,47,48,49,50,51,52,53],
                                    [54,55,56,57,58,59,60,61,62],
                                    [63,64,65,66,67,68,69,70,71],
                                    [72,73,74,75,76,77,78,79,80],
                                    [ 0, 9,18,27,36,45,54,63,72],
                                    [ 1,10,19,28,37,46,55,64,73],
                                    [ 2,11,20,29,38,47,56,65,74],
                                    [ 3,12,21,30,39,48,57,66,75],
                                    [ 4,13,22,31,40,49,58,67,76],
                                    [ 5,14,23,32,41,50,59,68,77],
                                    [ 6,15,24,33,42,51,60,69,78],
                                    [ 7,16,25,34,43,52,61,70,79],
                                    [ 8,17,26,35,44,53,62,71,80],
                                    [ 0, 1, 2, 9,10,11,18,19,20],
                                    [ 3, 4, 5,12,13,14,21,22,23],
                                    [ 6, 7, 8,15,16,17,24,25,26],
                                    [27,28,29,36,37,38,45,46,47],
                                    [30,31,32,39,40,41,48,49,50],
                                    [33,34,35,42,43,44,51,52,53],
                                    [54,55,56,63,64,65,72,73,74],
                                    [57,58,59,66,67,68,75,76,77],
                                    [60,61,62,69,70,71,78,79,80]]


        GridLayout {
              anchors.margins: 2
              columnSpacing:0
              rowSpacing:0
              rows: 9
              columns: 9
              anchors.fill: parent

    //          anchors.margins: 1

              Repeater {
                  id: rep
                  model: 81
                     Field {

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        fon: myBoard.mask[index]===1?"white":"lavender"
                        numInBoard: index
                        clearNumInBoard: myBoard.groups.reduce(function(_curr,_item){
                            return ~_item.indexOf(index)?_curr.concat(_item):_curr;},[])
                            .filter(function(__item,__index,__arr){
                            return __arr.indexOf(__item)===__index && __item!==index;
                            })

                        Component.onCompleted: {
                           myBoard.sendSetNumber.connect(numberExist);
                           numberSelect.connect(myBoard.setNumber);
                           setResult.connect(myBoard.checkResult);
                        }
                     }
              }
          }


//        function newBoard(){

//        }



        function checkResult(n, num) {
            myBoard.result[n]=num;
            if(~myBoard.result.indexOf("")) return;
            var r=myBoard.groups.every(function(_rule){
                var r=_rule.map(function(__val){
                    return myBoard.result[__val];
                    }).sort().join("");
                return r==="123456789";
            });
            messageDialog.text=r?"++++GOOD++++":"--------BAD--------";
            messageDialog.open()
        }

        function setNumber(num, l) {
            sendSetNumber(num, l);
        }

        function backHostory(){
            var s=Library.backStep();
//            console.log("Внимание!",s);
            if (s.length===0) return;
            s.forEach (function (v){
                rep.itemAt(v.field).changeNumber(v.number);
            });
        }

        function newFull(){
            var c=rep.count;
            var i;
            for (i=0;i<c;++i){
                rep.itemAt(i).allSet();
            }

//            rep.forEach(function (_item){
//                _item.setAll();
//            });
//            rep.forEach(function(_item,_i,_array){
//                _array[_i]=true;
//                rep.itemAt(_i).setState();
//            s.forEach (function (v){
//                rep.itemAt
//            })
            Library.initHistory();
        }


        Component.onCompleted: {
            Library.initHistory();
        }

        MessageDialog {
               id: messageDialog
               icon : StandardIcon.Information
               title: "--==Qt==--"
        }
}

