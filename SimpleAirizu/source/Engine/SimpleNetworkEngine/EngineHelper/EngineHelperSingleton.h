//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>
#import "IEngineHelper.h"

@interface EngineHelperSingleton : NSObject <IEngineHelper>

+ (id<IEngineHelper>) sharedInstance;

@end
