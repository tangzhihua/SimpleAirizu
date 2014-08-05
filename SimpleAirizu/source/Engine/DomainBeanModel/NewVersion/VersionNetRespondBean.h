//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>

@interface VersionNetRespondBean : NSObject

@property (nonatomic, readonly, copy) NSString *latestVersion;
@property (nonatomic, readonly, copy) NSString *fileSize;
@property (nonatomic, readonly, copy) NSString *updateContent;
@property (nonatomic, readonly, copy) NSString *downloadAddress;

+ (id)versionNetRespondBeanWithNewVersion:(NSString *)latestVersion
                              andFileSize:(NSString *)fileSize
                         andUpdateContent:(NSString *)updateContent
                       andDownloadAddress:(NSString *)downloadAddress;
@end