 

#import "ViewFromNib.h"

// title bar 中的按钮的单击监听块
typedef void (^TitleBarButtonOnClickHandlerBlock)(UIButton *button);

@interface TitleBar : ViewFromNib

@property (nonatomic, copy) TitleBarButtonOnClickHandlerBlock leftButtonClickHandlerBlock;
@property (nonatomic, copy) TitleBarButtonOnClickHandlerBlock rightButtonClickHandlerBlock;

+ (TitleBar *)titleBarWithFrame:(CGRect)frame;

- (void)setLeftButtonByImageName:(NSString *)imageName forState:(UIControlState)state;
- (void)setRightButtonByImageName:(NSString *)imageName forState:(UIControlState)state;
- (void)setTitleByString:(NSString *)titleNameString;
- (void)setTitleByImageName:(NSString *)imageName;

- (void)hideLeftButton:(BOOL)hide;
- (void)hideRightButton:(BOOL)hide;

@end
