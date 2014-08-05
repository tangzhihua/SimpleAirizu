//
//  AccountActivity.m
//  airizu
//
//  Created by 唐志华 on 13-1-25.
//
//

#import "AccountActivity.h"
#import "AccountNotLoginActivity.h"
#import "AccountLoggedActivity.h"

#import "AboutActivity.h"









static const NSString *const TAG = @"<AccountActivity>";









@interface AccountActivity ()
//
@property (nonatomic, retain) AccountNotLoginActivity *notLoginActivity;
@property (nonatomic, retain) AccountLoggedActivity *loggedActivity;
//
@property (nonatomic, assign) Activity *activeActivity;

@end









@implementation AccountActivity

#pragma mark -
#pragma mark 内部方法群
- (void)dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [self unregisterReceiver];
  
  //
  [_notLoginActivity release];
  [_loggedActivity release];
  
  //
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    _activeActivity = nil;
    _notLoginActivity = [[AccountNotLoginActivity alloc] init];
    _loggedActivity = [[AccountLoggedActivity alloc] init];
    
    
    IntentFilter *intentFilter = [IntentFilter intentFilter];
    // 向通知中心注册通知 : "用户退出登录"
    [intentFilter.actions addObject:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_UserLoged] stringValue]];
    [self registerReceiver:intentFilter];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self changeActivityTest];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark UI相关
-(void)changeActivityTest{
  Activity *newActivity = nil;
  if ([GlobalDataCacheForMemorySingleton sharedInstance].logonNetRespondBean != nil) {
    // 用户已经登录
    newActivity = _loggedActivity;
  } else {
    // 用户还未登录
    newActivity = _notLoginActivity;
  }
  
  if (_activeActivity != newActivity) {
    if ([_activeActivity isKindOfClass:[Activity class]]) {
      [_activeActivity.view removeFromSuperview];
    }
    
    // 将新 Activity 插入
    [self.view addSubview:newActivity.view];
    self.activeActivity = newActivity;
  }
  
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  [_activeActivity onPause];
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
  [self changeActivityTest];
  
  [_activeActivity onResume];
}

-(void)onActivityResult:(int)requestCode resultCode:(int)resultCode data:(Intent *)data {
  [_activeActivity onActivityResult:requestCode resultCode:resultCode data:data];
}

#pragma mark -
#pragma mark 实现 BroadcastReceiverDelegate 代理
-(void)onReceive:(Intent *)intent {
  NSInteger userNotificationEnum = [[intent action] integerValue];
  if (userNotificationEnum == kUserNotificationEnum_UserLoged) {
    [self onResume];
  }
}



@end
