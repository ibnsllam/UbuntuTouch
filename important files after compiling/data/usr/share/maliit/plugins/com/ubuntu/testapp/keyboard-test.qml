

import QtQuick 2.0
import Ubuntu.Components 0.1

MainView {
    id: root

    automaticOrientation: true

    width: units.gu(18)
    height: units.gu(18)

    Rectangle {
        anchors.fill: parent
        color: "lightblue"
    }

    Column {

        y: units.gu(3)
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: units.gu(1)

        anchors.margins: units.gu(1)

        Text {
            id: label
            text: "OSK TestApp"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: units.gu(2)
            font.bold: true
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter;
            spacing: units.gu(1)

            Button {
                color: "red"
                text: "show()"
                width: units.gu(18)
                onClicked: Qt.inputMethod.show()

            }

            Button {
                color: "red"
                text: "hide()"
                width: units.gu(18)
                onClicked: Qt.inputMethod.hide()
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter;

            text: qsTr("note: show/hide requires focus on a text input")
            font.pixelSize: units.gu(1)
            color: "gray"
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter

            spacing: units.gu(1)

            Rectangle {
                width: units.gu(18);
                height: firstInputButton.height;

                anchors.leftMargin: units.gu(1)

                color: "white"

                TextInput {
                    id: input;
                    anchors.fill: parent
                    color: "black"; selectionColor: "red"

                    // Qt.ImhPreferNumbers
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhUrlCharactersOnly | Qt.ImhNoPredictiveText
                    font.pixelSize: units.gu(3)
                    font.bold: true
                }
            }

            Button {
                id: firstInputButton
                color: "yellow"
                text: "Focus/Unfocus"
                width: units.gu(18)
                onClicked: input.focus = !input.focus
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter;

            spacing: units.gu(1)

            Rectangle {
                width: units.gu(18);
                height: secondInputButton.height

                color: "white"

                TextInput {
                    id: secondInput;

                    anchors.fill: parent

                    font.pixelSize: units.gu(3)
                }
            }

            Button {
                id: secondInputButton
                color: "yellow"
                text: "Focus/Unfocus"
                width: units.gu(18)
                onClicked: secondInput.focus = !secondInput.focus
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter;

            Text {
                id: textRectangle

                font.pixelSize: units.gu(1)
                text: Qt.inputMethod.keyboardRectangle + " "
            }

            Rectangle {
                id: clickBehindOSKDetectedIndicator

                width: units.gu(18)
                height: units.gu(3)
                state: "default"

                Text {
                    id: clickBehindOSKDetectedIndicatorText
                    anchors.centerIn: parent
                    text: "clicked"
                    font.pixelSize: units.gu(2)
                    font.bold: true
                }

                states: [
                    State {
                        name: "default"
                        PropertyChanges {
                            target: clickBehindOSKDetectedIndicator
                            color: "gray"
                        }
                        PropertyChanges {
                            target: clickBehindOSKDetectedIndicatorText
                            color: "gray"
                        }
                    },
                    State {
                        name: "highlight"
                        PropertyChanges {
                            target: clickBehindOSKDetectedIndicator
                            color: "red"
                        }
                        PropertyChanges {
                            target: clickBehindOSKDetectedIndicatorText
                            color: "white"
                        }
                    }
                ]
            }

        }

        Text {
            id: textVisible

            anchors.horizontalCenter: parent.horizontalCenter;

            font.pixelSize: units.gu(2)
            text: "keyboard reports visible: " + Qt.inputMethod.visible
        }

    } // column

    Rectangle {
        id: fakeBrowserUrlBar
        width: keyboardRect.width
        height: units.gu(4)
        color: "orange"
        anchors.bottom: keyboardRect.top

        Text {
            visible: Qt.inputMethod.visible
            anchors.centerIn: parent
            font.pixelSize: units.gu(1)
            text: "browser url bar"
        }
    }

    Rectangle {
        id: keyboardRect

        width: Qt.inputMethod.keyboardRectangle.width
        height: Qt.inputMethod.keyboardRectangle.height

        anchors.bottom: parent.bottom
        color: " green"

        Text {
            visible: Qt.inputMethod.visible
            anchors.centerIn: parent
            font.pointSize: 24
            text: Qt.inputMethod.keyboardRectangle + " "
        }

        MouseArea {
            anchors.fill: parent
            onClicked: clickBehindOSKDetectedIndicator.visible = true
            onPressed: clickBehindOSKDetectedIndicator.state = "highlight"
            onReleased: clickBehindOSKDetectedIndicator.state = "default"
        }
    }
}
