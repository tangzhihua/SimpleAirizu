

#import "TitleBar.h"

static const NSString *const TAG = @"<TitleBar>";

@interface TitleBar ()
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TitleBar

- (IBAction)leftButtonOnClickListener:(UIButton *)sender {
  if (_leftButtonClickHandlerBlock != NULL) {
    _leftButtonClickHandlerBlock(sender);
  }
}

- (IBAction)rightButtonOnClickListener:(UIButton *)sender {
  if (_rightButtonClickHandlerBlock != NULL) {
    _rightButtonClickHandlerBlock(sender);
  }
}


+ (TitleBar *)titleBarWithFrame:(CGRect)frame {
  
  TitleBar *titleBar = [super viewFromNib:super.nib];
  titleBar.frame = frame;
  titleBar.leftButton.hidden = YES;
  titleBar.rightButton.hidden = YES;
  titleBar.logoImage.hidden = YES;
  titleBar.titleLabel.hidden = YES;
  
  return titleBar;
}

- (void)setLeftButtonByImageName:(NSString *)imageName forState:(UIControlState)state {
  _leftButton.hidden = NO;
  [_leftButton setImage:[UIImage imageNamed:imageName] forState:state];
}

- (void)setRightButtonByImageName:(NSString *)imageName forState:(UIControlState)state {
  _rightButton.hidden = NO;
  [_rightButton setImage:[UIImage imageNamed:imageName] forState:state];
}

- (void)setTitleByString:(NSString *)titleNameString {
  _titleLabel.hidden = NO;
  _logoImage.hidden = YES;
  [_titleLabel setText:titleNameString];
}

- (void)setTitleByImageName:(NSString *)imageName {
  _titleLabel.hidden = YES;
  _logoImage.hidden = NO;
}

- (void)hideLeftButton:(BOOL)hide{
  _leftButton.hidden = hide;
}

- (void)hideRightButton:(BOOL)hide{
  _rightButton.hidden = hide;
}

@end
