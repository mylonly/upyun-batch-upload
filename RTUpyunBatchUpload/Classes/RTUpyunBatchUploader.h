//
//  RTUpyunBatchUploader.h
//  RTUpyunBatchUploadDemo
//
//  Created by mylonly on 15/10/23.
//  Copyright © 2015年 田祥根. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTUpyunSingleUploader.h"

typedef void (^RTProgressBlock)(NSString* localPath,float precent);

@interface RTUpyunBatchUploader : NSObject

@property (nonatomic,copy) RTProgressBlock singleProgress;

@property (nonatomic,assign) BOOL logOn;

@property (nonatomic,assign) NSInteger maxUpload; //最大同时上传数量

- (id)initWithBucket:(NSString*)bucket andPasscode:(NSString*)passcode;

- (void)uploadFiles:(NSArray*)localPaths
          savePaths:(NSArray*)serverPaths
       withProgress:(UploadProgressBlock)progress
      withCompleted:(UploadCompletedBlock)completed;

@end
