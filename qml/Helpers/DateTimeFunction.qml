import QtQuick 2.9

QtObject {

  property var availableMinutes: []
  readonly property int intervalMinutes: 30
  readonly property int maxMinutes: 24*60

  readonly property var timeList: [
    "00:00", "00:30", "01:00", "01:30", "02:00", "02:30", "03:00", "03:30",
    "04:00", "04:30", "05:00", "05:30", "06:00", "06:30", "07:00", "08:30",
    "09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30",
    "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30",
    "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30",
    "21:00", "21:30", "22:00", "22:30", "23:00", "23:30", "24:00"
  ]

  function getHours(value) {
    return Math.floor(value / 60);
  }

  function getMinutes(value) {
    return (value % 60).toFixed(0);
  }

  function getTime(value) {
    var hours = getHours(value);
    var minutes = getMinutes(value);
    return timeToString(hours, minutes);
  }

  function timeToString(hours, minutes) {
    return (hours.toString().length < 2 ? "0" + hours : hours) + ":" +
           (minutes.toString().length < 2 ? "0" + minutes : minutes)
  }

  function soon(minutes, inc) {
    for (var i = 0; i < availableMinutes.length; i++) {
      if (availableMinutes[i-inc] > minutes) {
        return availableMinutes[i];
      }
    }
  }

  Component.onCompleted: {
    availableMinutes = [];
    for (var i = 0; i <= maxMinutes; i += intervalMinutes) {
      availableMinutes.push(i)
    }
  }

}
