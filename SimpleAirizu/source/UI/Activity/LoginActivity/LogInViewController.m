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
#import "NSString+isEmpty.h"

@interface LogInViewController ()
// 登录 网络请求


@property (nonatomic, strong) id<INetRequestHandle> netRequestHandleForLogin;

// 账号
@property (weak, nonatomic) IBOutlet UITextField *loginNameText;
// 密码
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
// 等待登录时的菊花
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginWait;
// 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

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
  _autoLoginFlag = !_autoLoginFlag;
}

// 单击  登录按钮  事件监听
- (IBAction)loginButtonOnClickLintener:(UIButton *)sender {
  
  // 判断输入的账户和密码是否合法
  if (![self isEmptyForLogInName:_loginNameText.text passWord:_passWordText.text]) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"账户/密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
  }
  [self requestLoginWithLoginName:_loginNameText.text password:_passWordText.text];
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
    // 访问网络前处理UI
    weakSelf.loginButton.enabled = NO;
    weakSelf.loginWait.hidden = NO;
  } successedBlock:^(LoginNetRespondBean *loginNetRespondBean) {
    // 登录成功后回到账号界面
    NSLog(@"登录成功！");
  } failedBlock:^(MyNetRequestErrorBean *error) {
    [[[UIAlertView alloc]initWithTitle:@"登录失败"
                               message:error.localizedDescription
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil] show];
  } endBlock:^(){
    weakSelf.loginButton.enabled = YES;
    weakSelf.loginWait.hidden = YES;
  }];
}

#pragma mark -
#pragma mark - 相关方法群

// 判断用户名密码不能为空
- (BOOL)isEmptyForLogInName:(NSString *)loginName passWord:(NSString *)passWord {
  if ([NSString isEmpty:loginName] || [NSString isEmpty:passWord]) {
    return NO;
  }
  return YES;
}

@end
