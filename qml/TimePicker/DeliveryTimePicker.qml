import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

import Hepler.DateTimeUtils 1.0

Popup {
  id: root
  height: 400

  modal: true
  dim: true
  padding: 0

  property int minValue: 0
  property int maxValue: 24 * 60
  property int stepValue: 30

  property int firstValue
  property int secondValue

  property bool range: true
  property bool showHeader: true
  property bool showFooter: true
  property string title: range ? qsTr("Select delivery time range") : qsTr("Select delivery time")
  property date initialTime: DateTimeUtils.now()

  property var minutesList: []


  function formatText(modelData) {
    return dateTimeFunc.getTime(modelData);
  }

  signal timeSelected(var firstTime, var secondTime);

  onOpened: {
    minutesList = [];
    minValue = dateTimeFunc.soon(minValue, -1);

    for (var j = minValue; j <= maxValue; j += stepValue) {
      minutesList.push(j);
    }

    firstTimeTumbler.model = minutesList.slice().splice(0, minutesList.length - 1);
    secondTimeTumbler.model = minutesList.slice().splice(firstTimeTumbler.currentIndex + 1, minutesList.length);

    if (firstValue >= 0) {
      firstTimeTumbler.currentIndex = firstTimeTumbler.model.indexOf(firstValue)
      if (secondValue >= 0) {
        secondTimeTumbler.currentIndex = secondTimeTumbler.model.indexOf(secondValue)
      }
    }
  }

  background: Item {
    Rectangle {
      id: backgroundView
      anchors.fill: parent
      radius: 6
      color: "#FFFFFF"
    }

    DropShadow {
      anchors.fill: backgroundView
      cached: false
      horizontalOffset: 0
      verticalOffset: 0
      radius: Math.floor(6 * 1.5)
      color: Qt.rgba(0, 0, 0, 0.5)
      source: backgroundView
    }
  }

  contentItem: Item {
    id: popupContent
    implicitWidth: 400
    implicitHeight: 440

    Item {
      id: content
      anchors.fill: popupContent; anchors.margins: 12

      Item {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: visible ? selectedDateText.implicitHeight : 0
        visible: root.showHeader

        Text {
          id: selectedDateText
          anchors.top: parent.top; anchors.topMargin: 2
          anchors.left: parent.left
          anchors.right: parent.right
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 18
          font.weight: Font.DemiBold
          text: root.title
        }
      }

      Item {
        id: timeTumblersItem
        anchors.left: parent.left
        anchors.top: header.bottom
        anchors.right: parent.right
        anchors.bottom: footer.top
        anchors.margins: 20

        Tumbler {
          id: firstTimeTumbler
          anchors.left: parent.left
          anchors.leftMargin: root.range ? 0 : Math.ceil((parent.width / 2) - (width / 2))
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          width: Math.ceil(parent.width / 2.5)
          visibleItemCount: 5

          onCurrentIndexChanged: {
            secondTimeTumbler.model = root.minutesList.slice().splice(firstTimeTumbler.currentIndex + 1, root.minutesList.length)
          }

          delegate: Text {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
            font.pixelSize: 18
            text: root.formatText(modelData)
          }

          Rectangle {
            anchors.horizontalCenter: firstTimeTumbler.horizontalCenter
            y: Math.ceil(firstTimeTumbler.height * 0.4)
            width: firstTimeTumbler.width
            height: 1
            color: "#1EAAF1"
            z: -50
          }

          Rectangle {
            anchors.horizontalCenter: firstTimeTumbler.horizontalCenter
            y: Math.ceil(firstTimeTumbler.height * 0.6)
            width: firstTimeTumbler.width
            height: 1
            color: "#1EAAF1"
            z: -50
          }
        }

        Text {
          anchors.left: firstTimeTumbler.right
          anchors.right: secondTimeTumbler.left
          anchors.verticalCenter: firstTimeTumbler.verticalCenter
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 18
          text: "-"
          visible: root.range
        }

        Tumbler {
          id: secondTimeTumbler
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          width: Math.ceil(parent.width / 2.5)
          visibleItemCount: 5
          visible: root.range

          delegate: Text {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
            font.pixelSize: 18
            text: root.formatText(modelData)
          }

          Rectangle {
            anchors.horizontalCenter: secondTimeTumbler.horizontalCenter
            y: Math.ceil(secondTimeTumbler.height * 0.4)
            width: secondTimeTumbler.width
            height: 1
            color: "#1EAAF1"
            z: -50
          }

          Rectangle {
            anchors.horizontalCenter: secondTimeTumbler.horizontalCenter
            y: Math.ceil(secondTimeTumbler.height * 0.6)
            width: secondTimeTumbler.width
            height: 1
            color: "#1EAAF1"
            z: -50
          }
        }
      }

      Item {
        id: footer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: visible ? 40 : 0
        visible: root.showFooter

        Button {
          id: setBtnFooter
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          implicitHeight: 40
          text: qsTr("Set")
          color: "#1EAAF1"
          textColor: "#FFFFFF"

          onClicked: {
            var firstTime = firstTimeTumbler.model[firstTimeTumbler.currentIndex];
            var secondTime = 0
            if (root.range) {
              secondTime = secondTimeTumbler.model[secondTimeTumbler.currentIndex]
            }
            root.timeSelected(firstTime, secondTime)
            root.close();
          }
        }
      }
    }
  }
}
