//
//  AccountLoggedController.m
//  gameqa
//
//  Created by user on 12-9-11.
//
//

#import "AccountLoggedActivity.h"

#import "AccountIndexDatabaseFieldsConstant.h"
#import "AccountIndexNetRequestBean.h"
#import "AccountIndexNetRespondBean.h"

#import "LogoutDatabaseFieldsConstant.h"
#import "LogoutNetRequestBean.h"

#import "UserOrderCenterActivity.h"
#import "AboutActivity.h"
#import "SystemMessageCenterActivity.h"
#import "UserInformationActivity.h"

#import "HelpActivity.h"

#import "UIColor+ColorSchemes.h"

// 新版本更新相关
#import "VersionNetRespondBean.h"
#import "MyApplication.h"

#import "AFImageCache.h"










static const NSString *const TAG = @"<AccountLoggedActivity>";









@interface AccountLoggedActivity ()
//
@property (nonatomic, assign) NSInteger netRequestIndexForGetAccountIndexInfo;

@property (nonatomic, retain) AccountIndexNetRespondBean *accountIndexNetRespondBean;

@property (nonatomic, retain) VersionNetRespondBean *versionBean;

//
@property (nonatomic, assign) BOOL newVersionChecking;
@end










@implementation AccountLoggedActivity

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 2.15 获取账号首页信息
  kNetRequestTagEnum_GetAccountIndexInfo = 0,
  // 2.17 登出
  kNetRequestTagEnum_UserLogout
};

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  kIntentRequestCodeEnum_ToUserInformationActivity = 0
};

#pragma mark -
#pragma mark 实例方法群
- (void)dealloc {
  
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  //
  [_accountIndexNetRespondBean release];
  //
  [_versionBean release];
  
  // UI
  [_scrollView release];
  [_userPhotoUIImageView release];
  [_userNameUILabel release];
  [_userTotalPointUILabel release];
  [_waitConfirmCountUILabel release];
  [_waitPayCountUILabel release];
  [_waitLiveCountUILabel release];
  [_waitReviewCountUILabel release];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _netRequestIndexForGetAccountIndexInfo = IDLE_NETWORK_REQUEST_ID;
    
    _newVersionChecking = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  CGSize newSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
  [_scrollView setContentSize:newSize];
  
}

- (void)viewDidUnload
{
  
  [self setScrollView:nil];
  [self setUserPhotoUIImageView:nil];
  [self setUserNameUILabel:nil];
  [self setUserTotalPointUILabel:nil];
  [self setWaitConfirmCountUILabel:nil];
  [self setWaitPayCountUILabel:nil];
  [self setWaitLiveCountUILabel:nil];
  [self setWaitReviewCountUILabel:nil];
  
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)gotoUserOrderMainActivityWithOrderState:(OrderStateEnum)orderStateEnum {
  Intent *intent = [Intent intentWithSpecificComponentClass:[UserOrderCenterActivity class]];
  [intent.extras setObject:[NSNumber numberWithUnsignedInteger:orderStateEnum] forKey:kIntentExtraTagForUserOrderCenterActivity_OrderState];
  [self startActivity:intent];
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  [SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForGetAccountIndexInfo];
  _netRequestIndexForGetAccountIndexInfo = IDLE_NETWORK_REQUEST_ID;
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
  if (_netRequestIndexForGetAccountIndexInfo == IDLE_NETWORK_REQUEST_ID) {
    [self requestUserAccountIndexInfo:YES];
  }
}

- (void) onActivityResult:(int) requestCode
               resultCode:(int) resultCode
                     data:(Intent *) data {
  PRPLog(@"%@ onActivityResult", TAG);
  
  do {
    if (resultCode != kActivityResultCode_RESULT_OK) {
      break;
    }
    
    if (requestCode == kIntentRequestCodeEnum_ToUserInformationActivity) {
      // 从 "用户信息界面" 返回到此的, 返回 "RESULT_OK"
      //[self requestUserAccountIndexInfo:YES];
    }
    
  } while (false);
}

#pragma mark -
#pragma mark 按钮点击时间监听方法群

// "待确认"
- (IBAction)waitConfirmCountButtonOnClickListener:(id)sender {
  [self gotoUserOrderMainActivityWithOrderState:kOrderStateEnum_WaitConfirm];
}

// "待支付"
- (IBAction)waitPayCountButtonOnClickListener:(id)sender {
  [self gotoUserOrderMainActivityWithOrderState:kOrderStateEnum_WaitPay];
}

// "待入住"
- (IBAction)waitLiveCountButtonOnClickListener:(id)sender {
  [self gotoUserOrderMainActivityWithOrderState:kOrderStateEnum_WaitLive];
}

// "带评论"
- (IBAction)waitReviewCountButtonOnClickListener:(id)sender {
  [self gotoUserOrderMainActivityWithOrderState:kOrderStateEnum_WaitComment];
}

// "用户信息界面"
- (IBAction)userInfoButtonOnClickListener:(id)sender {
  Intent *intent = [Intent intentWithSpecificComponentClass:[UserInformationActivity class]];
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToUserInformationActivity];
}

// "系统消息界面"
- (IBAction)systemMessageButtonOnClickListener:(id)sender {
  Intent *intent = [Intent intentWithSpecificComponentClass:[SystemMessageCenterActivity class]];
  [self startActivity:intent];
}

// "帮助界面"
- (IBAction)helpButtonOnClickListener:(id)sender {
  Intent *intent = [Intent intentWithSpecificComponentClass:[HelpActivity class]];
  [self startActivity:intent];
}

// "版本检测"
- (IBAction)versionButtonOnClickListener:(id)sender {
  if (!_newVersionChecking) {
    _newVersionChecking = YES;
    
    // 启动 "新版本信息检测" 子线程
    [NSThread detachNewThreadSelector:@selector(newAppVersionCheckThread) toTarget:self withObject:nil];
  }
}

// "关于界面"
- (IBAction)aboutButtonOnClickListener:(id)sender {
  Intent *intent = [Intent intentWithSpecificComponentClass:[AboutActivity class]];
  [self startActivity:intent];
}

// "退出登录按钮"
- (IBAction)logoutButtonOnClickListener:(id)sender {
  [ToolsFunctionForThisProgect clearLogonInfo];
  [self requestUserAccountLogout];
  self.accountIndexNetRespondBean = nil;
  
  Intent *intent = [Intent intent];
  [intent setAction:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_UserLoged] stringValue]];
  [self sendBroadcast:intent];
}

#pragma mark -
#pragma mark 网络方法群

// 开始请求, 2.15 获取账号首页信息
-(void)requestUserAccountIndexInfo:(BOOL)isNeedShowProgressDialog {
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForGetAccountIndexInfo];
  
  AccountIndexNetRequestBean *netRequestBean = [AccountIndexNetRequestBean accountIndexNetRequestBean];
  _netRequestIndexForGetAccountIndexInfo
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:netRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_GetAccountIndexInfo
                                                                     andRespondDelegate:self];
  if (isNeedShowProgressDialog && _netRequestIndexForGetAccountIndexInfo != IDLE_NETWORK_REQUEST_ID) {
    [SVProgressHUD showSuccessWithStatus:@"联网中..."];
  }
  
}

// 开始请求, 用户退出登录
-(void)requestUserAccountLogout {
  LogoutNetRequestBean *netRequestBean = [LogoutNetRequestBean logoutNetRequestBean];
  [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                 andRequestDomainBean:netRequestBean
                                                                      andRequestEvent:kNetRequestTagEnum_UserLogout
                                                                   andRespondDelegate:self];
}

typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  //
  kHandlerMsgTypeEnum_RefreshUI
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage,
  //
  kHandlerExtraDataTypeEnum_AccountIndexNetRespondBean
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
    }break;
      
    case kHandlerMsgTypeEnum_RefreshUI:{
      
      AccountIndexNetRespondBean *accountIndexNetRespondBean
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_AccountIndexNetRespondBean]];
      
      // "用户名"
      [_userNameUILabel setText:accountIndexNetRespondBean.userName];
      // "用户积分"
      [_userTotalPointUILabel setText:[NSString stringWithFormat:@"%@ 分", [accountIndexNetRespondBean.totalPoint stringValue]]];
      // "用户头像"
      NSURL *urlForUserPhoto = [NSURL URLWithString:accountIndexNetRespondBean.userImageURL];
      UIImage *placeholderImage = [UIImage imageNamed:@"user_avatar_background"];
      // 清除本地缓存的图片
      [[AFImageCache sharedImageCache] removeObjectForURL:urlForUserPhoto cacheName:nil];
      [_userPhotoUIImageView setImageWithURL:urlForUserPhoto placeholderImage:placeholderImage];
      
      // 当前用户各种订单数量
      NSString *zero = @"0";
      // "等待房东确认"
      [_waitConfirmCountUILabel setText:[accountIndexNetRespondBean.waitConfirmCount stringValue]];
      if ([zero isEqualToString:_waitConfirmCountUILabel.text]) {
        [_waitConfirmCountUILabel setTextColor:[UIColor colorForLabelBrightColorText]];
      } else {
        [_waitConfirmCountUILabel setTextColor:[UIColor colorForLabelOrangeText]];
      }
      // "等待支付"
      [_waitPayCountUILabel setText:[accountIndexNetRespondBean.waitPayCount stringValue]];
      if ([zero isEqualToString:_waitPayCountUILabel.text]) {
        [_waitPayCountUILabel setTextColor:[UIColor colorForLabelBrightColorText]];
      } else {
        [_waitPayCountUILabel setTextColor:[UIColor colorForLabelOrangeText]];
      }
      // "等待入住"
      [_waitLiveCountUILabel setText:[accountIndexNetRespondBean.waitLiveCount stringValue]];
      if ([zero isEqualToString:_waitLiveCountUILabel.text]) {
        [_waitLiveCountUILabel setTextColor:[UIColor colorForLabelBrightColorText]];
      } else {
        [_waitLiveCountUILabel setTextColor:[UIColor colorForLabelOrangeText]];
      }
      // "等待评价"
      [_waitReviewCountUILabel setText:[accountIndexNetRespondBean.waitReviewCount stringValue]];
      if ([zero isEqualToString:_waitReviewCountUILabel.text]) {
        [_waitReviewCountUILabel setTextColor:[UIColor colorForLabelBrightColorText]];
      } else {
        [_waitReviewCountUILabel setTextColor:[UIColor colorForLabelOrangeText]];
      }
      
      self.accountIndexNetRespondBean = accountIndexNetRespondBean;
      
      [SVProgressHUD dismiss];
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_GetAccountIndexInfo == requestEvent) {
    _netRequestIndexForGetAccountIndexInfo = IDLE_NETWORK_REQUEST_ID;
  }
}

/**
 * 此方法处于非UI线程中
 *
 * @param requestEvent
 * @param errorBean
 * @param respondDomainBean
 */
- (void) domainNetRespondHandleInNonUIThread:(in NSUInteger) requestEvent
                                   errorBean:(in NetErrorBean *) errorBean
                           respondDomainBean:(in id) respondDomainBean {
  
  PRPLog(@"%@ -> domainNetRespondHandleInNonUIThread --- start ! ", TAG);
  [self clearNetRequestIndexByRequestEvent:requestEvent];
  
  if (errorBean.errorType != NET_ERROR_TYPE_SUCCESS) {
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_ShowNetErrorMessage;
    // 出现错误的 网络事件 tag
    [msg.data setObject:[NSNumber numberWithUnsignedInteger:requestEvent]
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetRequestTag]];
    // 该 网络事件, 对应的错误信息
    [msg.data setObject:errorBean.errorMessage
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
    
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
  }
  
  if (requestEvent == kNetRequestTagEnum_GetAccountIndexInfo) {
    AccountIndexNetRespondBean *accountIndexNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, accountIndexNetRespondBean);
    
    // 跳转到 "房间详情界面"
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_RefreshUI;
    [msg.data setObject:accountIndexNetRespondBean
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_AccountIndexNetRespondBean]];
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
  }
}

#pragma mark -
#pragma mark App新版本检查子线程
- (void) newAppVersionCheckThread {
  
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  NSNumber *isHasNewVersion = [NSNumber numberWithBool:NO];
  do {
    self.versionBean = [ToolsFunctionForThisProgect checkNewVersionAndReturnVersionBean];
    if (![_versionBean isKindOfClass:[VersionNetRespondBean class]]) {
      break;
    }
    
    if ([_versionBean.latestVersion isEqualToString:[ToolsFunctionForThisProgect localAppVersion]]) {
      break;
    }
    
    isHasNewVersion = [NSNumber numberWithBool:YES];
  } while (NO);
  
  // 在iOS5.0的系统之上时, UI操作都必须回到 MainThread
  [self performSelectorOnMainThread:@selector(newAppUpdateHint:) withObject:isHasNewVersion waitUntilDone:NO];
  
	[pool drain];
}

-(void)newAppUpdateHint:(NSNumber *)isHasNewVersion{
  if ([isHasNewVersion boolValue]) {
    UIAlertView *alert
    = [[UIAlertView alloc] initWithTitle:nil
                                 message:@"有新的版本更新，是否前往更新？"
                                delegate:self
                       cancelButtonTitle:@"关闭"
                       otherButtonTitles:@"更新", nil];
    [alert show];
    [alert release];
  } else {
    [SVProgressHUD showSuccessWithStatus:@"本地版本已是最新."];
  }
  
  _newVersionChecking = NO;
}

#pragma mark -
#pragma mark 实现 UIAlertViewDelegate 接口
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if (buttonIndex != [alertView cancelButtonIndex]) {
    MyApplication *application = (MyApplication *)[UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:_versionBean.downloadAddress] forceOpenInSafari:YES];
  }
}

@end
