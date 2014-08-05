//
//  UIPopoverController+Tag.h
//  ModelLib
//
//  Created by 王珊珊 on 14-6-4.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import <UIKit/UIKit.h>

// 使用 "关联引用" 技术, 给一个类别增加一个属性(带数据)
@interface UIPopoverController (Tag)
@property (nonatomic, assign) NSInteger tag;
@end
