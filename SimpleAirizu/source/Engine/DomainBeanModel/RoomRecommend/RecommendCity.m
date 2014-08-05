//
//  RecommendCity.m
//  airizu
//
//  Created by 唐志华 on 12-12-25.
//
//

#import "RecommendCity.h"
#import "RecommendCityDatabaseFieldsConstant.h"

static const NSString *const TAG = @"<RecommendCity>";

@implementation RecommendCity



- (NSString *)description {
	return descriptionForDebug(self);
}

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_ID             forKey:kRecommendCity_RespondKey_id];
  [aCoder encodeObject:_cityName       forKey:kRecommendCity_RespondKey_cityName];
  [aCoder encodeObject:_cityId         forKey:kRecommendCity_RespondKey_cityId];
  [aCoder encodeObject:_image          forKey:kRecommendCity_RespondKey_image];
  [aCoder encodeObject:_sort           forKey:kRecommendCity_RespondKey_sort];
  [aCoder encodeObject:_street1Name    forKey:kRecommendCity_RespondKey_street1Name];
  [aCoder encodeObject:_street1Id      forKey:kRecommendCity_RespondKey_street1Id];
  [aCoder encodeObject:_street2Name    forKey:kRecommendCity_RespondKey_street2Name];
  [aCoder encodeObject:_street2Id      forKey:kRecommendCity_RespondKey_street2Id];
  [aCoder encodeObject:_street1SimName forKey:kRecommendCity_RespondKey_street1SimName];
  [aCoder encodeObject:_street2SimName forKey:kRecommendCity_RespondKey_street2SimName];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    // 如果有不需要序列化的属性存在时, 可以在这里先进行初始化
    
    //
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_id]) {
      _ID = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_id] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_cityName]) {
      _cityName = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_cityName] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_cityId]) {
      _cityId = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_cityId] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_image]) {
      _image = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_image] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_sort]) {
      _sort = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_sort] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street1Name]) {
      _street1Name = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street1Name] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street1Id]) {
      _street1Id = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street1Id] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street2Name]) {
      _street2Name = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street2Name] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street2Id]) {
      _street2Id = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street2Id] copy];
    }

    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street1SimName]) {
      _street1SimName = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street1SimName] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street2SimName]) {
      _street2SimName = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street2SimName] copy];
    }
    
  }
  
  return self;
}

@end
