//
//  RecommendCityDatabaseFieldsConstant.h
//  airizu
//
//  Created by 唐志华 on 12-12-25.
//
//

#ifndef airizu_RecommendCityDatabaseFieldsConstant_h
#define airizu_RecommendCityDatabaseFieldsConstant_h

/************      RequestBean       *************/


/************      RespondBean       *************/
//  
#define kRecommendCity_RespondKey_data           @"data"

// 详细的数据
// 编号
#define kRecommendCity_RespondKey_id             @"id"
// 城市名称
#define kRecommendCity_RespondKey_cityName       @"cityName"
// 城市id
#define kRecommendCity_RespondKey_cityId         @"cityId"
// 对应图片地址 
#define kRecommendCity_RespondKey_image          @"image"
// 排序
#define kRecommendCity_RespondKey_sort           @"sort"

/// 这里的地标名称只是用于显示在 地标按钮 中的信息 (例如 "国贸商圈精品短租")
// 地标1 名称
#define kRecommendCity_RespondKey_street1Name    @"street1Name"
// 地标1 编号
#define kRecommendCity_RespondKey_street1Id      @"street1Id"
// 地标2名称
#define kRecommendCity_RespondKey_street2Name    @"street2Name"
// 地标2编号
#define kRecommendCity_RespondKey_street2Id      @"street2Id"

/// 这里是真实的地标名称(例如 "国贸")
//
#define kRecommendCity_RespondKey_street1SimName @"street1SimName"
//
#define kRecommendCity_RespondKey_street2SimName @"street2SimName"

#endif

