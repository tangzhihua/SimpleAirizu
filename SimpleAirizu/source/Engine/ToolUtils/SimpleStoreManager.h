//
//  StoreManager.h
//  MBEnterprise
//
//  Created by Yingjie Huo on 13-7-26.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void (^SimpleStoreManagerCompletionBlock)(NSData* purchasedReceipt);
typedef void (^SimpleStoreManagerFailedBlock)(NSString *message);
typedef void (^SimpleStoreManagerCancelBlock)(void);

@interface SimpleStoreManager : NSObject<SKPaymentTransactionObserver, SKProductsRequestDelegate>

+ (SimpleStoreManager *)sharedInstance;

// use this method to start a purchase
- (void) buyProductWithIdentifier:(NSString *) productId
                       onComplete:(SimpleStoreManagerCompletionBlock) completionBlock
                         onFailed:(SimpleStoreManagerFailedBlock) failedBlock
                      onCancelled:(SimpleStoreManagerCancelBlock) cancelBlock;
@end
