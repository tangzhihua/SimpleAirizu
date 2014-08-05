//
//  UIPopoverController+Tag.m
//  ModelLib
//
//  Created by 王珊珊 on 14-6-4.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import "UIPopoverController+Tag.h"
#import <objc/runtime.h>

// 关联引用有两点需要知道:
// 1.虽然不能在分类中创建实例变量, 但是可以创建关联引用. 通过关联引用, 你可以想任何对象中添加键-值(key-value)数据.(可以给任意一个对象添加键值数据)
// 2.关联引用(或是其他一些通过分类添加数据的方法)有个限制, 即无法使用 encodeWithCoder:方法, 所以通过分类进行序列化是非常困难的.

@implementation UIPopoverController (Tag)
@dynamic tag;

// 可以看出, 关联引用是基于键(key)的内存地址的, 而不是键的值. 在 tagKey 中存储的内容并不重要, 但是它需要一个唯一地址,
// 所以通常使用一个未赋值的 static char 作为键.
static char tagKey;
- (NSInteger)tag {
  NSNumber *tagNumber = objc_getAssociatedObject(self, &tagKey);
  return tagNumber.integerValue;
}

- (void)setTag:(NSInteger)tag {
  NSNumber *tagNumber = [NSNumber numberWithInteger:tag];
  objc_setAssociatedObject(self, &tagKey, tagNumber, OBJC_ASSOCIATION_COPY);
}
@end
