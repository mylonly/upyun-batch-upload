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
    NSString* m_bucket;
    NSString* m_passcode;
    
}
@end

@implementation RTUpyunBatchUploader

- (id)initWithBucket:(NSString *)bucket andPasscode:(NSString *)passcode
{
    self = [super init];
    if (self)
    {
        m_bucket = bucket;
        m_passcode = passcode;
    }
    return self;
}

- (void)uploadFiles:(NSArray *)localPaths savePaths:(NSArray*)serverPaths withProgress:(UploadProgressBlock)progress withCompleted:(UploadCompletedBlock)completed
{
    if (localPaths.count != serverPaths.count )
    {
        NSLog(@"%@:Error:localPaths和ServerPaths不匹配",[self class]);
        return;
    }
    
    __block NSMutableDictionary* progressDict = [[NSMutableDictionary alloc] init];
    dispatch_group_t uploadGroup = dispatch_group_create();
    for (int i = 0;i < localPaths.count;i++)
    {
        NSString* localPath = [localPaths objectAtIndex:i];
        NSString* serverPath = [serverPaths objectAtIndex:i];
        dispatch_group_enter(uploadGroup);
        NSLog(@"enter_gourp");
        RTUpyunSingleUploader* uploader = [[RTUpyunSingleUploader alloc] initWithFilePath:localPath savePath:serverPath withBucket:m_bucket withPasscode:m_passcode];
        uploader.whenCompleted = ^(BOOL success)
        {
            dispatch_group_leave(uploadGroup);
            NSLog(@"leave_gourp");
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
                progress(totalProgress/progressDict.allKeys.count);
            }
        };
        [uploader upload];
    }
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (completed) {
            completed(YES);
        }
    });
}

@end
