//
//  LogInViewController.m
//  SimpleAirizu
//
//  Created by 王珊珊 on 14-8-7.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import "LogInViewController.h"

#import "LoginNetRequestBean.h"
#import "LoginNetRespondBean.h"

@interface LogInViewController ()
// 登录 网络请求
@property (nonatomic, strong) id<INetRequestHandle> netRequestHandleForLogin;
@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - 网络相关方法群
- (void)requestLoginWithLoginName:(NSString *)loginName password:(NSString*)password {
  
  LoginNetRequestBean *netRequestBean = [[LoginNetRequestBean alloc] initWithLoginName:loginName password:password];
  __weak LogInViewController *weakSelf = self;
  _netRequestHandleForLogin = [[SimpleNetworkEngineSingleton sharedInstance] requestDomainBeanWithRequestDomainBean:netRequestBean beginBlock:^(){
    
  } successedBlock:^(LoginNetRespondBean *loginNetRespondBean) {
    // 登录成功
    
  } failedBlock:^(MyNetRequestErrorBean *error) {
    
    [[[UIAlertView alloc]initWithTitle:@"登录失败"
                               message:error.localizedDescription
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil] show];
    
    
  } endBlock:^(){
    
  }];
  
  
}
@end
