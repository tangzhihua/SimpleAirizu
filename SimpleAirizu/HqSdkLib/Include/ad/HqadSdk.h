//
//

#import <Foundation/Foundation.h>
#import "HqadStatusDelegate.h"

@interface HqadSdk : NSObject {
    
}

+(void)setUrl:(NSString*)url;

+(id<HqadStatusDelegate>)getHqadFullScreenAdStatusDelegate;
+(void)setHqadFullScrrenAdStatusDelegate:(id<HqadStatusDelegate>)delegate;
//
//
+(void)initSdkConfig:(NSString*)pid;
//
//
+(void)releaseSdkConfig;
//
//
+(void)setNeedFullScreenStartView:(BOOL)isneed;
//
//
+(BOOL)isNeedFullScreenStartView;
//
//
+(void)setNeedInsertView:(BOOL)isneed;
//
//
+(BOOL)isneedInsertView;
//
//
+(void)setNeedLocation:(BOOL)isneed;
//
//
+(BOOL)isNeedLocation;
//
//
+(void)updateLocationWithLatitudeAndLongitude:(double)latitude longitude:(double)longitude;
//
//
+(void)setRootViewController:(id)root;
//
//
+(id)getRootViewController;
//
//
+(void)setClickViewFullScreen:(BOOL)isCan;
//
//
+(BOOL)canClickViewFullScreen;

//will read full screen start ad config,and load it
//if suceess,return a HqadFullScreenStartView object,and add it to rootView 's subviews
//if fail,return nil]
//
//
+(UIView*)newAndShowHqad:(NSString*)pid FullScreenStartViewInView:(UIView *)rootView adIdentify:(NSString*)adIdentify delegate:(id<HqadStatusDelegate>)adstatus;

//will read insert ad,and load it
//if suceess,return a HqadFullScreenStartView object,and add it to rootView 's subviews
//if fail,return nil]
//
+ (UIView*)newAndShowHqad:(NSString*)pid InsertViewInView:(UIView*)view adIdentify:(NSString*)adIdentify delegate:(id<HqadStatusDelegate>)adstatus;

@end
