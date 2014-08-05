
#import "BaseModel.h"

@interface RecommendCity : BaseModel

// 编号
@property (nonatomic, readonly) NSNumber *ID;
// 城市名称
@property (nonatomic, readonly) NSString *cityName;
// 城市id
@property (nonatomic, readonly) NSNumber *cityId;
// 对应图片地址
@property (nonatomic, readonly) NSString *image;
// 排序
@property (nonatomic, readonly) NSNumber *sort;

/// 这里的地标名称只是用于显示在 地标按钮 中的文字信息, 不要把这个字段传给后台. (例如 "国贸商圈精品短租")
// 地标1 名称
@property (nonatomic, readonly) NSString *street1Name;
// 地标1 编号
@property (nonatomic, readonly) NSNumber *street1Id;
// 地标2名称
@property (nonatomic, readonly) NSString *street2Name;
// 地标2编号
@property (nonatomic, readonly) NSNumber *street2Id;

/// 这里是真实的地标名称(例如 "国贸"), 需要把这个数据传给后台
//
@property (nonatomic, readonly) NSString *street1SimName;
//
@property (nonatomic, readonly) NSString *street2SimName;

@end

