#include "fiscaldevice.h"

#include <QDebug>

FiscalDevice::FiscalDevice(QString deviceName, QObject *parent) :
  QObject(parent),
  m_port(PortTCPIP),
  m_ipAddress(""),
  m_ipPort(""),
  m_storeTitle(""),
  m_deviceName(deviceName)
{
  //
}

void FiscalDevice::setIpPort(const QString &ipAddress, const QString &ipPort) {
  m_port = PortTCPIP;
  m_ipAddress = ipAddress;
  m_ipPort = ipPort;
}

void FiscalDevice::setStoreTitle(const QString &title) {
  m_storeTitle = title;
}

QString FiscalDevice::getErrors() {
  QString result = m_deviceName.length() > 0 ? m_deviceName + "\n" : "";

  for (int i = 0; i < m_errors.size(); i++) {
    result += m_errors[i].description + "(" + QString::number(m_errors[i].code) + ")" + "\n";
  }

  return result;
}

FiscalDevice::Error FiscalDevice::getLastError() const {
  return ErrorNoErrors;
}

void FiscalDevice::setDataForReport(const QVariantMap& dataForReport) {
  m_dataForReport = dataForReport;
}

void FiscalDevice::setCheckLanguage(const QString& lang) {
  m_checkLanguage = lang;
}

void FiscalDevice::log(const QString &message) {
  qInfo().noquote().nospace() << "|fsc|" + message;
}

QVariantMap FiscalDevice::getDataForReport() const {
  return m_dataForReport;
}

CheckLocalization::Lang FiscalDevice::getCheckLanguage() const {
  return cTr::getLanguage(m_checkLanguage);
}
