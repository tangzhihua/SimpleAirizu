//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#ifndef airizu_OrderOverviewDatabaseFieldsConstant_h
#define airizu_OrderOverviewDatabaseFieldsConstant_h

/************      RequestBean       *************/

// 订单状态(1,待确定，2待支付，3待入住，4待评价5已完成)
#define k_OrderList_RequestKey_orderState          @"orderState"

/************      RespondBean       *************/


//
#define k_OrderList_RespondKey_data                @"data"

//
// 订单编号
#define k_OrderList_RespondKey_orderId             @"orderId"
// 房间标题
#define k_OrderList_RespondKey_roomTitle           @"roomTitle"
// 入住时间
#define k_OrderList_RespondKey_checkInDate         @"checkInDate"
// 退房时间
#define k_OrderList_RespondKey_checkOutDate        @"checkOutDate"
// 订单状态代码
#define k_OrderList_RespondKey_statusCode          @"statusCode"
// 订单总额
#define k_OrderList_RespondKey_orderTotalPrice     @"orderTotalPrice"
// 房间图片地址
#define k_OrderList_RespondKey_roomImage           @"roomImage"
// 房间ID
#define k_OrderList_RespondKey_roomId              @"roomId"
// 当前订单的状态描述信息
#define k_OrderList_RespondKey_statusContent       @"statusContent"

#endif

