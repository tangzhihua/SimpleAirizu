//
//

#import <Foundation/Foundation.h>
@class HqadBannerView;

@interface HqadManager : NSObject {
    
}

//
//
@property (nonatomic) int timeInterval;

//
//
-(void)setPublisherid:(NSString*)pid;
//
//
-(void)start;
//
//
-(void)stop;

//
//
-(BOOL)addHqadBannerView:(HqadBannerView*)adBannerView;
//
//
-(BOOL)removeHqadBannerView:(HqadBannerView*)adBannerView;

@end
