import QtQuick 2.0
import QtQuick.Layouts 1.1

Rectangle {
//    Layout.fillHeight: true
//    Layout.fillWidth: true
    id: bttt

    signal select(int n)
    signal clearSelectEx(int n)
    signal sendSelect(int n)

//    width: height
//    Layout.minimumWidth: implicitWidth
    ColumnLayout{
        spacing: 2
        anchors.fill: parent
//        anchors.margins: 11
        Repeater {
            model: ["1","2","3","4","5","6","7","8","9"]
            Rectangle{
                id: button
//                width: 100
                border.width : 1
                border.color : "black"
                radius: 10
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "white"
                states:[
                    State{
                        name: "Selected"
                        PropertyChanges { target: button; color:"yellow" }
                        }
                ]
                Text{
                    id: textId
                    text: modelData
                    font.pointSize: 20
                    anchors.centerIn: parent
                    color: "black"
                }
                MouseArea {
//                        hoverEnabled: true
                        id: mouseArea
                        anchors.fill: parent
                        propagateComposedEvents: false
                        onClicked: {
//                                bttt.select(textId.text);
                            clearSelectEx(index);
                            button.state=button.state===""?"Selected":"";
                            if (button.state==="") sendSelect(-1); /*clear select*/
                            else sendSelect(index);
                        }
//                        onEntered: {

//                          console.log("mouse entered the area");
//                            _.hasChanged=false;
//                            if (bigNumber.visible)
//                                myTimer.running=true;
//                        }
//                        onExited: {
//                          console.log("mouse left the area")
//                            myTimer.running = false;
//                            if (_.hasChanged)
//                                checkOneSymbol();
//                            showBig(_.oneSymbol)
//                        }
                }


                function myclearState(n) {
                    if (n!==index && button.state!=="")
                        button.state="";
                }

                function mysetState(n) {
//                    console.log("mysetSelect: "+n);
                    var nstate="";
                    if (n===index)
                        nstate="Selected";
                    if (nstate !== button.state)
                        button.state=nstate;
                }

                Component.onCompleted: {
                    bttt.clearSelectEx.connect(myclearState);
                    bttt.select.connect(mysetState);
                }


            }
        }
    }
}

