//
//  HomepageActivity.m
//  gameqa
//
//  Created by user on 12-9-11.
//
//

#import "MainNavigationActivity.h"

#import "RecommendCitiesActivity.h"
#import "SearchActivity.h"
#import "RoomListActivity.h"
#import "AccountActivity.h"

#import "TitleBar.h"

#import "SimpleLocationHelperForBaiduLBS.h"

#import "IntentFilter.h"












static const NSString *const TAG = @"<MainNavigationActivity>";
















@interface MainNavigationActivity () <UITabBarDelegate>

//
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
// tabhost 的 content区域
@property (retain, nonatomic) IBOutlet UIView *tabContent;
// tabhost 的 tabbar区域
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;

// "推荐"
@property (nonatomic, retain) RecommendCitiesActivity *recommendCityActivity;
// "搜索"
@property (nonatomic, retain) SearchActivity *searchActivity;
// "附近"
@property (nonatomic, retain) RoomListActivity *nearbyActivity;
// "账号"
@property (nonatomic, retain) AccountActivity *accountActivity;

// 独立控件
@property (nonatomic, copy) NSString *titleForNearbyActivity;
@property (nonatomic, assign) TitleBar *titleBar;

// 当前处于显示状态的Activity
@property (nonatomic, assign) Activity *activeActivity;
@end













@implementation MainNavigationActivity

// 这里的 tag 一定要跟IB中的 Tab Bar Item 中的tag 一样.
typedef NS_ENUM(NSInteger, TabBarTagEnum) {
  kTabBarTagEnum_Recommend = 0, // "推荐"
  kTabBarTagEnum_Search    = 1, // "搜索"
  kTabBarTagEnum_Nearby    = 2, // "附近"
  kTabBarTagEnum_Account   = 3  // "账户"
};

#pragma mark -
#pragma mark 内部方法群
- (void)dealloc {
  
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  // 一定要注销广播消息接收器
  [self unregisterReceiver];
  
  //
  _activeActivity = nil;
  
  //
  [_recommendCityActivity release];
  [_searchActivity release];
  [_nearbyActivity release];
  [_accountActivity release];
  
  //
  [_titleForNearbyActivity release];
  
  // UI
  [_titleBarPlaceholder release];
  [_tabContent release];
  [_tabBar release];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    self.titleForNearbyActivity = @"附近";
  }
  return self;
}

- (void)viewDidLoad
{
  PRPLog(@"%@ --> viewDidLoad ", TAG);
  
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self initTitleBar];
  [self initTabHost];
  
}

- (void)viewDidUnload
{
  PRPLog(@"%@ --> viewDidUnload ", TAG);
  
  [self setTabBar:nil];
  [self setTabContent:nil];
  
  [self setRecommendCityActivity:nil];
  [self setSearchActivity:nil];
  [self setNearbyActivity:nil];
  [self setAccountActivity:nil];
  
  [self setTitleBar:nil];
  [self setTitleBarPlaceholder:nil];
  
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
  
  // 接收 : 用户登录成功
  // 接收 : 获取用户地址成功
  // 接收 : 跳转到 "推荐首页"
  [self registerBroadcastReceiver];
}
-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  if (_activeActivity != nil) {
    [_activeActivity onPause];
  }
}
-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
  if (_activeActivity != nil) {
    [_activeActivity onResume];
  } else {
    // 如果 _activeActivity 为 nil的话, 证明是第一次进入此界面
    // 设置第一个被选中的 item
    NSArray *items = self.tabBar.items;
    self.tabBar.selectedItem = items[kTabBarTagEnum_Recommend];
    [self tabBar:items[kTabBarTagEnum_Recommend] didSelectItem:self.tabBar.selectedItem];
  }
}

#pragma mark -
#pragma mark 覆写父类 Activity 的方法
- (void) onActivityResult:(int) requestCode
               resultCode:(int) resultCode
                     data:(Intent *) data {
  [_activeActivity onActivityResult:requestCode resultCode:resultCode data:data];
}

#pragma mark -
#pragma mark 初始化 UI
//
- (void) initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [self.titleBarPlaceholder addSubview:titleBar];
  
  // 要缓存 TitleBar 对象
  self.titleBar = titleBar;
}

- (void) updateTitleBarUIByTabItemTag:(TabBarTagEnum) tag {
  switch (tag) {
    case kTabBarTagEnum_Recommend:{// "推荐"
      [_titleBar hideLeftButton:YES];
      [_titleBar hideRightButton:NO];
      [_titleBar setTitleByImageName:@"logo_for_titlebar.png"];
    }break;
      
    case kTabBarTagEnum_Search:{// "搜索"
      
      [_titleBar hideLeftButton:YES];
      [_titleBar hideRightButton:NO];
      [_titleBar setTitleByString:@"搜索"];
      
    }break;
      
    case kTabBarTagEnum_Nearby:{// "附近"
      
      [_titleBar hideLeftButton:NO];
      [_titleBar hideRightButton:YES];
      [_titleBar setTitleByString:_titleForNearbyActivity];
      
    }break;
      
    case kTabBarTagEnum_Account:{// "账号"
      
      [_titleBar hideLeftButton:YES];
      [_titleBar hideRightButton:YES];
      [_titleBar setTitleByString:@"账号"];
      
    }break;
      
    default:
      break;
  }
}

- (void) initTabHost {
  // "推荐"
  self.recommendCityActivity = [[RecommendCitiesActivity alloc] init];
  // "搜索"
  self.searchActivity = [[SearchActivity alloc] init];
  // "附近"
  self.nearbyActivity = [[RoomListActivity alloc] init];
  Intent *intent = [Intent intent];
  [intent.extras setObject:[NSNumber numberWithBool:YES]
                    forKey:kIntentExtraTagForRoomListActivity_IsNearby];
  [_nearbyActivity setIntent:intent];
  [_nearbyActivity onCreate:intent];
  // "账号"
  self.accountActivity = [[AccountActivity alloc] init];
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  switch (action) {
      
    case kTitleBarActionEnum_LeftButtonClicked:{// 返回 "推荐" 页面
      NSArray *items = self.tabBar.items;
      self.tabBar.selectedItem = items[kTabBarTagEnum_Recommend];
      [self tabBar:items[kTabBarTagEnum_Recommend] didSelectItem:self.tabBar.selectedItem];
    }break;
      
    case kTitleBarActionEnum_RightButtonClicked:{// "拨打订购热线"
      [[SimpleCallSingleton sharedInstance] callCustomerServicePhoneAndShowInThisView:self.view.window];
    }break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark 实现 UITabBarDelegate 接口

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  NSInteger tabBarItemTag = [item tag];
  
  [self.tabBar setHidden:NO];
  [self updateTitleBarUIByTabItemTag:tabBarItemTag];
  
  BOOL isNeedChangeTabContent = NO;
  Activity *newTargetTabContent = nil;
  UIView *oldTabContentView = [[_tabContent subviews] lastObject];
  switch (tabBarItemTag) {
      
    case kTabBarTagEnum_Recommend:{// "推荐"
      
      if (oldTabContentView != _recommendCityActivity.view) {
        isNeedChangeTabContent = YES;
        newTargetTabContent = _recommendCityActivity;
      }
      
    }break;
      
    case kTabBarTagEnum_Search:{// "搜索"
      
      if (oldTabContentView != _searchActivity.view) {
        isNeedChangeTabContent = YES;
        newTargetTabContent = _searchActivity;
      }
    }break;
      
    case kTabBarTagEnum_Nearby:{// "附近"
      
      if (oldTabContentView != _nearbyActivity.view) {
        
        [self.tabBar setHidden:YES];
        
        isNeedChangeTabContent = YES;
        newTargetTabContent = _nearbyActivity;
      }
    }break;
      
    case kTabBarTagEnum_Account:{// "账号"
      
      if (oldTabContentView != [[self accountActivity] view]) {
        isNeedChangeTabContent = YES;
        newTargetTabContent = _accountActivity;
      }
    }break;
      
    default:{
      
    }break;
  }
  
  if (isNeedChangeTabContent) {
    
    Activity *lastActivity = _activeActivity;
    [lastActivity onPause];
    [oldTabContentView removeFromSuperview];
    
    // 更换 tabContent
    _activeActivity = newTargetTabContent;
    [_tabContent addSubview:newTargetTabContent.view];
    [_activeActivity onResume];
    
  }
}

//
-(void)registerBroadcastReceiver {
  
  IntentFilter *intentFilter = [IntentFilter intentFilter];
  // 向通知中心注册通知 : "返回 推荐界面"
  [intentFilter.actions addObject:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_GotoRecommendActivity] stringValue]];
  // 向通知中心注册通知 : "返回 搜索界面"
  [intentFilter.actions addObject:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_GotoSearchActivity] stringValue]];
  // 向通知中心注册通知 : "用户登录成功"
  [intentFilter.actions addObject:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_UserLogonSuccess] stringValue]];
  // 向通知中心注册通知 : 获取用户当前地址 "成功"
  [intentFilter.actions addObject:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_GetUserAddressSuccess] stringValue]];
  
  [self registerReceiver:intentFilter];
}

#pragma mark -
#pragma mark 实现 BroadcastReceiverDelegate 代理
-(void)onReceive:(Intent *)intent {
  NSInteger userNotificationEnum = [[intent action] integerValue];
  switch (userNotificationEnum) {
    case kUserNotificationEnum_GotoRecommendActivity:{
      //
      NSArray *items = self.tabBar.items;
      self.tabBar.selectedItem = items[kTabBarTagEnum_Recommend];
      [self tabBar:items[kTabBarTagEnum_Recommend] didSelectItem:self.tabBar.selectedItem];
    }break;
      
    case kUserNotificationEnum_GotoSearchActivity:{
      //
      NSArray *items = self.tabBar.items;
      self.tabBar.selectedItem = items[kTabBarTagEnum_Search];
      [self tabBar:items[kTabBarTagEnum_Recommend] didSelectItem:self.tabBar.selectedItem];
    }break;
      
    case kUserNotificationEnum_UserLogonSuccess:{
      //
      NSArray *items = self.tabBar.items;
      self.tabBar.selectedItem = items[kTabBarTagEnum_Recommend];
      [self tabBar:items[kTabBarTagEnum_Recommend] didSelectItem:self.tabBar.selectedItem];
    }break;
      
    case kUserNotificationEnum_GetUserAddressSuccess:{
      if ([SimpleLocationHelperForBaiduLBS getLastMKAddrInfo] != nil) {
        NSString *district = [SimpleLocationHelperForBaiduLBS getLastMKAddrInfo].addressComponent.district;
        NSString *streetName = [SimpleLocationHelperForBaiduLBS getLastMKAddrInfo].addressComponent.streetName;
        self.titleForNearbyActivity = [NSString stringWithFormat:@"%@%@", district, streetName];
        
        if (_activeActivity == _nearbyActivity) {
          [_titleBar setTitleByString:self.titleForNearbyActivity];
        }
      }
    }break;
      
    default:{
      
    }break;
  }
}

@end
