//
//  OrderOverview.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

 
#import "BaseModel.h"

@interface OrderOverview : BaseModel
// 订单编号
@property (nonatomic, copy) NSNumber *orderId;
// 房间标题
@property (nonatomic, copy) NSString *roomTitle;
// 入住时间
@property (nonatomic, copy) NSString *checkInDate;
// 退房时间
@property (nonatomic, copy) NSString *checkOutDate;
// 订单状态代码
@property (nonatomic, copy) NSNumber *statusCode;
// 订单总额
@property (nonatomic, copy) NSNumber *orderTotalPrice;
// 房间图片地址
@property (nonatomic, copy) NSString *roomImage;
// 房间ID
@property (nonatomic, copy) NSNumber *roomId;
// 当前订单的实际状态说明信息
@property (nonatomic, copy) NSString *statusContent;
 
@end
