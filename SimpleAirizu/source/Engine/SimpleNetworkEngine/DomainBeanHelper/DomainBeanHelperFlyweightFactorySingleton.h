//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

/**
 * 这里应用了享元模式
 * 享元模式是设计模式中少数几个以提高系统性能为目的的模式之一.它的核心思想是
 * 如果在一个系统中存在多个相同的对象, 那么只需要共享一份对象的拷贝, 而不必为每一次使用都创建新的对象.
 * 在享元模式中, 由于需要构造和维护这些可以共享的对象, 因此常常会出现一个工厂类, 用于维护和创建对象.
 * 享元模式对性能提升的主要帮助有两点:
 * 1.可以节省重复创建对象的开销, 因为被享元模式维护的相同对象只会被创建一次, 当创建对象比较耗时时, 便可以节省大量时间.
 * 2.由于创建对象的数量减少, 所以对系统内存的需求也减少, 这将使得GC的压力也相应地降低,
 * 进而使得系统拥有一个更健康的内存结构和更快的反应速度
 *
 * 享元模式的主要角色由 享元工厂/抽象单元/具体享元类
 *
 * 享元模式和对象池的最大不同在于, 享元对象是不可相互替代的, 它们各自都有各自的含义和用途; 而对象池中的对象都是等价的, 如数据库连接池中的数据库连接.
 *
 * @author skyduck
 */

#import "StrategyClassNameMappingBase.h"

@protocol IDomainBeanHelper;
@interface DomainBeanHelperFlyweightFactorySingleton : NSObject

+ (DomainBeanHelperFlyweightFactorySingleton *)sharedInstance;

#pragma mark -
#pragma mark - 根据key提供一个与该key绑定的业务接口的抽象工厂对象
/**
 * 根据请求业务Bean的getClass().getName(), 获取和其对应的Helper对象
 *
 * @param requestDomainBeanClassName
 * @return
 * @throws Exception
 */
- (id<IDomainBeanHelper>)domainBeanHelperByRequestDomainBeanClassName:(in NSString *)requestDomainBeanClassName;
@end
