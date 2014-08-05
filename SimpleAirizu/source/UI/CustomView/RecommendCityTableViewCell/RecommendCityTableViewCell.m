//
//  RecommendCityTableViewCellViewController.m
//  airizu
//
//  Created by 唐志华 on 12-12-26.
//
//

#import "RecommendCityTableViewCell.h"
#import "RecommendCity.h"


static const NSString *const TAG = @"<RecommendCityTableViewCell>";

@interface RecommendCityTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *street1NameButton;
@property (weak, nonatomic) IBOutlet UIButton *street2NameButton;
@property (weak, nonatomic) IBOutlet UIImageView *cityPhotoImageView;

@property (nonatomic, strong) MKNetworkOperation *imageNetOperation;
@end

@implementation RecommendCityTableViewCell


+ (void)initialize {
	if(self == [RecommendCityTableViewCell class]) {
    
	}
}


- (void)bind:(id)data {
  [super bind:data];
  
  RecommendCity *recommendCity = data;
  _cityNameLabel.text = recommendCity.cityName;
  [_street1NameButton setTitle:recommendCity.street1Name forState:UIControlStateNormal];
  [_street2NameButton setTitle:recommendCity.street2Name forState:UIControlStateNormal];
  
  // 推荐城市的照片
  if (![NSString isEmpty:recommendCity.image]) {
    NSURL *urlOfBookCoverImage = [NSURL URLWithString:recommendCity.image];
    _imageNetOperation = [_cityPhotoImageView setImageFromURL:urlOfBookCoverImage placeHolderImage:nil];
  }
}
- (void)unBind {
  if (super.data == nil) {
    // 还未绑定过数据
    return;
  }
  
  //
  [_imageNetOperation cancel], _imageNetOperation = nil;
  _cityPhotoImageView.image = nil;

  //
  
  [super unBind];
}

@end
