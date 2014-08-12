
#import "BeginnerGuideActivity.h"
//#import "MainNavigationActivity.h"

#import "LogInViewController.h"





static const NSString *const TAG = @"<BeginnerGuideActivity>";



@interface BeginnerGuideActivity ()
@property (weak, nonatomic) IBOutlet UIView *bodyLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@end









@implementation BeginnerGuideActivity

- (void)viewDidLoad {
  PRPLog(@"%@ --> viewDidLoad ", TAG);
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self initImageGallery];
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

- (void)onDestroy {
  PRPLog(@"%@ --> onDestroy ", TAG);
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
}
-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
}

- (void)initImageGallery {
  
  NSArray *imageNameArray = [NSArray arrayWithObjects:@"beginner_guide_1.jpg", @"beginner_guide_2.jpg", @"beginner_guide_3.jpg", @"beginner_guide_4.jpg", @"beginner_guide_5.jpg",  nil];
  
  // 设置 图片画廊
  CGRect scrollViewOriginalFrame = _imageScrollView.frame;
  
  _imageScrollView.contentSize = CGSizeMake(scrollViewOriginalFrame.size.width * imageNameArray.count, scrollViewOriginalFrame.size.height);
  
  CGSize imageSize = CGSizeMake(scrollViewOriginalFrame.size.width, scrollViewOriginalFrame.size.height);
  
  [imageNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    UIImageView *roomPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * scrollViewOriginalFrame.size.width, 0, imageSize.width, imageSize.height)];
    //
    [roomPhotoImageView setUserInteractionEnabled:YES];
    //
    [roomPhotoImageView setImage:[UIImage imageNamed:obj]];
    [roomPhotoImageView setContentMode:UIViewContentModeScaleToFill];
    [_imageScrollView addSubview:roomPhotoImageView];
    
  }];
  
  
  // "开始体验" 按钮
  UIButton *beganToExperienceButton = [UIButton buttonWithType:UIButtonTypeCustom];
  CGFloat xOffset = (_imageScrollView.contentSize.width - scrollViewOriginalFrame.size.width) + (scrollViewOriginalFrame.size.width - 170)/2;
  CGFloat yOffset = [UIScreen mainScreen].bounds.size.height - 80;
  beganToExperienceButton.frame = CGRectMake(xOffset, yOffset, 170, 31);
  [beganToExperienceButton setBackgroundImage:[UIImage imageNamed:@"beginner_guide_button.png"] forState:UIControlStateNormal];
  
  [beganToExperienceButton addTarget:self action:@selector(beganToExperienceButtonOnClickListener:) forControlEvents:UIControlEventTouchUpInside];
  [_imageScrollView addSubview:beganToExperienceButton];
  
}

// 点击按钮事件
- (void)beganToExperienceButtonOnClickListener:(UIButton *)sender {
  
#if 0
  // 下次启动时不再显示 "新手帮助"
  [GlobalDataCacheForMemorySingleton sharedInstance].isNeedShowBeginnerGuide = NO;
  
  // 关闭自身, 并且启动 MainNavigationActivity
  Intent *intent = [Intent intentWithSpecificComponentClass:[MainNavigationActivity class]];
  [self finishSelfAndStartNewActivity:intent];
  
#else
  
//  [self finish];
  
  LogInViewController *loginViewController = [LogInViewController logInViewController];
  [self presentViewController:loginViewController animated:YES completion:NULL];
#endif
}

@end
