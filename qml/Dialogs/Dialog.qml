import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Popup {
  id: root
  property bool showHeader: true
  property alias header: headerLoader.sourceComponent
  property alias content: contentLoader.sourceComponent
  property alias footer: footerLoader.sourceComponent

  modal: true
  dim: true
  closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
  padding: 0

  enter: Transition {
    NumberAnimation {
      property: "opacity"
      from: 0.0
      to: 1.0
    }
  }

  background: Item {
    Rectangle {
      id: backgroundView
      anchors.fill: parent
      radius: 8
      color: "white"
    }
  }

  contentItem: Item {
    implicitWidth: Math.max(header.implicitWidth, content.implicitWidth,
                            footer.implicitWidth)
    implicitHeight: (root.showTitle ? header.implicitHeight + header.anchors.topMargin : 0)
                    + content.implicitHeight + content.anchors.topMargin + content.anchors.bottomMargin
                    + footer.implicitHeight

    Item {
      id: header
      implicitHeight: headerLoader.implicitHeight
      implicitWidth: headerLoader.implicitWidth
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.topMargin: root.showHeader ? 10 : 0
      anchors.right: parent.right
      visible: root.showHeader

      Loader {
        id: headerLoader
        anchors.fill: parent
      }
    }

    Item {
      id: content
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: root.showHeader ? header.bottom : parent.top
      anchors.topMargin: root.showHeader ? 15 : 10
      anchors.bottom: footer.top
      anchors.bottomMargin: 10
      implicitWidth: contentLoader.implicitWidth
      implicitHeight: contentLoader.implicitHeight

      Loader {
        id: contentLoader
        asynchronous: true
        anchors.fill: parent
      }
    }

    Item {
      id: footer
      implicitHeight: footerLoader.implicitHeight
      implicitWidth: footerLoader.implicitWidth
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right

      Loader {
        id: footerLoader
        anchors.fill: parent
      }
    }
  }
}
