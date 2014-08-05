//
//  AskQuestionController.h
//  gameqa
//
//  Created by user on 12-9-11.
//
//

#import <UIKit/UIKit.h>

#import "RadioPopupList.h"

@interface SearchActivity : Activity <RadioPopupListDelegate>{
  
}

@property (retain, nonatomic) IBOutlet UIButton *cityNameButton;
@property (retain, nonatomic) IBOutlet UIButton *checkinDateButton;
@property (retain, nonatomic) IBOutlet UIButton *checkoutDateButton;
@property (retain, nonatomic) IBOutlet UIButton *occupancyButton;
@property (retain, nonatomic) IBOutlet UIButton *priceButton;

// 入住时间
@property (retain, nonatomic) IBOutlet UILabel *checkInDateDayLabel;
@property (retain, nonatomic) IBOutlet UILabel *checkInDateMonthLabel;
@property (retain, nonatomic) IBOutlet UILabel *checkInDateWeekLabel;

// 退房时间
@property (retain, nonatomic) IBOutlet UILabel *checkOutDateDayLabel;
@property (retain, nonatomic) IBOutlet UILabel *checkOutDateMonthLabel;
@property (retain, nonatomic) IBOutlet UILabel *checkOutDateWeekLabel;



 
@end
