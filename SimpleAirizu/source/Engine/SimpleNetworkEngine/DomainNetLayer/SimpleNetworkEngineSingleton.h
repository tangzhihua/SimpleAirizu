//
//  Domain Net Layer (业务网络层)
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>
#import "INetRequestHandle.h"
#import "MyNetRequestErrorBean.h"

/* ------------   引擎设计说明   ------------
 
 latest date : 20140629
 
 引擎的设计初衷是, 通过分层架构, 让各层的职责单一化(关注点隔离思想), 只有保证了各层职责单一化,
 才能充分发挥团队中, 高中初级工程师的技术水准.
 引擎分为三层, 业务层/业务网络层/网络层.
 
 1) 业务层
 就是控制层(Controller/Activity), 这层的定义是完成app相关的业务逻辑,
 所以这层也是一个app中工作量最大和改动量最大的地方;
 一个在线App, 其实就是客户端和服务器之间传递 "业务Bean", 客户端主要负责显示服务器端传递回来的 "业务Bean".
 在我的引擎中, 最大程度的保证了业务层开发的单一性, 在业务层通过 "外观模式" 获取一个统一的API接口 SimpleNetworkEngineSingleton,
 通过它将复杂的网络访问隔离开去, 使用两种业务Bean来体现网络接口的交互,
 这就是 NetRequestBean(网络请求业务Bean, 发起一个网络请求时, 需要构建目标接口的 NetRequestBean),
 和 NetRespondBean(网络响应业务Bean, 服务器返回的数据, 都被封装在这个Bean中.)
 客户端和服务器的交互, 在业务层, 就被抽象成了这两个业务Bean(这点上和http协议的 请求报文 和 响应报文 的抽象相似).
 调用 SimpleNetworkEngineSingleton 提供的方法, 发起一个网络接口的访问后, 会直接返回 id<INetRequestHandle>,
 这个就是给业务层提供的, 本次网络请求的操作句柄, 通过这个句柄可以查询本次网络请求的运行情况, 并且可以取消本次网络请求.
 SimpleNetworkEngineSingleton 提供的方法, 永远不会返回一个nil对象, 当发生错误时, 会返回一个 NetRequestHandleNilObject 对象,
 这样就最大程度保证了业务层编码住够简单安全.
 业务层不应该在发起网络请求时, 看见 "多线程" "数据交换协议" "数据加密" "具体的网络协议, 或者具体的网络引擎", 这些应该被封装, 被隔离.
 业务层只跟业务打交道, 数据的代表就是两个业务Bean.
 这样做的好处是不言而喻的, 也就是说, 当那些和业务无关的细节(上面提到的 "多线程" "数据交换协议" 等等...)需要改变时, 业务层代码不需要修改, 这样就遵循了OO的OCP原则.
 
 3) 网络层
 网络层的定位, 就是一个通用的http请求, 在网络层不应该有具体业务的识别, 而只应该遵循http协议的抽象定义, "请求报文" 和 "响应报文"
 网络层的具体设计细节就是, "网络层" 和 "业务网络层" 之间定义一个接口 INetLayerInterface,
 这个接口只传递最少的数据, 就是URL和DataDictionary(数据字典, 要发往服务器的数据),
 网络层可以采用目前流行的http引擎, 如MKNetworkKit, AFNetworking, 或者自己完全实现一个http引擎都可以.
 
 2) 业务网络层
 业务网络层的定位就是完成 "业务层" 和 "网络层" 的协调/沟通/翻译, 反正就是中间人的角色.
 业务网络层和业务层之间的数据交互, 就是通过 "NetRequestBean" "NetRespondBean".
 但是和网络层之间的数据交互是要按照它们之间的约定接口 INetLayerInterface,
 这个接口需要的是URL和DataDictionary, 所以业务网络层要完成
 NetRequestBean  ----> URL和DataDictionary 以及
 NetResponseData ----> NetRespondBean 之间的转换工作.
 
 这里的设计细节是这样的:
 1.首先定义一个所有业务Bean都需要实现的抽象工厂接口 IDomainBeanHelper,
 这个接口主要提供具体业务接口的 URL和将业务Bean解析成数据字典的策略算法, 还有用于反射的Class, 这些接口每个具体的业务Bean都不一样.
 2.在DomainBeanHelperClassNameMapping中完成一个具体的业务接口请求Bean和其抽象工厂的映射,
 完成映射后, 业务网络层, 只要编写多态的代码, 就可以应对所有业务接口的访问了.
 以前见过很多非面向对象的设计是这样的, 会为每个业务接口提供一个助手函数, 入参是具体的参数, 返回值可能是数据交换协议或者一个响应业务Bean,
 这种设计, 都是 "重复代码" 这种坏味道的体现, 虽然乍一看没有什么代码是重复, 但是都忽略了一点, 就是抽象,
 这里的抽象是什么呢, 就是, "请求" 和 "响应", 所有助手函数的代码逻辑都是一样的, 一旦要增加变化时, 就需要修改全部的函数, 这个简直是噩梦.
 
 
 
 
 */

// 发起的网络请求操作项的优先级别
typedef NS_ENUM(NSInteger, NetRequestOperationPriority) {
	NetRequestOperationPriorityVeryLow = 0,
	NetRequestOperationPriorityLow,
	NetRequestOperationPriorityNormal,
	NetRequestOperationPriorityHigh,
	NetRequestOperationPriorityVeryHigh
};

// 业务Bean异步http响应监听 (在UI线程中)

// 网络请求激活成功(可以在这个回调中, 显示 ProgressDialog 之类的UI)
typedef void (^DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)();
// 网络请求彻底完成(可以在这个回调中, 关闭 ProgressDialog 之类的UI)
typedef void (^DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)();
// 请求业务Bean成功
typedef void (^DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)(id respondDomainBean);
// 请求业务Bean失败
typedef void (^DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)(MyNetRequestErrorBean *error);

/**
 * 我们封装的网络引擎
 * 提供以下功能 :
 * 1.提供 requestDomainBean : 用于请求业务Bean
 * 2.提供 requestFileDownlaod : 用于下载文件
 *
 * @author skyduck
 *
 */
@interface SimpleNetworkEngineSingleton : NSObject

+ (SimpleNetworkEngineSingleton *) sharedInstance;

/***********************              不带优先级的接口            ***********************/

/// 普通形式(优先级默认是 NetRequestOperationPriorityNormal)
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock;

/// 配合UI显示的形式(优先级默认是 NetRequestOperationPriorityNormal)
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock;

/***********************              带优先级的接口              ***********************/

/// 普通形式
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                    netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock;

/// 配合UI显示的形式
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                    netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock;
@end
