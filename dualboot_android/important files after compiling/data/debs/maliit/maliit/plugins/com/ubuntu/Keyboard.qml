/*
 * This file is part of Maliit plugins
 *
 * Copyright (C) 2012 Openismus GmbH
 *
 * Contact: maliit-discuss@lists.maliit.org
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 * Neither the name of Nokia Corporation nor the names of its contributors may be
 * used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

import QtQuick 2.0
import "constants.js" as Const

import "keys/key_constants.js" as UI
import Ubuntu.Components 0.1
import QtQuick.Window 2.0

Item {
    objectName: "fullScreenItem"

    property variant layout: maliit_layout
    property variant event_handler: maliit_event_handler

OrientationHelper {

    automaticOrientation: false
    transitionEnabled: false

    orientationAngle: Screen.angleBetween(Screen.primaryOrientation, canvas.contentOrientation);

Item {
    id: canvas
    objectName: "ubuntuKeyboard" // Allow us to specify a specific keyboard within autopilot.

    anchors.bottom: parent.bottom
    anchors.left: parent.left

    width: parent.width

    property int keypadHeight: 0 // set by InputMethod

    property string layoutId: "en_us"
    onLayoutIdChanged: keypad.loadLayout(layoutId);

    visible: layout.visible

    // Expose details for use with Autopilot.
    //readonly property var layoutState: layout.keyboard_state
    //readonly property string activeView: layout.activeView

    property int contentOrientation: Qt.PrimaryOrientation // overwritten by inputMethod

    property bool shown: false;
    property bool wordribbon_visible: false;
    property bool hideAnimationFinished: false;
    property int pressedKeyIndex: -1;
    property Item pressedKey;


        MouseArea {
            id: keyboardSurface
            property int jumpBackThreshold: 170

            drag.target: keyboardSurface
            drag.axis: Drag.YAxis;
            drag.minimumY: 0
            drag.maximumY: height
            drag.filterChildren: true

            x:0
            y:0
            width: parent.width
            height: parent.height


            WordRibbon {
                id: wordRibbon
                objectName: "wordRibbon"

                visible: canvas.wordribbon_visible

                anchors.bottom: keyboardComp.top
                width: parent.width;

                height: visible ? layout.wordribbon_height : 0
            }

            Item {
                id: keyboardComp

                height: canvas.keypadHeight - wordRibbon.height
                width: parent.width
                anchors.bottom: parent.bottom

                Rectangle {
                    id: background

                    anchors.fill: parent

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#f1f1f1" }
                        GradientStop { position: 1.0; color: "#e4e4e4" }
                    }
                }

                MouseArea {
                    id: noSwipeDown
                    anchors.fill: parent
                    preventStealing: true
                    anchors.top: borderTop.bottom
                    anchors.topMargin: units.gu( UI.top_margin )
                }

                Image {
                    id: borderTop
                    source: "styles/ubuntu/images/border_top.png"
                    width: parent.width
                    anchors.top: parent.top.bottom
                }

                Image {
                    id: borderBottom
                    source: "styles/ubuntu/images/border_bottom.png"
                    width: parent.width
                    anchors.bottom: background.bottom
                }

                KeyboardContainer {
                    id: keypad

                    anchors.top: borderTop.bottom
                    anchors.bottom: borderBottom.top
                    anchors.topMargin: units.gu( UI.top_margin )
                    anchors.bottomMargin: units.gu( UI.bottom_margin )
                    width: parent.width
                }
            } // keyboardComp

            onReleased: {
                if (y > jumpBackThreshold) {
                    canvas.shown = false;
                } else {
                    bounceBackAnimation.from = y
                    bounceBackAnimation.start();
                }
            }

            PropertyAnimation {
                id: bounceBackAnimation
                target: keyboardSurface
                properties: "y"
                easing.type: Easing.OutBounce;
                easing.overshoot: 2.0
                to: 0
            }

        } // big mousearea

    state: "HIDDEN"

    states: [
        State {
            name: "SHOWN"
            PropertyChanges { target: canvas; y: 0; }
            when: canvas.shown === true
            onCompleted: canvas.hideAnimationFinished = false;
        },

        State {
            name: "HIDDEN"
            PropertyChanges { target: canvas; y: height; }
            onCompleted: {
                keyboardSurface.y = 0;
                canvas.hideAnimationFinished = true;
            }
            when: canvas.shown === false
        }
    ]
    transitions: Transition {
        PropertyAnimation { target: canvas; properties: "y"; easing.type: Easing.InOutQuad }
    }

} // canvas
} // OrientationHelper
} // fullScreenItem
