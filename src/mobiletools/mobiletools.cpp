#include "mobiletools.h"

#include <QSysInfo>

MobileTools::MobileTools(PosConfig *pConfig, PosSettings *pSettings, QObject *parent) :
  PosController(pConfig, pSettings, parent)
{
  setObjectName("MobileToolsController");
  initDebugMode();
  m_pPrivate = new MobileToolsPrivate();
  m_pPrivate->sendBarcodeText = [&](QString bc){
    if (!bc.isEmpty()) {
      emit barcodeRead(bc);
    }
  };
}

MobileTools::~MobileTools() {
  delete m_pPrivate;
  m_pPrivate = nullptr;
}

QString MobileTools::getOSVersion() {
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
  return QSysInfo::productType() + ", " + QSysInfo::productVersion();
#else
  return m_pPrivate->getOSVersion();
#endif
}

bool MobileTools::getAccessToGallery() {
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
  return true;
#else
  return m_pPrivate->getAccessToGallery();
#endif
}

bool MobileTools::getAccessToCamera() {
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
  return true;
#else
  return m_pPrivate->getAccessToCamera();
#endif
}

void MobileTools::shareText(const QStringList &filesToSend) {
  if (filesToSend.isEmpty()) return;
  m_pPrivate->shareText(filesToSend);
}

void MobileTools::shareLink(const QString &link) {
  if (link.isEmpty()) return;
  m_pPrivate->shareLink(link);
}

void MobileTools::setFocusBarcodeView() {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
  m_pPrivate->setFocusBarcodeView();
#endif
}

void MobileTools::setUnfocusBarcodeView() {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
  m_pPrivate->setUnfocusBarcodeView();
#endif
}

void MobileTools::addBarcodeView() {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
  m_pPrivate->addBarcodeView();
#endif
}

QString MobileTools::getTextBarcodeView() {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
  return m_pPrivate->getTextBarcodeView();
#else
  return "";
#endif
}

void MobileTools::setUseBarcodeScanner(bool useBarcodeScanner) {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
  m_pPrivate->setUseBarcodeScanner(useBarcodeScanner);
#endif
}

void MobileTools::startBackgroundTask() {
#if defined(Q_OS_IOS)
    m_pPrivate->startBackgroundTask();
#endif
}

void MobileTools::stopBackgroundTask() {
#if defined(Q_OS_IOS)
    m_pPrivate->stopBackgroundTask();
#endif
}