//
//  RTUpyunBatchUpload.m
//  RTUpyunBatchUploadDemo
//
//  Created by 田祥根 on 15/10/22.
//  Copyright © 2015年 田祥根. All rights reserved.
//

#import "RTUpyunBatchUploadManager.h"

#define	DEFAULT_RUNLOOP_INTERVAL	(0.01f)


@interface RTUpyunBatchUploadManager()
{
    NSString* m_buket;
    NSString* m_passcode;
    
    dispatch_queue_t m_uploadQueue;
    NSTimer* m_timer;
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
        if(nil == m_timer)
        {
            m_timer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_RUNLOOP_INTERVAL
                                                       target:self
                                                     selector:@selector(runloop)
                                                     userInfo:nil
                                                      repeats:YES];
        }
        if (nil == _uploadQueues) {
            _uploadQueues = [[NSMutableArray alloc] init];
        }
        _maxUploading = 2;
        
    }
    return self;
}



- (void)setup:(NSString *)upyunBuket passcode:(NSString *)upyunPasscode
{
    m_buket = upyunBuket;
    m_passcode = upyunPasscode;
}

- (void)runloop
{
    
    NSArray* array =[_uploadQueues subarrayWithRange:NSMakeRange(0, _uploadQueues.count > _maxUploading?_maxUploading:_uploadQueues.count)];
    for (RTUpyunSingleUploader* uploader in array)
    {
        [uploader runloop];
    }
}

- (void)addUploader:(RTUpyunSingleUploader*)uploader
{
    if (![_uploadQueues containsObject:uploader]) {
        [_uploadQueues addObject:uploader];
    }
}

- (void)removeUploader:(RTUpyunSingleUploader *)uploader
{
    if ([_uploadQueues containsObject:uploader]) {
        [_uploadQueues removeObject:uploader];
    }
}


@end
