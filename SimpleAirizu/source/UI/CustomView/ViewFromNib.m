//
//  ViewFromNib.m
//  ModelLib
//
//  Created by zhihuatang on 14-6-15.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import "ViewFromNib.h"

@implementation ViewFromNib

- (id)initWithFrame:(CGRect)frame {
  RNAssert(NO, @"请使用方便构造 bookCatalogueView 来创建对象.");
  return nil;
}

+ (UINib *)nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  UINib *nibObject =  [UINib nibWithNibName:self.nibName bundle:classBundle];
  RNAssert(nibObject != nil, @"创建 nibObject 失败! 错误的nibName=%@", [self nibName]);
  return nibObject;
}

+ (NSString *)nibName {
  NSString *nibName = nil;
  nibName = NSStringFromClass([self class]);
  return nibName;
}

+ (id)viewFromNib:(UINib *)nib {
  do {
    if (![nib isKindOfClass:[UINib class]]) {
      RNAssert(NO, @"入参 nib 类型不为 UINib");
      break;
    }
    
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    if (([nibObjects count] <= 0) || ![[nibObjects objectAtIndex:0] isKindOfClass:[self class]]) {
      NSAssert2(NO,
                @"Nib '%@' does not appear to contain a valid %@",
                self.nibName,
                NSStringFromClass([self class]));
      break;
    }
    
    UIView *view = [nibObjects objectAtIndex:0];
    return view;

  } while (NO);
	
  return nil;
}

+ (CGRect)nibViewBounds {
  return ((UIView *)[self viewFromNib:self.nib]).bounds;
}

@end
