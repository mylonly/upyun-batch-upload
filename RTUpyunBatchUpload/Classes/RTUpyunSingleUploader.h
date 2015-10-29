//
//  RTUpyunSingleUploader.h
//  RTUpyunBatchUploadDemo
//
//  Created by 田祥根 on 15/10/22.
//  Copyright © 2015年 田祥根. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    RTUPLOADSTATE_CREATED = 0,  //创建
    RTUPLOADSTATE_SENDING = 1,  //发送
    RTUPLOADSTATE_SUSPEND = 2,  //暂停
    RTUPLOADSTATE_WAITING = 3,  //等待
    RTUPLOADSTATE_SUCCESS = 4,  //成功
    RTUPLOADSTATE_FAILED  = 5,  //失败
    RTUPLOADSTATE_CANCELED = 6, //取消
}RTUPLOADSTATE;

typedef void (^UploadCompletedBlock)(BOOL success);
typedef void (^UploadProgressBlock)(double precent);

@interface RTUpyunSingleUploader : NSObject

@property (nonatomic,assign) BOOL isSend;   //已被发送

@property (nonatomic,assign) BOOL logOn;    //开启日志

@property (nonatomic,assign) float percent; //百分比

@property (nonatomic,strong) NSString* uploadFileLocalPath;

@property (nonatomic,strong) NSString* uploadFileServerPath;

@property (nonatomic,strong,readonly) NSString* bucket;

@property (nonatomic,strong,readonly) NSString* passcode;

@property (nonatomic,assign) RTUPLOADSTATE state;

@property (nonatomic,assign) RTUPLOADSTATE nextState;

@property (nonatomic,copy) UploadCompletedBlock whenCompleted;

@property (nonatomic,copy) UploadProgressBlock whenProgress;

- (id)initWithFilePath:(NSString*)localPath
              savePath:(NSString*)serverPath
            withBucket:(NSString*)bucket
          withPasscode:(NSString*)passcode;

- (void)runloop;

- (void)upload;


@end
