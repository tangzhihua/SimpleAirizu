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

// 账号
@property (weak, nonatomic) IBOutlet UITextField *loginNameText;
// 密码
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
// 自动登录
@property (nonatomic, assign) BOOL autoLoginFlag;


@end

@implementation LogInViewController

#pragma mark - 
#pragma mark - 方便构造
+ (id)logInViewController {
  LogInViewController *loginViewContrller = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
  // 默认是自动登录的
  if ((loginViewContrller.autoLoginFlag != YES) && (loginViewContrller.autoLoginFlag != NO)) {
    loginViewContrller.autoLoginFlag = YES;
  }
  return loginViewContrller;
}

#pragma mark - 
#pragma mark - 生命周期

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
#pragma mark - Action 方法群

// 单击  自动登录按钮  事件监听
- (IBAction)autoLoginButtonOnClickLintener:(UIButton *)sender {
}

// 单击  登录按钮  事件监听
- (IBAction)loginButtonOnClickLintener:(UIButton *)sender {
}

// 单击  快速注册按钮  事件监听
- (IBAction)quickRegisterButtonOnClickLinstener:(UIButton *)sender {
}

// 单击  返回按钮  事件监听
- (IBAction)backButtonOnClickLintener:(UIButton *)sender {
}

// 单击  忘记密码按钮  事件监听
- (IBAction)forgetPassWordButtonOnClickLintener:(UIButton *)sender {
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
