import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import 'funcs2.js' as Library

Window {
    visible: true
    width: 800
    height: 600
    //    minimumWidth: 800
    //    minimumHeight: 600
    //    color: "black"


    ColumnLayout{
    anchors.fill: parent
        RowLayout{
            spacing: 10
            anchors.fill: parent
//            Layout.alignment:  Qt.AlignVCenter | Qt.AlignRight
            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout{
                //          width: 0
                //          Layout.minimumWidth: implicitWidth
                Layout.alignment:  Qt.AlignVCenter | Qt.AlignRight
                Layout.fillHeight: true

                Button{
                    text: "New full"
                    onClicked: {
                        myboard.newFull();
                        myboard.sendSetNumber(-1,[]);
                        mybutton.select(-1);
                    }
                }

                Button{
                    text: "Check"
                    onClicked: {
                        Library.func(myboard.result,myboard.groups,status);
//                        messageDialog.text="Папа хороший";
//                        messageDialog.open();

                    }

                }

                Button{
                    text: "Back"
                    onClicked: {
                        myboard.backHostory();
                        myboard.sendSetNumber(-1,[]);
                        mybutton.select(-1);
                    }
                }
            }

            Board {
                id: myboard
                Layout.alignment:  Qt.AlignVCenter | Qt.AlignCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                anchors.margins: 5
                //           anchors.fill: parent
            }
            SButtoms{
                id: mybutton
                //          width: 80
                //          Layout.minimumWidth: implicitWidth
                Layout.minimumWidth: 50
                Layout.alignment:  Qt.AlignVCenter | Qt.AlignRight
                Layout.fillHeight: true
                //          Layout.fillWidth: true
                //          anchors.fill: parent
            }
        }
        Text{
            id: status
            Layout.fillWidth: true
            Layout.alignment:  Qt.AlignBottom
            text:"status"
        }
    }
    function fromBoard(n,l){
        mybutton.select(n);
    }

    function toBoard(n){
        myboard.sendSetNumber(n,[]);
    }


    Component.onCompleted: {
        myboard.sendSetNumber.connect(fromBoard);
        mybutton.sendSelect.connect(toBoard);
        //        bttt.select.connect(mysetState);
    }


    MessageDialog {
        id: messageDialog
        title: "Qt"
        text: "Hello, world!"
    }
}
