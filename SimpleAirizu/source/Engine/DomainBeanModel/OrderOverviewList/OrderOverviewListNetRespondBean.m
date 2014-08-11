
#import "OrderOverviewListNetRespondBean.h"
#import "OrderOverviewListDatabaseFieldsConstant.h"
#import "OrderOverview.h"

@interface OrderOverviewListNetRespondBean ()
//
@property (nonatomic, readwrite, strong) NSMutableArray *orderOverviewList;

@end

@implementation OrderOverviewListNetRespondBean

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  if ([key isEqualToString:k_OrderList_RespondKey_data]) {
    _orderOverviewList = [[NSMutableArray alloc] init];
    for (NSDictionary *order in value) {
      OrderOverview *orderOverview = [[OrderOverview alloc] initWithDictionary:order];
      [(NSMutableArray *)_orderOverviewList addObject:orderOverview];
    }

  }
}
@end
