//
//  AccountNotLoggedInController.m
//  gameqa
//
//  Created by user on 12-9-11.
//
//

#import "AccountNotLoginActivity.h"

#import "LoginActivity.h"
#import "RegisterActivity.h"

#import "AboutActivity.h"
#import "HelpActivity.h"

// 新版本更新相关
#import "VersionNetRespondBean.h"
#import "MyApplication.h"









static const NSString *const TAG = @"<AccountNotLoginActivity>";









@interface AccountNotLoginActivity ()

@property (nonatomic, retain) VersionNetRespondBean *versionBean;

//
@property (nonatomic, assign) BOOL newVersionChecking;
@end









@implementation AccountNotLoginActivity



- (void)dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [_versionBean release];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    //
    _newVersionChecking = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)loginButtonOnClickListener:(id)sender {
  Intent *intent = [Intent intentWithSpecificComponentClass:[LoginActivity class]];
  [self startActivity:intent];
}

- (IBAction)registerButtonOnClickListener:(id)sender {
  Intent *intent = [Intent intentWithSpecificComponentClass:[RegisterActivity class]];
  [self startActivity:intent];
}

- (IBAction)helpButtonOnClickListener:(id)sender {
  Intent *intent = [Intent intentWithSpecificComponentClass:[HelpActivity class]];
  [self startActivity:intent];
}

- (IBAction)versionButtonOnClickListener:(id)sender {
  if (!_newVersionChecking) {
    _newVersionChecking = YES;
    
    // 启动 "新版本信息检测" 子线程
    [NSThread detachNewThreadSelector:@selector(newAppVersionCheckThread) toTarget:self withObject:nil];
  }
}

- (IBAction)aboutButtonOnClickListener:(id)sender {
  Intent *intent = [Intent intentWithSpecificComponentClass:[AboutActivity class]];
  [self startActivity:intent];
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
}
-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
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
