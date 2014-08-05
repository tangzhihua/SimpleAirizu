//
//  ViewFromNib.h
//  ModelLib
//
//  Created by zhihuatang on 14-6-15.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewFromNib : UIView
// 获取 nib 文件中View frame rect, 就是使用nib自定义的控件的原始frame rect
+ (CGRect)nibViewBounds;
//
+ (UINib *)nib;
//
+ (NSString *)nibName;
//
+ (id)viewFromNib:(UINib *)nib;

- (id)initWithFrame:(CGRect)frame DEPRECATED_ATTRIBUTE;
@end
