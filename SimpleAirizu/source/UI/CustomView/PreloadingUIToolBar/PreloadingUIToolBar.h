
#import "ViewFromNib.h"

// PreloadingUIToolBar 中的刷新按钮的单击监听块
typedef void (^PreloadingUIToolBarRefreshButtonOnClickHandlerBlock)(UIButton *button);

@interface PreloadingUIToolBar : ViewFromNib

//
@property (nonatomic, readonly, assign) BOOL isVisible;

// 设置刷新按钮的单击监听块
@property (nonatomic, copy) PreloadingUIToolBarRefreshButtonOnClickHandlerBlock refreshButtonOnClickHandlerBlock;

// 设置提示信息
- (void)setHintInfo:(NSString *)hintInfo;
// 显示 "刷新按钮", 如果不显示 刷新按钮, 就会显示 提示标签, 这两个是互斥的.
- (void)showRefreshButton:(BOOL)isShow;

//
- (void)showInView:(UIView*)superView;
- (void)dismiss;

#pragma mark -
#pragma mark - 方便构造
+ (PreloadingUIToolBar *)preloadingUIToolBar;

@end
