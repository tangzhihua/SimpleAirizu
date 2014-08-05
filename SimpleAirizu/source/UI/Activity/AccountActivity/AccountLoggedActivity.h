//
//  AccountLoggedController.h
//  gameqa
//
//  Created by user on 12-9-11.
//
//

#import <UIKit/UIKit.h>
 

@interface AccountLoggedActivity : Activity <IDomainNetRespondCallback>{
  
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
//
@property (retain, nonatomic) IBOutlet UIImageView *userPhotoUIImageView;
@property (retain, nonatomic) IBOutlet UILabel *userNameUILabel;
@property (retain, nonatomic) IBOutlet UILabel *userTotalPointUILabel;
//
@property (retain, nonatomic) IBOutlet UILabel *waitConfirmCountUILabel;
@property (retain, nonatomic) IBOutlet UILabel *waitPayCountUILabel;
@property (retain, nonatomic) IBOutlet UILabel *waitLiveCountUILabel;
@property (retain, nonatomic) IBOutlet UILabel *waitReviewCountUILabel;

@end
