//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "NetRespondDataToNSDictionaryForDreamBook.h"


@implementation NetRespondDataToNSDictionaryForDreamBook
- (NSDictionary *) netRespondDataToNSDictionary:(in NSString *)serverRespondDataOfUTF8String {
  do {
    if ([NSString isEmpty:serverRespondDataOfUTF8String]) {
      PRPLog(@"入参 serverRespondDataOfUTF8String 为空 !");
      break;
    }
    
    NSError *error = nil;
    NSDictionary *xmlRootNSDictionary = nil;
    
    if (![xmlRootNSDictionary isKindOfClass:[NSDictionary class]]) {
      PRPLog(@"xml 解析失败!-->serverRespondDataOfUTF8String = %@ ", serverRespondDataOfUTF8String);
      break;
    }
    
		return xmlRootNSDictionary;
	} while (NO);
  
  return nil;
}
@end
