//
//  RTUpyunBatchUpload.m
//  RTUpyunBatchUploadDemo
//
//  Created by 田祥根 on 15/10/22.
//  Copyright © 2015年 田祥根. All rights reserved.
//

#import "RTUpyunBatchUploadManager.h"

@interface RTUpyunBatchUploadManager()
{
    NSString* m_buket;
    NSString* m_passcode;
    
    dispatch_queue_t m_uploadQueue;
}
@end

@implementation RTUpyunBatchUploadManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        m_uploadQueue = dispatch_queue_create("com.upyun.upload", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)setup:(NSString *)upyunBuket passcode:(NSString *)upyunPasscode
{
    m_buket = upyunBuket;
    m_passcode = upyunPasscode;
}



@end
