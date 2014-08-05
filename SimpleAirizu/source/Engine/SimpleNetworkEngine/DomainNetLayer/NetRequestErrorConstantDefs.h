//
//  NetRequestErrorConstantDefs.h
//  SimpleBook
//
//  Created by 唐志华 on 13-12-30.
//  Copyright (c) 2013年 唐志华. All rights reserved.
//

#ifndef SimpleBook_NetRequestErrorConstantDefs_h
#define SimpleBook_NetRequestErrorConstantDefs_h

// 网络请求时, 错误码枚举
// 错误码说明 : 包容了 http 错误码(2000以内的数字)
typedef NS_ENUM(NSInteger, NetErrorCodeEnum) {
  // 网络访问成功(也就是说从服务器获取到了正常的有效数据)
  kNetErrorCodeEnum_Success = 200,
  
  
  
  
  
  /// 客户端错误
  kNetErrorCodeEnum_Client_Error = 1000,
  kNetErrorCodeEnum_Client_ProgrammingError = 1001, // 客户端编程错误
  
  /// 服务器错误
  kNetErrorCodeEnum_Server_Error = 2000,
  
  // 从服务器端获得的实体数据为空(EntityData), 这种情况有可能是正常的, 比如 退出登录 接口, 服务器就只是通知客户端访问成功, 而不发送任何实体数据.
  kNetErrorCodeEnum_Server_NoResponseData                 = 2001,
  // 解析服务器端返回的实体数据失败, 在netUnpackedDataOfUTF8String不为空的时候, unpackNetRespondRawEntityDataToUTF8String是绝对不能为空的.
  kNetErrorCodeEnum_Server_UnpackedResponseDataFailed     = 2002,
  // 将网络返回的数据转换成 "字典" 失败, 可能原因是服务器和客户端的数据协议不同步照成的, 比如说客户端需要JSON, 而服务器返回的数据格式不是JSON
  kNetErrorCodeEnum_Server_ResponseDataToDictionaryFailed = 2003,
  
  
  /// 和服务器约定好的错误码, 联网成功, 但是服务器那边发生了错误, 服务器要告知客户端错误的详细信息
  kNetErrorCodeEnum_Server_Custom_Error = 3000,
  kNetErrorCodeEnum_Server_Failed    = 3001,     // "操作失败"
  kNetErrorCodeEnum_Server_Exception = 3002,     // "处理异常"
  kNetErrorCodeEnum_Server_NoResult  = 3003,     // "无结果返回"
  kNetErrorCodeEnum_Server_NeedLogin = 3004,     // "需要登录"
};


#endif
