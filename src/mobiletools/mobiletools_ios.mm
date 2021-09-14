#include "mobiletools_p.h"

#include <UIKit/UIKit.h>
#include <Photos/Photos.h>

@interface BCViewController : NSObject<UITextViewDelegate> {} @end

@interface BCViewController ()
@property MobileToolsPrivate* mtp;
@end

@implementation BCViewController

-(void)textViewDidChange:(UITextView *) tv {
  uchar ch = [tv.text characterAtIndex:tv.text.length-1];
  if (ch == '\n') {
    QString bc = QString::fromNSString(tv.text).trimmed();
    if (self.mtp) {
      emit self.mtp->sendBarcodeText(bc);
    }
    tv.text = nil;
  }
}

- (BOOL)textViewShouldEndEditing:(UITextView *) tv {
  return !(self.mtp->getNeedFocus() && self.mtp->getUseBarcodeScanner());
}

@end

@interface CFABackgroundTask : NSObject
  @property (nonatomic, readonly) NSString *identifier;
  @property (nonatomic, readonly) BOOL isActive;

  - (instancetype) init __attribute__((unavailable("Use the UIApplication category methods")));
  - (void)invalidate;
@end

@interface UIApplication (CFABackgroundTask)
  + (CFABackgroundTask *) cfa_backgroundTask;
  + (CFABackgroundTask *) cfa_backgroundTaskWithExpiration:(void(^)()) expiration;
@end

@interface CFABackgroundTask ()
  @property (nonatomic, readwrite) NSString *identifier;
  @property (nonatomic, readwrite) UIBackgroundTaskIdentifier bgTask;
@end

@implementation CFABackgroundTask
- (instancetype) initWithExpiration:(void(^)()) expiration {
  self = [super init];
  if (self) {
    self.identifier = [[NSUUID UUID] UUIDString];
    typeof(self) weakSelf = self;

    self.bgTask = [[UIApplication sharedApplication]
                  beginBackgroundTaskWithName:self.identifier
                                              expirationHandler:^{
                                                if (expiration != nil) {
                                                  expiration();
                                                }
                                                if (weakSelf.bgTask != UIBackgroundTaskInvalid) {
                                                  [[UIApplication sharedApplication] endBackgroundTask:weakSelf.bgTask];
                                                  weakSelf.bgTask = UIBackgroundTaskInvalid;
                                                }
                                              }];
  }
  return self;
}

- (void) dealloc {
  [self invalidate];
}

- (void) invalidate {
  if (self.bgTask != UIBackgroundTaskInvalid) {
    [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
    self.bgTask = UIBackgroundTaskInvalid;
  }
}

- (BOOL) isActive {
  return self.bgTask != UIBackgroundTaskInvalid;
}

@end

#pragma mark - Category

@implementation UIApplication (CFABackgroundTask)
  + (CFABackgroundTask *)cfa_backgroundTask {
    return [self cfa_backgroundTaskWithExpiration:nil];
  }

  + (CFABackgroundTask *)cfa_backgroundTaskWithExpiration:(void (^)())expiration {
    return [[CFABackgroundTask alloc] initWithExpiration:expiration];
  }
@end

CFABackgroundTask *task;

UITextView *barcodeView;

UIViewController *getViewController() {
  NSArray *windows = [[UIApplication sharedApplication]windows];
  for (UIWindow *window in windows) {
    if (window.isKeyWindow) {
      return window.rootViewController;
    }
  }
  return nil;
}

MobileToolsPrivate::MobileToolsPrivate() {
  [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
  barcodeView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  barcodeView.inputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
  barcodeView.autocorrectionType = UITextAutocorrectionTypeNo;
  UITextInputAssistantItem* item = barcodeView.inputAssistantItem;
  item.leadingBarButtonGroups = @[];
  item.trailingBarButtonGroups = @[];

  BCViewController *viewController = [BCViewController alloc];
  viewController.mtp = this;
  barcodeView.delegate = viewController;
}

QString MobileToolsPrivate::getOSVersion() {
  return QString::fromNSString([[UIDevice currentDevice] systemVersion]);
}

void MobileToolsPrivate::shareText(const QStringList &filesToSend) {
  NSMutableArray *sharingItems = [NSMutableArray new];

  for (int i = 0; i < filesToSend.size(); i++) {
    NSURL *logFileUrl = [[NSURL alloc] initFileURLWithPath:filesToSend[i].toNSString()];
    [sharingItems addObject:logFileUrl];
  }

  UIViewController *qtController = getViewController();
  if (!qtController) return;

  UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];

  [qtController presentViewController:activityController animated:YES completion:nil];
  UIPopoverPresentationController *popController = activityController.popoverPresentationController;
  if (popController) {
    popController.sourceView = qtController.view;
    popController.sourceRect = CGRectMake(0, 0, 100, 100);
  }
}

void MobileToolsPrivate::shareLink(const QString &link) {
  NSMutableArray *sharingItems = [NSMutableArray new];

  if (!link.isEmpty()) {
    [sharingItems addObject:link.toNSString()];
  }

  UIViewController *qtController = getViewController();
  if (!qtController) return;

  UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];

  [qtController presentViewController:activityController animated:YES completion:nil];
  UIPopoverPresentationController *popController = activityController.popoverPresentationController;
  if (popController) {
    popController.sourceView = qtController.view;
    popController.sourceRect = CGRectMake(0, 0, 100, 100);
  }
}

bool MobileToolsPrivate::getAccessToGallery() {
  PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
  if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusNotDetermined) {
    return true;
  }
  if (status == PHAuthorizationStatusDenied) {
    return false;
  }
  return false;
}

bool MobileToolsPrivate::getAccessToCamera() {
  NSString *mediaType = AVMediaTypeVideo;
  AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
  if(status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined) {
    return true;
  }
  if(status == AVAuthorizationStatusDenied) {
    return false;
  }
  return false;
}

void MobileToolsPrivate::setFocusBarcodeView() {
  if (!m_barcodeScannerEnabled) { return; }
  m_needFocus = true;
  if (!barcodeView.focused) {
    if ([barcodeView canBecomeFirstResponder]) {
      [barcodeView becomeFirstResponder];
    }
  }
}

void MobileToolsPrivate::setUnfocusBarcodeView() {
  if (!m_barcodeScannerEnabled) { return; }
  m_needFocus = false;
  [barcodeView resignFirstResponder];
}

void MobileToolsPrivate::addBarcodeView() {
  UIViewController *qtController = getViewController();
  if (!qtController) return;
  NSArray *subviews = [qtController.view subviews];
  if (![subviews containsObject:barcodeView]) {
    [qtController.view addSubview:barcodeView];
  }
  setFocusBarcodeView();
}

QString MobileToolsPrivate::getTextBarcodeView() {
  if (!m_barcodeScannerEnabled) { return ""; }
  return QString::fromNSString(barcodeView.text).trimmed();
}

void MobileToolsPrivate::setUseBarcodeScanner(bool useBarcodeScanner) {
  m_barcodeScannerEnabled = useBarcodeScanner;
}

void MobileToolsPrivate::startBackgroundTask() {
  task = [UIApplication cfa_backgroundTask];
}

void MobileToolsPrivate::stopBackgroundTask() {
  [task invalidate];
}
