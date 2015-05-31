//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HqOfferCallback <NSObject>

-(void)onOfferGet:(NSUInteger)offerNum;

@end

@interface HqOfferSdk : NSObject

//rate 1点基础价格兑换多少积分
+(BOOL)showOfferWallByRootViewController:(UIViewController*)rootViewController rate:(NSUInteger)rate delegate:(id<HqOfferCallback>)callback;

+(void)setPublisherId:(NSString*)pid;

+(NSString*)getPublisherId;

+(NSString*)getHqOfferSdkVersion;

@end
