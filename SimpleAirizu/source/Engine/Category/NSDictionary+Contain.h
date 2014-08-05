//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>

// 判断字典中是否有某个key或者某个value
@interface NSDictionary (Contain)

- (BOOL)containsKey:(id)key;
- (BOOL)containsValue:(id)value;
@end
