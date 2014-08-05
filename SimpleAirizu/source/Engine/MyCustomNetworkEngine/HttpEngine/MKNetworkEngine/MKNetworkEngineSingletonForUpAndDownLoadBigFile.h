//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>

@class MKNetworkEngine;
@interface MKNetworkEngineSingletonForUpAndDownLoadBigFile : NSObject
+ (MKNetworkEngine *) sharedInstance;
@end
