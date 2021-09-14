import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Dialog {
  id: root
  property string titleText: ""
  property string messageText: ""
  property int contentPadding: 16

  property string confirmButtonText: ""
  property color confirmButtonTextColor: "#1EAAF1"
  property string cancelButtonText: ""
  property color cancelButtonTextColor: "#D01A1A"
  property bool singleButton: false

  property var confirmHandle: undefined
  property var cancelHandle: undefined
  property var closeHandle: undefined
  property var userData: undefined

  property bool noAutoClose: false

  property int minWidth: 280
  property int maxWidth: 300

  x: Math.ceil(parent.width / 2 - width / 2)
  y: Math.ceil(parent.height / 2 - height / 2)

  closePolicy: root.noAutoClose ? Popup.NoAutoClose : Popup.CloseOnEscape | Popup.CloseOnPressOutside

  onClosed: {
    if (root.closeHandle) root.closeHandle(root.userData)
  }

  function openDialog(title, message, data, confirmHandle, cancelHandle, confirmButtonText, cancelButtonText) {
    root.titleText = title;
    root.messageText = message;
    root.userData = data;
    root.confirmHandle = confirmHandle ? confirmHandle : undefined;
    root.cancelHandle = cancelHandle ? cancelHandle : undefined;

    root.confirmButtonText = confirmButtonText ? confirmButtonText : qsTr("OK");
    root.cancelButtonText = cancelButtonText ? cancelButtonText : qsTr("Cancel");

    root.focus = true;
    root.open();
  }

  function openDialogExt(params) {
    root.showHeader = (params.showHeader === undefined) ? true : params.showHeader
    root.titleText = params.titleText ? params.titleText : (params.title ? params.title : "")
    root.messageText = params.messageText ? params.messageText : (params.message ? params.message : "");

    root.confirmButtonText = params.confirmButtonText ? params.confirmButtonText : qsTr("OK");
    root.confirmButtonTextColor = params.confirmButtonTextColor ? params.confirmButtonTextColor : "#1EAAF1";
    root.cancelButtonText = params.cancelButtonText ? params.cancelButtonText : qsTr("Cancel");
    root.cancelButtonTextColor = params.cancelButtonTextColor ? params.cancelButtonTextColor : "#D01A1A";
    root.singleButton = (params.singleButton === undefined) ? ((params.single === undefined) ? false : params.single) : params.singleButton;

    root.confirmHandle = params.confirmHandle;
    root.cancelHandle = params.cancelHandle;
    root.closeHandle = params.closeHandle;
    root.userData = params.userData;

    root.noAutoClose = (params.noAutoClose === undefined) ? false : params.noAutoClose;

    root.focus = true;
    root.open();
  }

  function closeDialog() {
    root.titleText = qsTr("Confirm action");
    root.messageText = "";

    root.confirmButtonText = qsTr("OK");
    root.confirmButtonTextColor = "#1EAAF1";
    root.cancelButtonText = qsTr("Cancel");
    root.cancelButtonTextColor = "#D01A1A";
    root.singleButton = false;

    root.confirmHandle = undefined;
    root.cancelHandle = undefined;
    root.userData = undefined;

    root.minWidth = 280;
    root.maxWidth = 300;

    root.noAutoClose = false;

    root.close();
  }

  header: Item {
    implicitWidth: titleItem.implicitWidth + root.contentPadding * 2
    implicitHeight: titleItem.implicitHeight + root.contentPadding * 2

    Item {
      id: titleItem
      anchors.left: parent.left; anchors.leftMargin: root.contentPadding
      anchors.right: parent.right; anchors.rightMargin: root.contentPadding
      anchors.top: parent.top; anchors.topMargin: root.contentPadding
      anchors.bottom: parent.bottom; anchors.bottomMargin: root.contentPadding
      implicitHeight: titleView.implicitHeight
      implicitWidth: Math.min(root.maxWidth, Math.max(titleView.implicitWidth, root.minWidth))

      Text {
        id: titleView
        anchors.fill: parent
        font.pixelSize: 17
        font.bold: true
        text: root.titleText
      }
    }
  }

  content: Item {
    implicitWidth: messageItem.implicitWidth + root.contentPadding * 2
    implicitHeight: messageItem.implicitHeight + root.contentPadding * 2

    Item {
      id: messageItem
      anchors.left: parent.left; anchors.leftMargin: root.contentPadding
      anchors.right: parent.right; anchors.rightMargin: root.contentPadding * 2
      anchors.top: parent.top; anchors.topMargin: root.contentPadding
      anchors.bottom: parent.bottom; anchors.bottomMargin: root.contentPadding
      implicitHeight: messageView.implicitHeight
      implicitWidth: Math.min(root.maxWidth, Math.max(messageView.implicitWidth, root.minWidth))

      Text {
        id: messageView
        anchors.fill: parent
        wrapMode: Text.Wrap
        font.pixelSize: 17
        text: root.messageText

        onLinkActivated: Qt.openUrlExternally(link)
      }
    }
  }

  footer: Item {
    implicitWidth: buttonItem.implicitWidth + root.contentPadding * 2
    implicitHeight: buttonItem.implicitHeight + root.contentPadding * 2

    Item {
      id: buttonItem
      anchors.left: parent.left; anchors.leftMargin: root.contentPadding
      anchors.right: parent.right; anchors.rightMargin: root.contentPadding
      anchors.top: parent.top; anchors.topMargin: root.contentPadding
      anchors.bottom: parent.bottom; anchors.bottomMargin: root.contentPadding
      implicitHeight: 40
      implicitWidth: Math.min(root.maxWidth, Math.max(confirmButton.implicitWidth + cancelButton.implicitWidth, root.minWidth))


      Button {
        id: confirmButton

        property int maxWidth: Math.ceil(parent.width - cancelButton.implicitWidth - 5)

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: root.singleButton ? parent.width : maxWidth//Math.ceil(parent.width / 2)
        height: 40
        flat: true

        contentItem: Text {
          id: confirmButtonView
          anchors.fill: parent
          text: root.confirmButtonText
          font.pixelSize: 17
          color: root.confirmButtonTextColor
          horizontalAlignment: root.singleButton || lineCount > 1 ? Text.AlignHCenter : Text.AlignLeft
          verticalAlignment: Text.AlignVCenter
          maximumLineCount: 2
          wrapMode: Text.WordWrap

          states: State {
            name: "pressed"
            when: confirmButton.pressed
            PropertyChanges {
              target: confirmButtonView
              color: Qt.tint(root.confirmButtonTextColor, "#33000000")
            }
          }
        }

        background: Item {
          anchors.fill: parent
        }

        onClicked: {
          if (root.confirmHandle) root.confirmHandle(root.userData);
          root.closeDialog();
        }
      }

      Button {
        id: cancelButton
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: Math.ceil(parent.width - confirmButton.width - 5)
        height: 40
        flat: true
        visible: !root.singleButton

        contentItem: Text {
          id: cancelButtonView
          anchors.fill: parent
          text: root.cancelButtonText
          font.pixelSize: 17
          color: root.cancelButtonTextColor
          horizontalAlignment: lineCount > 1 ? Text.AlignHCenter : Text.AlignRight
          verticalAlignment: Text.AlignVCenter
          maximumLineCount: 2
          wrapMode: Text.WordWrap

          states: State {
            name: "pressed"
            when: cancelButton.pressed
            PropertyChanges {
              target: cancelButtonView
              color: Qt.tint(root.cancelButtonTextColor, "#33000000")
            }
          }
        }

        background: Item {
          anchors.fill: parent
        }

        onClicked: {
          if (root.cancelHandle) root.cancelHandle(root.userData);
          root.closeDialog();
        }
      }
    }
  }
}
