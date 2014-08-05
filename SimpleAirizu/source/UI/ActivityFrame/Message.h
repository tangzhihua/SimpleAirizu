//
//  Message.h
//  airizu
//
//  Created by 唐志华 on 12-12-26.
//
//

#import <Foundation/Foundation.h>

@interface Message : NSObject {
  
}

@property (nonatomic, assign) int what;
@property (nonatomic, retain) NSMutableDictionary *data;

+ (Message *) obtain;
@end
