/*
    Copyright (C) 2020 Sebastian J. Wolf and other contributors

    This file is part of Fernschreiber.

    Fernschreiber is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Fernschreiber is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Fernschreiber. If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
import Sailfish.Silica 1.0

Item {
    id: notificationItem
    z: 42
    y: -100
    Behavior on y { PropertyAnimation { easing.type: Easing.OutCubic } }
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width - 2 * Theme.horizontalPageMargin

    function show(message, additionalInformation) {
        notificationTextItem.text = message;
        if (additionalInformation) {
            notificationTextItem.additionalInformation = additionalInformation;
        }
        notificationTimer.start();
        notificationTextItem.visible = true;
        notificationTextItem.opacity = 1;
        notificationItem.y = notificationItem.parent.height / 2;
    }

    Connections {
        target: notificationTimer
        onTriggered: {
            notificationItem.y = notificationItem.parent.height + 100;
            notificationTextItem.opacity = 0;
            notificationResetter.start();
        }
    }

    Connections {
        target: notificationResetter
        onTriggered: {
            notificationTextItem.visible = false;
            notificationItem.y = -100
        }
    }

    Timer {
        id: notificationTimer
        repeat: false
        interval: 3500
    }

    Timer {
        id: notificationResetter
        repeat: false
        interval: 1000
    }

    AppNotificationItem {
        id: notificationTextItem
    }

}
