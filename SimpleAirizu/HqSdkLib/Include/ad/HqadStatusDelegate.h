//
//

#import <Foundation/Foundation.h>


@protocol HqadStatusDelegate <NSObject>

//
//
-(void)didHqadReceiveAdFail:(NSString*)adIdentify;
//
//
-(void)didHqadReceiveAdSuccess:(NSString*)adIdentify;
//
//
-(void)didHqadRefreshAd:(NSString*)adIdentify;
//
//
-(void)didHqadClick:(NSString*)adIdentify;
//
//
-(void)willHqadViewClosed:(NSString*)adIdentify;
//
//
-(void)willHqadFullScreenShow:(NSString*)adIdentify;
//
//
-(void)didHqadFullScreenShow:(NSString*)adIdentify;
//
//
-(void)willHqadFullScreenClose:(NSString*)adIdentify;
//
//
-(void)didHqadFullScreenClose:(NSString*)adIdentify;

@end
