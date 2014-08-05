//
//  RESTError.m
//  iHotelApp
//
//  Created by Mugunth Kumar on 1-Jan-11.
//  Copyright 2010 Steinlogic. All rights reserved.
//

#import "MyNetRequestErrorBean.h"



@implementation MyNetRequestErrorBean

// 外部定义的错误码对应的错误信息字典
static NSDictionary *nErrorCodesDictionary = nil;

#define kHttpRequestErrorDomain @"HTTP_ERROR"
#define kCustomErrorDomain      @"CUSTOM_ERROR"

+ (void)initialize {
  // 这是为了子类化当前类后, 父类的initialize方法会被调用2次
  if (self == [MyNetRequestErrorBean class]) {
    NSString *fileName = [NSString stringWithFormat:@"Errors_%@", [[NSLocale currentLocale] localeIdentifier]];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    if(filePath != nil) {
      nErrorCodesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    } else {
      // fall back to english for unsupported languages
      NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Errors_en_US" ofType:@"plist"];
      nErrorCodesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }
  }
}

+ (void)dealloc {
  // 这是为了子类化当前类后, 父类的initialize方法会被调用2次
  if (self == [MyNetRequestErrorBean class]) {
    [super dealloc];
  }
}


- (id)init {
  if ((self = [super init])) {
		_errorMessage = @"OK";
    _errorCode = 200;
		return self;
	}
  
  return self;
}

/**
 * 重新初始化
 *
 * @param srcObject
 */
- (void)reinitialize:(MyNetRequestErrorBean *)srcObject {
  if (srcObject != nil) {
    _errorCode = srcObject.errorCode;
    _errorMessage = srcObject.errorMessage;
  } else {
    _errorCode = 200;
    _errorMessage = @"OK";
  }
}

+ (id)netRequestErrorBeanWithErrorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage {
  MyNetRequestErrorBean *netRequestErrorBean = [[MyNetRequestErrorBean alloc] init];
  netRequestErrorBean.errorCode = errorCode;
  netRequestErrorBean.errorMessage = errorMessage;
  return netRequestErrorBean;
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:_errorMessage forKey:@"errorMessage"];
  [encoder encodeInteger:_errorCode forKey:@"errorCode"];
}

- (id)initWithCoder:(NSCoder *)decoder {
  if ((self = [super init])) {
    _errorMessage = [decoder decodeObjectForKey:@"errorMessage"];
    _errorCode = [decoder decodeIntegerForKey:@"errorCode"];
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  MyNetRequestErrorBean *theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
	
  theCopy.errorMessage = _errorMessage;
  theCopy.errorCode = _errorCode;
	
  return theCopy;
}
#pragma mark -
#pragma mark super class implementations

-(int)code {
	if(_errorCode == 0) {
    return [super code];
  } else {
    return _errorCode;
  }
}
- (NSString *)domain {
  // we are assuming that any request within 1000 to 5000 is thrown by our server or our custom
	if(_errorCode >= 1000 && _errorCode < 5000) {
    return kCustomErrorDomain;
  } else {
    return kHttpRequestErrorDomain;
  }
}

- (NSString *)description {
  return [NSString stringWithFormat:@"Request failed with error %@[%d]", _errorMessage, _errorCode];
}

- (NSString *)localizedDescription {
  
  NSString *message = nil;
  if ([[self domain] isEqualToString:kCustomErrorDomain]) {
    message = [[nErrorCodesDictionary objectForKey:[NSString stringWithFormat:@"%d", _errorCode]] objectForKey:@"Title"];
  }
  if ([NSString isEmpty:message]) {
    message = _errorMessage;
  }
  if ([NSString isEmpty:message]) {
    message = [super localizedDescription];
  }
  
  return message;
}

- (NSString *)localizedRecoverySuggestion {
  
  do {
    if(![[self domain] isEqualToString:kCustomErrorDomain]) {
      break;
    }
    NSString *message = [[nErrorCodesDictionary objectForKey:[NSString stringWithFormat:@"%d", _errorCode]] objectForKey:@"Suggestion"];
    if ([NSString isEmpty:message]) {
      break;
    }
    return message;
  } while (NO);
  
  return [super localizedRecoverySuggestion];
}

- (NSString *)localizedOption {
  if([[self domain] isEqualToString:kCustomErrorDomain]) {
    return [[nErrorCodesDictionary objectForKey:[NSString stringWithFormat:@"%d", _errorCode]] objectForKey:@"Option-1"];
  } else {
    return nil;
  }
}

//===========================================================
// dealloc
//===========================================================
- (void)dealloc {
  _errorMessage = nil;
  _errorCode = -1;
}

@end
