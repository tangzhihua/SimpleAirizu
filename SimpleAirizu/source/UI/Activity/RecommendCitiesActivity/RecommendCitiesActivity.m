

#import "RecommendCitiesActivity.h"

#import "RecommendCityTableViewCell.h"

#import "RecommendCityDatabaseFieldsConstant.h"
#import "RecommendNetRequestBean.h"
#import "RecommendNetRespondBean.h"
#import "RecommendCity.h"

//#import "RoomSearchDatabaseFieldsConstant.h"

//#import "RoomListActivity.h"
//#import "CityListActivity.h"

#import "PreloadingUIToolBar.h"






static const NSString *const TAG = @"<RecommendCitiesActivity>";

// table cell 的高度
static const NSInteger kCellHeightForNormal = 190;








@interface RecommendCitiesActivity ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bodyLayout;

// 推荐城市列表 - cell 对应的 nib
@property (nonatomic, retain) UINib *recommendCityTableCellUINib;

// ListView的数据源
@property (nonatomic, retain) NSArray *recommendCityList;
//
@property (nonatomic, assign) NSInteger netRequestIndexForRecommendCity;

//
@property (nonatomic, retain) PreloadingUIToolBar *preloadingUIToolBar;

@end









@implementation RecommendCitiesActivity


- (UINib *)recommendCityTableCellUINib {
  if (_recommendCityTableCellUINib == nil) {
    self.recommendCityTableCellUINib = [RecommendCityTableViewCell nib];
  }
  return _recommendCityTableCellUINib;
}

#pragma mark -
#pragma mark - 内部方法群


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    
    
  }
  return self;
}

// Called after the view has been loaded. For view controllers created in code,
// this is after -loadView. For view controllers unarchived from a nib,
// this is after the view is set.
- (void)viewDidLoad {
  PRPLog(@"%@ --> viewDidLoad ", TAG);
  
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self initPreloadingUIToolBar];
  
  // 先从本地加载缓存数据, 如果没有再从服务器端重新获取网络数据
  self.recommendCityList = [self loadRecommendCityListFromGlobalDataCache];
  
  //
  if (![_recommendCityList isKindOfClass:[NSArray class]]) {
    
    // 本地没有数据缓存, 从网络侧拉取推荐城市列表数据
    _netRequestIndexForRecommendCity = [self requestRecommendCityList];
    if (_netRequestIndexForRecommendCity != IDLE_NETWORK_REQUEST_ID) {
      _bodyLayout.hidden = YES;
      [_preloadingUIToolBar showInView:self.view];
    }
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

// 先从全局数据缓存中获取 RecommendNetRespondBean, 如果没有缓存, 就从网络侧从新拉取数据
- (id)loadRecommendCityListFromGlobalDataCache {
  
  id recommendCityList = nil;
  
  do {
    // 目前采用用户主动向下拖动 table 的方式进行刷新
    RecommendNetRespondBean *recommendNetRespondBean = [[GlobalDataCacheForMemorySingleton sharedInstance] recommendNetRespondBean];
    if (![recommendNetRespondBean isKindOfClass:[RecommendNetRespondBean class]]) {
      break;
    }
    if (![recommendNetRespondBean.recommendCityList isKindOfClass:[NSArray class]]
        || recommendNetRespondBean.recommendCityList.count <= 0) {
      break;
    }
    
    recommendCityList = recommendNetRespondBean.recommendCityList;
  } while (NO);
  
  
  return recommendCityList;
}

#pragma mark -
#pragma mark 跳转到 城市列表界面按钮 单击监听事件
- (IBAction)citySearchOnClickListener:(id)sender {
  
  [self gotoCityListActivity];
}

#pragma mark -
#pragma mark UI相关
-(void)initPreloadingUIToolBar {
  _preloadingUIToolBar = [PreloadingUIToolBar preloadingUIToolBar];
  _preloadingUIToolBar.refreshButtonOnClickHandlerBlock = NULL;
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
}

-(void)onPause {
  
  PRPLog(@"%@ --> onPause ", TAG);
  
  if (_reloading) {
    [super doneLoadingTableViewData];
  }
  
  [SVProgressHUD dismiss];
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
}

#pragma mark -
#pragma mark 网络访问方法群
- (NSInteger) requestRecommendCityList {
  // 2.4 推荐城市
  RecommendNetRequestBean *netRequestBean = [RecommendNetRequestBean recommendNetRequestBean];
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:netRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_RecommendCity
                                                                     andRespondDelegate:self];
  
  return netRequestIndex;
}

typedef enum {
  //
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  //
  kHandlerMsgTypeEnum_RefreshUIForTableView
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage,
  //
  kHandlerExtraDataTypeEnum_RecommendNetRespondBean
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  
  // 关闭 EGORefreshTableHeader
  if (_reloading) {
    [super doneLoadingTableViewData];
  }
  
  switch (msg.what) {
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
      [_preloadingUIToolBar showRefreshButton:YES];
    }break;
      
    case kHandlerMsgTypeEnum_RefreshUIForTableView:{
      RecommendNetRespondBean *recommendNetRespondBean
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_RecommendNetRespondBean]];
      
      //
      self.recommendCityList = recommendNetRespondBean.recommendCityList;
      
      //
      _bodyLayout.hidden = NO;
      [_preloadingUIToolBar dismiss];
      
      //
      [super.table reloadData];
      
      [SVProgressHUD dismiss];
    }break;
      
    default:
      break;
  }
}

- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_RecommendCity == requestEvent) {
    _netRequestIndexForRecommendCity = IDLE_NETWORK_REQUEST_ID;
  }
}

/**
 * 此方法处于非UI线程中
 *
 * @param requestEvent
 * @param errorBean
 * @param respondDomainBean
 */
- (void) domainNetRespondHandleInNonUIThread:(in NSUInteger) requestEvent
                                   errorBean:(in NetErrorBean *) errorBean
                           respondDomainBean:(in id) respondDomainBean {
  
  PRPLog(@"%@ -> domainNetRespondHandleInNonUIThread --- start ! ", TAG);
  [self clearNetRequestIndexByRequestEvent:requestEvent];
  
  if (errorBean.errorType != NET_ERROR_TYPE_SUCCESS) {
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_ShowNetErrorMessage;
    [msg.data setObject:errorBean.errorMessage
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
    [msg.data setObject:[NSNumber numberWithUnsignedInteger:requestEvent]
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetRequestTag]];
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
  }
  
  if (requestEvent == kNetRequestTagEnum_RecommendCity) {// 2.4 房间推荐
    RecommendNetRespondBean *recommendNetRespondBean = respondDomainBean;
    //PRPLog(@"%@ -> %@", TAG, recommendNetRespondBean);
    
    // 缓存 推荐城市列表
    [[GlobalDataCacheForMemorySingleton sharedInstance] setRecommendNetRespondBean:recommendNetRespondBean];
    
    // 刷新 推荐城市 TableView
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_RefreshUIForTableView;
    [msg.data setObject:recommendNetRespondBean
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_RecommendNetRespondBean]];
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
  }
}

#pragma mark -
#pragma mark 设置 TableViewCell 中各控件的 Tag, 用于配合点击事件的监控
-(void)setButtonTagForTableViewCell:(RecommendCityTableViewCell *)cell
                         rowForCell:(NSInteger)row {
  
  cell.cityPhotoButton.tag = kButtonTagInTableViewCellEnum_CityImageButton + row*10;
  [cell.cityPhotoButton addTarget:self action:@selector(tableViewCellOnClickListener:) forControlEvents:UIControlEventTouchUpInside];
  cell.street1NameButton.tag = kButtonTagInTableViewCellEnum_Street1Button + row*10;
  [cell.street1NameButton addTarget:self action:@selector(tableViewCellOnClickListener:) forControlEvents:UIControlEventTouchUpInside];
  cell.street2NameButton.tag = kButtonTagInTableViewCellEnum_Street2Button + row*10;
  [cell.street2NameButton addTarget:self action:@selector(tableViewCellOnClickListener:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark 实现 UITableViewDataSource 接口

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _recommendCityList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSInteger row = indexPath.row;
  
  RecommendCityTableViewCell *cell
  = [RecommendCityTableViewCell cellForTableView:tableView fromNib:self.recommendCityTableCellUINib];
  // 关闭 TableViewCell 的点击响应
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  // 初始化 TableViewCell 中的数据
  if ([_recommendCityList isKindOfClass:[NSArray class]] && row < _recommendCityList.count) {
    RecommendCity *recommendCity = [_recommendCityList objectAtIndex:row];
    if ([recommendCity isKindOfClass:[RecommendCity class]]) {
      [cell initTableViewCellDataWithRecommendCity:recommendCity];
    }
  }
  
  // 设置 TableViewCell 中各按钮控件的点击事件 监控
  [self setButtonTagForTableViewCell:cell rowForCell:indexPath.row];
  
  return cell;
}

#pragma mark -
#pragma mark 实现 UITableViewDelegate 接口

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kCellHeightForNormal;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *) tableView
            editingStyleForRowAtIndexPath:(NSIndexPath *) indexPath {
  
  // 去掉右边的 delete 按钮
  return UITableViewCellEditingStyleNone;
}

#pragma mark -
#pragma mark TableViewCell 中各控件点击事件监控
typedef enum {
  // 城市图片
  kButtonTagInTableViewCellEnum_CityImageButton = 0,
  // 地标 1
  kButtonTagInTableViewCellEnum_Street1Button,
  // 地标 2
  kButtonTagInTableViewCellEnum_Street2Button
} ButtonTagInTableViewCellEnum;

- (void) tableViewCellOnClickListener:(id) sender {
  UIButton *button = sender;
  NSInteger rowForCell = button.tag/10;
  NSUInteger realButtonTag = button.tag%10;
  RecommendCity *recommendCity = [_recommendCityList objectAtIndex:rowForCell];
  
  switch (realButtonTag) {
    case kButtonTagInTableViewCellEnum_CityImageButton:{// "推荐城市"
      [self gotoRoomListActivityWithCityID:[recommendCity.cityId stringValue]
                               andCityName:recommendCity.cityName
                             andStreetName:nil];
    }break;
      
    case kButtonTagInTableViewCellEnum_Street1Button:{// "地标 1"
      [self gotoRoomListActivityWithCityID:[recommendCity.cityId stringValue]
                               andCityName:recommendCity.cityName
                             andStreetName:recommendCity.street1SimName];
    }break;
      
    case kButtonTagInTableViewCellEnum_Street2Button:{// "地标 2"
      [self gotoRoomListActivityWithCityID:[recommendCity.cityId stringValue]
                               andCityName:recommendCity.cityName
                             andStreetName:recommendCity.street2SimName];
    }break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark 跳转到 房源列表界面, 开始查询目标房源
- (void) gotoRoomListActivityWithCityID:(NSString *) cityIdString
                            andCityName:(NSString *) cityNameString
                          andStreetName:(NSString *) streetNameString {
  
  Intent *intent = [Intent intentWithSpecificComponentClass:[RoomListActivity class]];
  NSMutableDictionary *roomSearchCriteriaDictionary = [NSMutableDictionary dictionary];
  
  // 城市id
  if (![NSString isEmpty:cityIdString]) {
    [roomSearchCriteriaDictionary setObject:cityIdString
                                     forKey:kRoomSearch_RequestKey_cityId];
  }
  // 城市名称
  if (![NSString isEmpty:cityNameString]) {
    [roomSearchCriteriaDictionary setObject:cityNameString
                                     forKey:kRoomSearch_RequestKey_cityName];
  }
  // 地标名
  if (![NSString isEmpty:streetNameString]) {
    [roomSearchCriteriaDictionary setObject:streetNameString
                                     forKey:kRoomSearch_RequestKey_streetName];
  }
  
  [intent.extras setObject:roomSearchCriteriaDictionary forKey:kIntentExtraTagForRoomListActivity_RoomSearchCriteria];
  
  [self startActivity:intent];
}

#pragma mark -
#pragma mark 跳转到 城市列表界面
-(void)gotoCityListActivity {
  Intent *intent = [Intent intentWithSpecificComponentClass:[CityListActivity class]];
  [intent.extras setObject:[NSNumber numberWithUnsignedInteger:kSelectTheCityAfterTheOperationEnum_SearchingRoomWithCity] forKey:kIntentExtraTagForCityListActivity_SelectTheCityAfterTheOperation];
  [self startActivity:intent];
}

#pragma mark -
#pragma mark 实现 ListActivity 向下滑动事件的响应方法
// This is the core method you should implement
- (void)reloadTableViewDataSource {
	_reloading = YES;
  
  do {
    
    if (_netRequestIndexForRecommendCity != IDLE_NETWORK_REQUEST_ID) {
      break;
    }
    
    // 重新请求 "推荐城市列表"
    _netRequestIndexForRecommendCity = [self requestRecommendCityList];
    
    //
    return;
  } while (NO);
  
  // 20130223 tangzhihua : 不能在这里直接调用 doneLoadingTableViewData, 否则关不掉当前界面
  // Here you would make an HTTP request or something like that
  // Call [self doneLoadingTableViewData] when you are done
  [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  
  if ([control isKindOfClass:[PreloadingUIToolBar class]]) {
    
    if (kPreloadingUIToolBarActionEnum_RefreshButtonClicked == action) {
      if (_netRequestIndexForRecommendCity == IDLE_NETWORK_REQUEST_ID) {
        _netRequestIndexForRecommendCity = [self requestRecommendCityList];
        if (_netRequestIndexForRecommendCity != IDLE_NETWORK_REQUEST_ID) {
          [_preloadingUIToolBar showRefreshButton:NO];
        }
      }
    }
    
  }
  
}
@end
