//
//  UIAlertView+Blocks.h
//  UIKitCategoryAdditions
//

#import <Foundation/Foundation.h>

typedef void (^UIAlertViewDismissBlock)(UIAlertView *alertView, int buttonIndex);
typedef void (^UIAlertViewCancelBlock)();


// 这里为了演示 过程式编程 和 函数式编程
// 函数式编程中, 代码读起来更像人类语言.
// 之前UIAlertView的使用方式, delegate 和 tag 结合使用的方式是 过程式编程.
@interface UIAlertView (Blocks) <UIAlertViewDelegate>

+ (UIAlertView *)showAlertViewWithTitle:(NSString *) title
                                message:(NSString *) message
                      cancelButtonTitle:(NSString *) cancelButtonTitle
                      otherButtonTitles:(NSArray *) otherButtons
                         alertViewStyle:(UIAlertViewStyle) alertViewStyle
                              onDismiss:(UIAlertViewDismissBlock) dismissed
                               onCancel:(UIAlertViewCancelBlock) cancelled;

@end
