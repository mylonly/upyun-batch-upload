//
//  RTUpyunBatchUploader.m
//  RTUpyunBatchUploadDemo
//
//  Created by mylonly on 15/10/23.
//  Copyright © 2015年 田祥根. All rights reserved.
//

#import "RTUpyunBatchUploader.h"

@interface RTUpyunBatchUploader()
{
    
}
@end

@implementation RTUpyunBatchUploader

- (void)uploadFiles:(NSArray *)uploaders withProgress:(UploadProgressBlock)totalProgress withCompleted:(UploadCompletedBlock)totalCompleted
{
    __block NSMutableDictionary* progressDict = [[NSMutableDictionary alloc] init];
    dispatch_group_t uploadGroup = dispatch_group_create();
    __block BOOL totalSuccess = YES;
    for (RTUpyunSingleUploader* uploader in uploaders)
    {
        dispatch_group_enter(uploadGroup);
        __weak RTUpyunSingleUploader* uploaderSelf = uploader;

        UploadProgressBlock progress = uploader.whenProgress;
        uploader.whenProgress = ^(double precent){
            
            [progressDict setValue:[NSNumber numberWithDouble:precent] forKey:uploaderSelf.uploadFileLocalPath];
            double totalPrecent = 0.f;
            for (NSNumber* number in progressDict.allValues)
            {
                totalPrecent+= [number doubleValue];
            }
            if (progress)
            {
                progress(precent);
            }
            if (totalProgress)
            {
                totalProgress(totalPrecent/uploaders.count);
            }
            if (_logOn)
            {
                NSLog(@"BatchUploader --> totoal percent: %f",(float)totalPrecent);
            }
        };
        
        UploadCompletedBlock completed = uploader.whenCompleted;
        uploader.whenCompleted = ^(BOOL success)
        {
            if (_logOn)
            {
                NSLog(@"BatchUploader --> %@",success?@"success":@"failed");
            }
            dispatch_group_leave(uploadGroup);
            if (completed)
            {
                completed(success);
            }
            if (!success)
            {
                totalSuccess = NO;
            }
        };
        [uploader upload];
    }
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (_logOn)
        {
            NSLog(@"BatchUploader --> total completed");
        }
        if (totalCompleted) {
            totalCompleted(totalSuccess);
        }
    });

}

- (void)uploadFiles:(NSArray *)localPaths savePaths:(NSArray*)serverPaths withProgress:(UploadProgressBlock)progress withCompleted:(UploadCompletedBlock)completed withBucket:(NSString *)bucket withPasscode:(NSString *)passcode
{
    if (localPaths.count != serverPaths.count )
    {
        NSLog(@"%@:Error:localPaths和ServerPaths不匹配",[self class]);
        return;
    }
    
    if (_logOn)
    {
        NSLog(@"BatchUploader --> 共%d个文件",(int)localPaths.count);
    }
    
    __block NSMutableDictionary* progressDict = [[NSMutableDictionary alloc] initWithCapacity:localPaths.count];
    __block BOOL totalSuccess = YES;
    dispatch_group_t uploadGroup = dispatch_group_create();
    for (int i = 0;i < localPaths.count;i++)
    {
        NSString* localPath = [localPaths objectAtIndex:i];
        NSString* serverPath = [serverPaths objectAtIndex:i];
        dispatch_group_enter(uploadGroup);
        RTUpyunSingleUploader* uploader = [[RTUpyunSingleUploader alloc] initWithFilePath:localPath savePath:serverPath withBucket:bucket withPasscode:passcode];
        
        uploader.whenCompleted = ^(BOOL success)
        {
            if (_logOn)
            {
                NSLog(@"BatchUploader --> %@",success?@"success":@"failed");
            }
            dispatch_group_leave(uploadGroup);
            if (!success) {
                totalSuccess = NO;
            }
        };
        uploader.whenProgress = ^(double precent)
        {
            [progressDict setValue:[NSNumber numberWithDouble:precent] forKey:localPath];
            double totalProgress = 0.f;
            for (NSNumber* number in progressDict.allValues)
            {
                totalProgress+= [number doubleValue];
            }
            if (progress)
            {
                progress(totalProgress/localPaths.count);
            }
            
            if (_logOn)
            {
                NSLog(@"BatchUploader --> totoal percent: %f",(float)totalProgress);
            }
        };
        [uploader upload];
    }
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (_logOn)
        {
            NSLog(@"BatchUploader --> totoal completed");
        }
        if (completed) {
            completed(totalSuccess);
        }
    });
}


@end
