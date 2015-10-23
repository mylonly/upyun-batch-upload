//
//  RTUpyunBatchUploader.h
//  RTUpyunBatchUploadDemo
//
//  Created by mylonly on 15/10/23.
//  Copyright © 2015年 田祥根. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTUpyunSingleUploader.h"

@interface RTUpyunBatchUploader : NSObject

- (id)initWithBucket:(NSString*)bucket andPasscode:(NSString*)passcode;

- (void)uploadFiles:(NSArray*)localPaths
          savePaths:(NSArray*)serverPaths
       withProgress:(UploadProgressBlock)progress
      withCompleted:(UploadCompletedBlock)completed;

@end
