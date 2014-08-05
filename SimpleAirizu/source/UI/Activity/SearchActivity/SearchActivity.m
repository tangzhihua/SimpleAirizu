//
//  AskQuestionController.m
//  gameqa
//
//  Created by user on 12-9-11.
//
//

#import "SearchActivity.h"

#import "RadioPopupList.h"
#import "RoomListActivity.h"
#import "SearchRoomByNumberActivity.h"
#import "RoomCalendar.h"

#import "NSDate+Convenience.h"

#import "RoomSearchDatabaseFieldsConstant.h"

#import "CityListActivity.h"

#import "CalendarActivity.h"













static const NSString *const TAG = @"<SearchActivity>";














@interface SearchActivity ()

// 房间搜索条件
@property (nonatomic, retain) NSDate   *dateForCheckIn; // "入住时间"
@property (nonatomic, retain) NSDate   *dateForCheckOut;// "退房时间"
@property (nonatomic, copy)   NSString *occupancyCount; // "入住人数"
@property (nonatomic, copy)   NSString *roomPrice;      // "房间价格"

// 弹出式控件群
@property (nonatomic, assign) RadioPopupList *radioPopupListForOccupancyCount;
@property (nonatomic, assign) RadioPopupList *radioPopupListForRoomPrice;

// 城市名称/城市ID
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityId;
@end














@implementation SearchActivity

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  // 跳转到城市列表界面
  kIntentRequestCodeEnum_ToCityListActivity = 0,
  // 跳转到 "房间日历界面"
  kIntentRequestCodeEnum_ToCalendarActivity
};

#pragma mark -
#pragma mark 内部方法群
- (void)dealloc {
  
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  // 房间搜索条件
  [_dateForCheckIn release];
  [_dateForCheckOut release];
  [_occupancyCount release];
  [_roomPrice release];
  
  // 城市名称/城市ID
  [_cityName release];
  [_cityId release];
  
  // UI
  [_cityNameButton release];
  [_checkinDateButton release];
  [_checkoutDateButton release];
  [_occupancyButton release];
  [_priceButton release];
  [_checkInDateDayLabel release];
  [_checkInDateMonthLabel release];
  [_checkInDateWeekLabel release];
  [_checkOutDateDayLabel release];
  [_checkOutDateMonthLabel release];
  [_checkOutDateWeekLabel release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    // "入住人数" 默认是 1 人
    self.occupancyCount = @"1";
    
    self.cityName = @"北京";
    self.cityId = @"110100";
  }
  return self;
}

- (void)viewDidLoad {
  PRPLog(@"%@ --> viewDidLoad ", TAG);
  
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
}

- (void)viewDidUnload {
  
  PRPLog(@"%@ --> viewDidUnload ", TAG);
  
  /// UI
  [self setCityNameButton:nil];
  [self setCheckinDateButton:nil];
  [self setCheckoutDateButton:nil];
  [self setOccupancyButton:nil];
  [self setPriceButton:nil];
  [self setCheckInDateDayLabel:nil];
  [self setCheckInDateMonthLabel:nil];
  [self setCheckInDateWeekLabel:nil];
  [self setCheckOutDateDayLabel:nil];
  [self setCheckOutDateMonthLabel:nil];
  [self setCheckOutDateWeekLabel:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  // TODO : 这里是对 "弹出式控件" 的关闭处理, 目前的方式很麻烦, 是否考虑 移入 Activity父类中呢?
  /*
   if ([self.view.subviews containsObject:_checkInRoomCalendar]) {
   [_checkInRoomCalendar dismiss], _checkInRoomCalendar = nil;
   } else {
   _checkInRoomCalendar = nil;
   }
   //
   if ([self.view.subviews containsObject:_checkOutRoomCalendar]) {
   [_checkOutRoomCalendar dismiss], _checkOutRoomCalendar = nil;
   } else {
   _checkOutRoomCalendar = nil;
   }
   */
  
  ///
  if ([self.view.subviews containsObject:_radioPopupListForOccupancyCount]) {
    [_radioPopupListForOccupancyCount dismiss], _radioPopupListForOccupancyCount = nil;
  } else {
    _radioPopupListForOccupancyCount = nil;
  }
  //
  if ([self.view.subviews containsObject:_radioPopupListForRoomPrice]) {
    [_radioPopupListForRoomPrice dismiss], _radioPopupListForRoomPrice = nil;
  } else {
    _radioPopupListForRoomPrice = nil;
  }
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
}

- (void) onActivityResult:(int) requestCode
               resultCode:(int) resultCode
                     data:(Intent *) data {
  PRPLog(@"%@ onActivityResult", TAG);
  
  do {
    if (resultCode != kActivityResultCode_RESULT_OK) {
      break;
    }
    
    switch (requestCode) {
      case kIntentRequestCodeEnum_ToCityListActivity:{
        [self onActivityResultProcessForToCityListActivityWithReturnedData:data];
      }break;
        
      case kIntentRequestCodeEnum_ToCalendarActivity:{
        [self onActivityResultProcessForToCalendarActivityWithReturnedData:data];
      }break;
        
      default:
        break;
    }
    
  } while (NO);
  
}

-(BOOL)onActivityResultProcessForToCityListActivityWithReturnedData:(Intent *)data {
  do {
    if (![data isKindOfClass:[Intent class]]) {
      break;
    }
    
    if (![data hasExtra:kRoomSearch_RequestKey_cityId] || ![data hasExtra:kRoomSearch_RequestKey_cityName]) {
      break;
    }
    
    self.cityId = [data.extras objectForKey:kRoomSearch_RequestKey_cityId];
    self.cityName = [data.extras objectForKey:kRoomSearch_RequestKey_cityName];
    
    [_cityNameButton setTitle:_cityName forState:UIControlStateNormal];
    
    // 一切正常
    return YES;
  } while (NO);
  
  // 出现问题
  return NO;
}

-(BOOL)onActivityResultProcessForToCalendarActivityWithReturnedData:(Intent *)data {
  do {
    if (![data isKindOfClass:[Intent class]]) {
      break;
    }
    
    id checkInDate = [data.extras objectForKey:[NSNumber numberWithInteger:kCalendarTypeEnum_CheckInDate]];
    if ([checkInDate isKindOfClass:[NSDate class]]) {
      [self saveCheckInDateAndUpdateDateControls:checkInDate];
    }
    id checkOutDate = [data.extras objectForKey:[NSNumber numberWithInteger:kCalendarTypeEnum_CheckOutDate]];
    if ([checkOutDate isKindOfClass:[NSDate class]]) {
      [self saveCheckOutDateAndUpdateDateControls:checkOutDate];
    }

    
    return YES;
  } while (NO);
  
  
  return NO;
}

#pragma mark -
#pragma mark 初始化UI界面

typedef enum {
  // "入住人数"
  kRadioPopupListTypeTag_Occupancy = 0,
  // "房间价格"
  kRadioPopupListTypeTag_Price
}RadioPopupListTypeTag;


// "城市名称"
- (IBAction)cityNameButtonOnClickListener:(id)sender {
  
  Intent *intent = [Intent intentWithSpecificComponentClass:[CityListActivity class]];
  [intent.extras setObject:[NSNumber numberWithUnsignedInteger:kSelectTheCityAfterTheOperationEnum_BackToSearchActivity] forKey:kIntentExtraTagForCityListActivity_SelectTheCityAfterTheOperation];
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToCityListActivity];
}

// "入住时间"
- (IBAction)checkinDateButtonOnClickListener:(id)sender {
  
  Intent *intent = [Intent intentWithSpecificComponentClass:[CalendarActivity class]];
  [intent.extras setObject:[NSNumber numberWithInteger:kCalendarTypeEnum_CheckInDate] forKey:kIntentExtraTagForCalendarActivity_CalendarType];
  [intent.extras setObject:[NSNumber numberWithInteger:60] forKey:kIntentExtraTagForCalendarActivity_MaxNumberOfDaysSpanInteger];
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToCalendarActivity];
}

// "退房时间"
- (IBAction)checkoutDateButtonOnClickListener:(id)sender {
  
  Intent *intent = [Intent intentWithSpecificComponentClass:[CalendarActivity class]];
  [intent.extras setObject:[NSNumber numberWithInteger:kCalendarTypeEnum_CheckOutDate] forKey:kIntentExtraTagForCalendarActivity_CalendarType];
  if (_dateForCheckIn != nil) {
    [intent.extras setObject:self.dateForCheckIn forKey:kIntentExtraTagForCalendarActivity_SelectableDayMarkForStart];
  }
  
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToCalendarActivity];
}

// "入住人数"
- (IBAction)occupancyButtonOnClickListener:(id)sender {
  NSMutableArray *dataSource = [NSMutableArray array];
  [dataSource addObjectsFromArray:[[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForOccupancyCountList allKeys]];
  
  RadioPopupList *radioPopupList = [RadioPopupList radioPopupListWithTitle:@"入住人数" dataSource:dataSource delegate:self];
  radioPopupList.tag = kRadioPopupListTypeTag_Occupancy;
  // 恢复上一次的选择结果
  NSString *lastValue = _occupancyButton.titleLabel.text;
  NSInteger defaultSelectedIndex = [dataSource indexOfObject:lastValue];
  [radioPopupList setDefaultSelectedIndex:defaultSelectedIndex];
  //
  [radioPopupList setFrame:self.view.frame];
  [radioPopupList showInView:self.view];
  
  // 缓存弹出式控件, 用于在Activity 进入 onPause 时, 关闭弹出式控件
  self.radioPopupListForOccupancyCount = radioPopupList;
}

// "房间价格"
- (IBAction)priceButtonOnClickListener:(id)sender {
  NSMutableArray *dataSource = [NSMutableArray array];
  [dataSource addObject:@"价格不限"];
  [dataSource addObjectsFromArray:[[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForPriceDifferenceList allKeys]];
  
  RadioPopupList *radioPopupList = [RadioPopupList radioPopupListWithTitle:@"房间价格" dataSource:dataSource delegate:self];
  radioPopupList.tag = kRadioPopupListTypeTag_Price;
  // 恢复上一次的选择结果
  NSString *lastValue = _priceButton.titleLabel.text;
  NSInteger defaultSelectedIndex = [dataSource indexOfObject:lastValue];
  [radioPopupList setDefaultSelectedIndex:defaultSelectedIndex];
  //
  [radioPopupList setFrame:self.view.frame];
  [radioPopupList showInView:self.view];
  
  // 缓存弹出式控件, 用于在Activity 进入 onPause 时, 关闭弹出式控件
  self.radioPopupListForRoomPrice = radioPopupList;
}

-(void)gotoRoomListActivityWithRoomSearchCriteriaDictionary:(NSMutableDictionary *)roomSearchCriteriaDictionary{
  Intent *intent = [Intent intentWithSpecificComponentClass:[RoomListActivity class]];
  [intent.extras setObject:roomSearchCriteriaDictionary forKey:kIntentExtraTagForRoomListActivity_RoomSearchCriteria];
  [self startActivity:intent];
}

// "搜索" 按钮
- (IBAction)searchButtonOnClickListener:(id)sender {
  
  NSString *errorMessage = @"";
  do {
    if (_dateForCheckIn != nil && _dateForCheckOut != nil) {
      NSDate *laterDate = [_dateForCheckIn laterDate:_dateForCheckOut];
      if (laterDate == _dateForCheckIn) {
        errorMessage = @"入住时间不能晚于退房时间.";
        break;
      }
    }
    
    NSMutableDictionary *roomSearchCriteriaDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    
    // 城市名称/城市ID
    [roomSearchCriteriaDictionary setObject:_cityName forKey:kRoomSearch_RequestKey_cityName];
    [roomSearchCriteriaDictionary setObject:_cityId forKey:kRoomSearch_RequestKey_cityId];
    
    // "入住时间"
    if (_dateForCheckIn != nil) {
      [roomSearchCriteriaDictionary setObject:[_dateForCheckIn stringWithDateFormat:@"yyyy-MM-dd"] forKey:kRoomSearch_RequestKey_checkinDate];
    }
    // "退房时间"
    if (_dateForCheckOut != nil) {
      [roomSearchCriteriaDictionary setObject:[_dateForCheckOut stringWithDateFormat:@"yyyy-MM-dd"] forKey:kRoomSearch_RequestKey_checkoutDate];
    }
    // "入住人数"
    if (![NSString isEmpty:_occupancyCount]) {
      [roomSearchCriteriaDictionary setObject:_occupancyCount forKey:kRoomSearch_RequestKey_occupancyCount];
    }
    // "房间价格"
    if (![NSString isEmpty:_roomPrice]) {
      [roomSearchCriteriaDictionary setObject:_roomPrice forKey:kRoomSearch_RequestKey_priceDifference];
    }
    
    // "房间价格"
    [self gotoRoomListActivityWithRoomSearchCriteriaDictionary:roomSearchCriteriaDictionary];
    return;
  } while (NO);
  
  [SVProgressHUD showErrorWithStatus:errorMessage];
}

// "直接搜索房间编号" 按钮
- (IBAction)searchRoomByNumberButtonOnClickListener:(id)sender {
  Intent *intent = [Intent intentWithSpecificComponentClass:[SearchRoomByNumberActivity class]];
  [self startActivity:intent];
}

#pragma mark -
#pragma mark 实现 RadioPopupListDelegate 接口
- (void)radioPopupList:(RadioPopupList *)radioPopupList didSelectRowAtIndex:(NSUInteger)index {
  NSString *value = [radioPopupList objectAtIndex:index];
  switch (radioPopupList.tag) {
      
    case kRadioPopupListTypeTag_Occupancy:{// "入住人数"
      [_occupancyButton setTitle:value forState:UIControlStateNormal];
      
      self.occupancyCount = [[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForOccupancyCountList objectForKey:value];
      
      //
      self.radioPopupListForOccupancyCount = nil;
    }break;
      
    case kRadioPopupListTypeTag_Price:{// "房间价格"
      [_priceButton setTitle:value forState:UIControlStateNormal];
      
      self.roomPrice = [[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForPriceDifferenceList objectForKey:value];
      
      //
      self.radioPopupListForRoomPrice = nil;
    }break;
      
    default:
      break;
  }
}

-(void)closeRadioPopupList:(RadioPopupList *)radioPopupList {
  switch (radioPopupList.tag) {
      
    case kRadioPopupListTypeTag_Occupancy:{// "入住人数"
      //
      self.radioPopupListForOccupancyCount = nil;
    }break;
      
    case kRadioPopupListTypeTag_Price:{// "房间价格"
      //
      self.radioPopupListForRoomPrice = nil;
    }break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark 设置 "入住时间" 和 "退房时间"
static void setDateDetailInfo(NSDate *date, UIButton *button, UILabel *dayLabel, UILabel *monthLabel, UILabel *weekLabel){
  [button setTitle:nil forState:UIControlStateNormal];
  [button setTitle:nil forState:UIControlStateHighlighted];
  
  dayLabel.hidden = NO;
  [dayLabel setText:[[NSNumber numberWithInteger:[date dateComponents].day] stringValue]];
  
  monthLabel.hidden = NO;
  NSString *monthString = [NSString stringWithFormat:@"%d月", [date dateComponents].month];
  [monthLabel setText:monthString];
  
  weekLabel.hidden = NO;
  NSString *weekdayName = [NSDate weekdayChinaName:[date dateComponents].weekday];
  [weekLabel setText:weekdayName];
}

-(void)saveCheckInDateAndUpdateDateControls:(NSDate *)checkInDate{
  setDateDetailInfo(checkInDate, _checkinDateButton, _checkInDateDayLabel, _checkInDateMonthLabel, _checkInDateWeekLabel);
  self.dateForCheckIn = checkInDate;
}
-(void)clearCheckInDate{
  
}
-(void)saveCheckOutDateAndUpdateDateControls:(NSDate *)checkOutDate{
  setDateDetailInfo(checkOutDate, _checkoutDateButton, _checkOutDateDayLabel, _checkOutDateMonthLabel, _checkOutDateWeekLabel);
  self.dateForCheckOut = checkOutDate;
}
-(void)clearCheckOutDate{
  
}
@end
