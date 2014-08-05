
#import "PreloadingUIToolBar.h"



@interface PreloadingUIToolBar ()

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (nonatomic, readwrite, assign) BOOL isVisible;
@end



@implementation PreloadingUIToolBar

- (IBAction)refreshButtonOnClickListener:(UIButton *)sender {
  if (_refreshButtonOnClickHandlerBlock != NULL) {
    _refreshButtonOnClickHandlerBlock(sender);
  }
}

+ (PreloadingUIToolBar *)preloadingUIToolBar {
  PreloadingUIToolBar *preloadingUIToolBar = [super viewFromNib:super.nib];
  preloadingUIToolBar.isVisible = YES;
  return preloadingUIToolBar;
}

// 设置提示信息
- (void)setHintInfo:(NSString *)hintInfo {
  self.hintLabel.text = hintInfo;
}

// 显示 "刷新按钮", 如果不显示 "刷新按钮" 就显示 "提示信息 --> 页面加载中..."
- (void)showRefreshButton:(BOOL)isShow {
  if (isShow) {
    _hintLabel.hidden = YES;
    _refreshButton.hidden = NO;
  } else {
    _hintLabel.hidden = NO;
    _refreshButton.hidden = YES;
  }
}

- (void)showInView:(UIView*)superView {
  if (![superView isKindOfClass:[UIView class]]) {
    return;
  }
  
  // 校正 "预加载UI工具条" 的坐标, 要居中显示
  CGFloat newY = (CGRectGetHeight(superView.frame) - CGRectGetHeight(self.frame)) / 2;
  self.frame = CGRectMake(self.frame.origin.x, newY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
  
  [superView addSubview:self];
  
  _isVisible = NO;
}

- (void)dismiss {
  [self removeFromSuperview];
  _isVisible = YES;
}

@end
