//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "HqadStatusDelegate.h"
@class HqadManager;

#define AD_SIZE_320x48     CGSizeMake(320,48)
#define AD_SIZE_320x270    CGSizeMake(320,270)
#define AD_SIZE_488x80     CGSizeMake(488,80)
#define AD_SIZE_768x116    CGSizeMake(768,116)

typedef enum AD_OPEN_TYPE{
	
	ADOpenInSafari = 1,
	ADOpenInViewController    //requeir rootViewController
	
}AdOpenType;

@interface HqadBannerView : UIView{
	
}

//
//
@property (nonatomic,retain) NSString * adIdentify;
//
//
@property (nonatomic,assign) id <HqadStatusDelegate> adstatus;
//
//
@property (nonatomic,assign) id rootViewController_;
//
//
@property (nonatomic) BOOL isClose;
//
//
@property (nonatomic,assign) HqadManager * manager;

//
//
+ (HqadBannerView*)newHqadBannerViewWithPointAndSize:(CGPoint)point size:(CGSize)size adIdentify:(NSString*)adIdentify delegate:(id<HqadStatusDelegate>)adstatus;

-(void)receiveAd:(id)ad;
-(BOOL)canReceiveAd;

@end
