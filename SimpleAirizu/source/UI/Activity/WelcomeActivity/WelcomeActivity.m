//
//  FirstActivity.m
//  airizu
//
//  Created by 唐志华 on 12-12-22.
//
//

#import "WelcomeActivity.h"

#import "BeginnerGuideActivity.h"
//#import "MainNavigationActivity.h"

static const NSString *const TAG = @"<WelcomeActivity>";

@interface WelcomeActivity ()

@end

@implementation WelcomeActivity

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    PRPLog(@"%@: %@", NSStringFromSelector(_cmd), self);
  }
  
  return self;
}

- (void)viewDidLoad {
  PRPLog(@"%@ --> viewDidLoad ", TAG);
  
  [super viewDidLoad];
  
  // 在欢迎界面等待5秒中, 在进入下一个界面
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    Intent *intent = nil;
    if ([GlobalDataCacheForMemorySingleton sharedInstance].isNeedShowBeginnerGuide) {
      intent = [self intentForGotoBeginnerGuideActivity];
    } else {
      intent = [self intentForGotoMainActivity];
    }
    
    // skyduck : 决不能在 viewDidLoad 中关闭自己或者启动新的Activity, 必须要使用异步机制.
    [self finishSelfAndStartNewActivity:intent];
  });
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Activity 生命周期
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
#pragma mark -
- (Intent *)intentForGotoBeginnerGuideActivity {
  return [Intent intentWithSpecificComponentClass:[BeginnerGuideActivity class]];
}

- (Intent *)intentForGotoMainActivity {
#if 0
  return [Intent intentWithSpecificComponentClass:[MainNavigationActivity class]];
#else
  return nil;
#endif
}


@end
