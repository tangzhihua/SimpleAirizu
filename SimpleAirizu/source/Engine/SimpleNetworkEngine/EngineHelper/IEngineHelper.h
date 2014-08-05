//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>

/**
 * 引擎助手类
 * @author zhihua.tang
 *
 */
@protocol INetRequestEntityDataPackage;
@protocol INetRespondRawEntityDataUnpack;
@protocol IServerRespondDataTest;
@protocol INetRespondDataToNSDictionary;
@protocol ISpliceFullUrlByDomainBeanSpecialPath;

@protocol IEngineHelper <NSObject>
// 将数据字典集合, 打包成网络请求字符串, (可以在这里完成数据的加密工作)
- (id<INetRequestEntityDataPackage>) getNetRequestEntityDataPackageStrategyAlgorithm;
// 将网络返回的数据, 解压成可识别的字符串(在这里完成数据的解密)
- (id<INetRespondRawEntityDataUnpack>) getNetRespondEntityDataUnpackStrategyAlgorithm;
// 测试从服务器端返回的数据是否是有效的(数据要先解包, 然后再根据错误码做判断)
- (id<IServerRespondDataTest>) getServerRespondDataTestStrategyAlgorithm;
// 将网络响应数据转成 NSDictionary 数据
- (id<INetRespondDataToNSDictionary>) getNetRespondDataToNSDictionaryStrategyAlgorithm;
// 拼接一个网络接口的完整请求URL
- (id<ISpliceFullUrlByDomainBeanSpecialPath>) getSpliceFullUrlByDomainBeanSpecialPathStrategyObject;
@end

