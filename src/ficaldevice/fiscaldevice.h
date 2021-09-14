#ifndef FISCALDEVICE_H
#define FISCALDEVICE_H

#include <QObject>
#include <QDateTime>
#include "printdocument.h"
#include "checklocalization.h"

class FiscalDevice : public QObject {
  Q_OBJECT

public:

  enum Port {
    PortTCPIP = 1
  };
  Q_ENUMS(Port)

  enum ShiftState {
    ShiftStateOpened = 1,
    ShiftStateClosed,
    ShiftStateExpired
  };
  Q_ENUMS(ShiftState)

  enum Error {
    ErrorNoErrors = 0,
    ErrorNoConnection, // Ошибка соединения (Принтер занят, порт занят, недоступный порт)
    ErrorUnknown // Неизвестная ошибка
  };
  Q_ENUMS(Error)

  /**
   * @brief Теги для заполнения реквизитов кассового чека
   */
  enum TagsTLV {
    TLV_DateTime = 1012,
    TLV_ShiftNumber = 1038, // номер смены
    TLV_CashierName = 1021, // кассир
    TLV_CashierInn = 1203   // инн кассира
  };
  Q_ENUMS(TagsTLV)

protected:
  struct ErrorInfo {
    int code;
    QString description;
  };

  Port m_port;
  QString m_ipAddress;
  QString m_ipPort;

  QString m_storeTitle;
  QList<ErrorInfo> m_errors;

  QString m_deviceName;

  QVariantMap getDataForReport() const;
  cTr::Lang getCheckLanguage() const;

public:
  explicit FiscalDevice(QString deviceName, QObject *parent = nullptr);

  void setIpPort(const QString &ipAddress, const QString &ipPort);

  void setStoreTitle(const QString &title);
  virtual QString getErrors();

  virtual Error getLastError() const;
  virtual ShiftState getShiftState() = 0;
  virtual void setCashierPassword(int cashierPassword) = 0;
  virtual void setUser(const QString& userName, const QString& userPassword) = 0;

  virtual void openShift(const QString &cashierName, const QString &cashierInn) = 0;
  virtual void closeShift(bool force, const QString &cashierName, const QString &cashierInn) = 0;
  virtual void printXReport() = 0;
  virtual void printReceipt(const QVariantMap &receiptData, const QString &key = "") = 0;
  virtual void printDocument(PrintDocument &printDocument, const QString &key = "") = 0;

  virtual const QDateTime getDeviceDate() const = 0;
  virtual const QDateTime getShiftDate() const = 0;

  void setDataForReport(const QVariantMap& dataForReport);
  void setCheckLanguage(const QString& lang);

  static void log(const QString& message);

private:
  QVariantMap m_dataForReport;
  QString m_checkLanguage;

signals:
  void documentPrinted(bool success, const QString &key);
  void receiptPrinted(bool success, const QString &receiptType, const QString &key);
  void shiftOpened(bool success);
  void shiftClosed(bool success, bool forceCloseShift);
  void xReportPrinted(bool success);

};

#endif // FISCALDEVICE_H
