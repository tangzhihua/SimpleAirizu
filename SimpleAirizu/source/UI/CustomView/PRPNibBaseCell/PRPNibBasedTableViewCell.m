/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
 ***/
#import "PRPNibBasedTableViewCell.h"

@interface PRPNibBasedTableViewCell ()
@property (nonatomic, strong, readwrite) id data;
@end

@implementation PRPNibBasedTableViewCell

#pragma mark -
#pragma mark - Cell generation

+ (NSString *)cellIdentifier {
  return NSStringFromClass([self class]);
}

+ (id)cellFromNib:(UINib *)nib tableView:(UITableView *)tableView {
  [tableView registerNib:nib forCellReuseIdentifier:self.cellIdentifier];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
  return cell;
}

+ (id)cellFromNib:(UINib *)nib {
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

+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
#if 0
  NSString *cellID = [self cellIdentifier];
  
  // 为了灵活操作是否使用 dequeueReusableCellWithIdentifier 缓存, 我们将 Identifier 的设置放到 .xib文件中,
  // 这样就可以通过给 xib 是否设置Identifier 来决定是否使用 dequeueReusableCellWithIdentifier 缓存cell了.
  // 在 xib 文件中的 Show the Attributes inspector 属性页面中 设置 Identifier 属性
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [self cellFromNib:nib];
  } else {
    // 缓存中已经存在cell了, 就不需要调用 cellFromNib 方法, 创建一个新的cell对象了.
  }
  
  return cell;
#else
  UITableViewCell *cell = [self cellFromNib:nib tableView:tableView];
  return cell;
#endif
}

#pragma mark -
#pragma mark - Nib support

+ (UINib *)nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  UINib *nibObject =  [UINib nibWithNibName:[self nibName] bundle:classBundle];
  RNAssert(nibObject != nil, @"创建 nibObject 失败! 错误的nibName=%@", [self nibName]);
  return nibObject;
}

+ (NSString *)nibName {
  return [self cellIdentifier];
}

+ (CGRect)nibViewBounds {
  return ((UIView *)[self cellFromNib:self.nib]).bounds;
}

#pragma mark -
#pragma mark - 数据绑定
- (void)bind:(id)data {
  // 先解绑数据, 然后再绑定新的数据, 顺序决不能错乱
  [self unBind];
  
  // 绑定新的数据, 这里一定要使用深拷贝, 钱拷贝不安全.
  self.data = [data deepCopy];
}
- (void)unBind {
  self.data = nil;
}
@end