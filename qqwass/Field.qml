import QtQuick 2.0
import QtQuick.Layouts 1.1
import 'funcs.js' as Library


Rectangle {
    id: myField

    signal numberSelect(int n, variant l)
    signal setResult(int n, string num)

    property variant vals: [true,true,true,true,true,true,true,true,true]
    property string fon:  "white"
    property int numInBoard
    property variant clearNumInBoard: []

    QtObject {
        id: _
        property variant nums:["1","2","3","4","5","6","7","8","9"]
        property bool wasChanged:false
        property bool oneSymbol:false
        property bool hasChanged:false
    }

    function checkOneSymbol(){
        var r=_.nums.filter(function(_item, _i){ return myField.vals[_i];}).join("");
        _.oneSymbol = r.length===1;
        r = _.oneSymbol? r:"";
        bigNumber.text = r;
        setResult(numInBoard, r);
    }

    function showBig(p){
        if (bigNumber.visible===p) return;
        bigNumber.visible=p;
        grid.visible=!p;
    }

    function numberExist(num, l){
        var newState="";
        if (num>=0) {
            if (l.indexOf(numInBoard)!==-1 && myField.vals[num]){
                myField.vals[num]=false;
                rep.itemAt(num).setState();
                checkOneSymbol();
                showBig(_.oneSymbol);
            }
            if (myField.vals[num])
                newState="Select";
        }

        if (newState !== myField.state)
            myField.state=newState;
    }

    function changeNumber(num){
        myField.vals[num]=!myField.vals[num];
        rep.itemAt(num).setState();
        checkOneSymbol();
        showBig(_.oneSymbol);
    }

    function allSet(){
        myField.vals.forEach(function(_item,_i,_array){
            _array[_i]=true;
            rep.itemAt(_i).setState();
        })
        checkOneSymbol();
        showBig(_.oneSymbol);
    }


    //    implicitWidth: buttonText.width + radius
    //    implicitHeight: buttonText.height + radius

    color: fon
    border.width : 1
    border.color : "black"
    states: [
        State {
            name: "Select"
            PropertyChanges {target: myField; color:"yellow" }
        }
    ]

    Timer {
        id: myTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: showBig(false)
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            //console.log("mouse entered the area");
            _.hasChanged=false;
            if (bigNumber.visible)
                myTimer.running=true;
        }
        onExited: {
            //console.log("mouse left the area")
            myTimer.running = false;
            if (_.hasChanged)
                checkOneSymbol();
            showBig(_.oneSymbol)
        }
    }

    Text {
        id: bigNumber
        anchors.centerIn: parent
        font.pixelSize: parent.height-4
        //            font.pointSize: 24
        visible: false
    }

    GridLayout {
        id: grid
        rows: 3
        columns: 3
        anchors.fill: parent
        columnSpacing:1
        rowSpacing:1

        visible: true

        Repeater {
            id: rep
            model:  _.nums
            Rectangle{
                //                color: "gainsboro"
                //                color: "#05111111"
                color: mouseArea.containsMouse ? "#15111111" : "#05111111"
                width: height
                Layout.fillHeight: true
                Layout.fillWidth: true

                Text {
                    id: textSomeId
                    text: modelData
                    anchors.centerIn: parent
                    font.pixelSize: parent.height-4
                    color: "black"

                    states: [
                        State {
                            name: "hide"
                            PropertyChanges { target: textSomeId; color:"#40000000" }
                        }
                    ]
                }

                function setState(){
                    var newState=myField.vals[index]?"":"hide";
                    if (newState !== textSomeId.state){
                        textSomeId.state=newState;
                        //                        console.log("      save: ",numInBoard,",",index);
                        // save new changed state for numInBoard and index
                        Library.addIntoStep(numInBoard,index);
                    }
                }

                Component.onCompleted: {
                    setState();
                }

                MouseArea {
                    //                        hoverEnabled: true
                    id: mouseArea
                    anchors.fill: parent
                    propagateComposedEvents: false
                    onClicked: {
                        //console.log("mouse onClicked");
                        //                            mouse.accepted = true;
                        _.hasChanged=true;
                        // start save step for numInBoard
                        //                            console.log("+start save");
                        Library.startStep();
                        myField.vals[index]=!myField.vals[index]
                        setState();
                        myField.numberSelect(index, []);
                        //                            console.log("-stop save");
                        Library.stopStep();
                        // stop save step for numInBoard
                    }
                    onDoubleClicked: {
                        //console.log("mouse onDBLClicked");
                        mouse.accepted = false;
                        _.hasChanged=true;
                        //                            console.log("+start save");
                        Library.startStep();
                        // start save step
                        myField.vals.forEach(function(_item,_i,_array){
                            _array[_i]=(_i===index);
                            rep.itemAt(_i).setState();
                        })
                        myField.numberSelect(index, myField.clearNumInBoard);
                        Library.stopStep();
                        //                            console.log("-stop save");
                        // stop save step
                    }
                }
            }
        }
    }
}

