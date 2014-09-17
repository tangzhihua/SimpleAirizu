//
//  StoreManager.m
//  MBEnterprise
//
//  Created by Yingjie Huo on 13-7-26.
//
//

#import "SimpleStoreManager.h"

@interface MyProduct : NSObject
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, strong) SimpleStoreManagerCompletionBlock completionBlock;
@property (nonatomic, strong) SimpleStoreManagerFailedBlock failedBlock;
@property (nonatomic, strong) SimpleStoreManagerCancelBlock cancelBlock;
@end

@implementation MyProduct
@end


@interface SimpleStoreManager () <SKPaymentTransactionObserver, SKProductsRequestDelegate>
@property (nonatomic, strong) NSMutableDictionary *productList;
@end

@implementation SimpleStoreManager





#pragma mark - SKPaymentTransactionObserver Delegate
// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
// called when the transaction status is updated
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
  for (SKPaymentTransaction *transaction in transactions) {
    
    switch (transaction.transactionState) {
      case SKPaymentTransactionStatePurchasing:
        
        break;
      case SKPaymentTransactionStatePurchased:// 交易成功，这时已经扣完钱，我们要保证将商品发送给用户
        [self completeTransaction:transaction];
        break;
        
      case SKPaymentTransactionStateFailed:// 交易失败，原因很多（可以通过SKPaymentTransaction.error.code来查看具体失败原因），最常见的是SKErrorPaymentCancelled（用户取消交易），或是未输入合法的itunes id
        [self failedTransaction:transaction];
        break;
        
      case SKPaymentTransactionStateRestored:// 非消耗性商品已经购买过，这时我们要按交易成功来处理。
        [self restoreTransaction:transaction];
        break;
        
        
        
      default:
        NSAssert(0, @"错误的处理状态");
        break;
    }
  }
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
  for (SKPaymentTransaction *transaction in transactions) {
    if (transaction.transactionState != SKPaymentTransactionStatePurchased) {
      [[NSNotificationCenter defaultCenter] postNotificationName:transaction.payment.productIdentifier object:self];
    }
  }
}


#pragma - Purchase helpers

// called when the transaction was successful
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
  MyProduct *product = _productList[transaction.payment.productIdentifier];
  if (product != nil) {
    if (product.completionBlock != NULL) {
      product.completionBlock(transaction.transactionReceipt);
    }
    
    [_productList removeObjectForKey:product.productId];
  }
  
  // remove the transaction from the payment queue.
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// called when a transaction has been restored and and successfully completed
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
  MyProduct *product = _productList[transaction.originalTransaction.payment.productIdentifier];
  if (product != nil) {
    if (product.completionBlock != NULL) {
      product.completionBlock(transaction.originalTransaction.transactionReceipt);
    }
    
    [_productList removeObjectForKey:product.productId];
  }
  
  // remove the transaction from the payment queue.
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// called when a transaction has failed
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
  MyProduct *product = _productList[transaction.payment.productIdentifier];
  if (product != nil) {
    if (transaction.error.code == SKErrorPaymentCancelled) {
      if (product.cancelBlock != NULL) {
        product.cancelBlock();
      }
    } else {
      // 在这里显示除用户取消之外的错误信息
      if (product.failedBlock != NULL) {
        product.failedBlock(transaction.error.localizedDescription);
      }
    }
    
    [_productList removeObjectForKey:product.productId];
  }
  
  // remove the transaction from the payment queue.
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark -
#pragma mark 单例方法群
// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
-(id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

// 真正的(私有)init方法
-(id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
    _productList = [[NSMutableDictionary alloc] initWithCapacity:10];
  }
  
  return self;
}
+ (SimpleStoreManager *)sharedInstance {
  static SimpleStoreManager *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

#pragma mark -
#pragma mark 对外接口
- (void)buyProductWithIdentifier:(NSString *)productId
                      onComplete:(SimpleStoreManagerCompletionBlock)completionBlock
                        onFailed:(SimpleStoreManagerFailedBlock)failedBlock
                     onCancelled:(SimpleStoreManagerCancelBlock)cancelBlock {
  
  @synchronized(self) {
    if (_productList[productId] != nil) {
      // 重复发起同一商品的交易请求
      if (failedBlock != NULL) {
        failedBlock(@"已经有同一商品在交易中, 请不要重复发起交易请求.");
      }
      return;
    }
    
    if (![SKPaymentQueue canMakePayments]) {
      // NO if this device is not able or allowed to make payments
      if (failedBlock != NULL) {
        failedBlock(@"您的设备不支持应用内付费购买.");
      }
      return;
    }
    
    MyProduct *product = [[MyProduct alloc] init];
    product.productId = productId;
    product.completionBlock = completionBlock;
    product.failedBlock = failedBlock;
    product.cancelBlock = cancelBlock;
    
    // 缓存新的产品对象
    _productList[productId] = product;
    
    // 用来请求商品的信息。 创建时，我们将需要显示的商品列表加入该对象。
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:productId, nil]];
    productsRequest.delegate = self;
    [productsRequest start];
  }
}

#pragma mark - SKProductsRequest Delegate methods
// Sent immediately before -requestDidFinish:
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
  @synchronized(self) {
    
    // -------------     SKProduct对象包含了在App Store上注册的商品的本地化信息。
    // localizedDescription  商品描述
    // localizedTitle  商品名称
    // price  商品单价
    // priceLocale  币种(The locale used to format the price of the product.)
    // productIdentifier  商品ID
    // --------------------------------------------------------
    
    // 有效的产品
    // Array of SKProduct instances.
    for (SKProduct *product in response.products) {
      // 创建一个支付对象, 放入队列中
      SKPayment *payment = [SKPayment paymentWithProduct:product];
      [[SKPaymentQueue defaultQueue] addPayment:payment];
      
      // 如果你的商店支持选择同一件商品的数量，你可以使用SKMutablePayment对象, 设置支付对象的quantity属性
      //SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
      //payment.quantity = ?;
      
      PRPLog(@"------------------------    SKProduct    ------------------------");
      PRPLog(@"localizedTitle=%@", product.localizedTitle);
      PRPLog(@"localizedDescription=%@", product.localizedDescription);
      PRPLog(@"price=%@", [product.price description]);
      PRPLog(@"priceLocale=%@", [product.priceLocale description]);
      PRPLog(@"localizedDescription=%@", product.localizedDescription);
      PRPLog(@"------------------------    SKProduct    ------------------------");
    }
    
    // 无效的产品
    // Array of invalid product identifiers.
    for (NSString *invalidProductId in response.invalidProductIdentifiers) {
      // 请求失败的产品标识
      MyProduct *invalidProduct = _productList[invalidProductId];
      if (invalidProduct != nil) {
        if (invalidProduct.failedBlock != NULL) {
          invalidProduct.failedBlock([NSString stringWithFormat:@"商品ID=%@ 无效.", invalidProductId]);
          [_productList removeObjectForKey:invalidProductId];
        }
      }
    }
  }
  
}
@end

