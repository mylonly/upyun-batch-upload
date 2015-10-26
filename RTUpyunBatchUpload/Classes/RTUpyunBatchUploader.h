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

//是否开启日志
@property (nonatomic,assign) BOOL logOn;

//最大同时上传数量
@property (nonatomic,assign) NSInteger maxUploading;



/**
 *  构造RTUpyunSingleUploader 数组来完成上传
 *
 *  @param uploaders 需要上传的uploader数组
 *  @param totalProgress 整体上传进度
 *  @param totalCompleted 整体全部完成
 */
- (void)uploadFiles:(NSArray*)uploaders
       withProgress:(UploadProgressBlock)totalProgress
      withCompleted:(UploadCompletedBlock)totalCompleted;


/**
 *  简便上传函数，当不需要关注单个文件的上传进度时使用
 *
 *  @param localPaths  上传文件的本地路径
 *  @param serverPaths 服务器存放路径，需要和localPaths一一对应
 *  @param progress    整体上传进度回调
 *  @param completed   全部上传完成回调
 *  @param bucket      bucket名称
 *  @param passcode    bucket对应的passcode
 */
- (void)uploadFiles:(NSArray*)localPaths
          savePaths:(NSArray*)serverPaths
       withProgress:(UploadProgressBlock)progress
      withCompleted:(UploadCompletedBlock)completed
         withBucket:(NSString*)bucket
       withPasscode:(NSString*)passcode;


@end
