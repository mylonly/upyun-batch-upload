//
//  RTUpyunBatchUpload.h
//  RTUpyunBatchUploadDemo
//
//  Created by Root on 15/10/22.
//  Copyright © 2015年 www.mylonly.com. All rights reserved.
//
// V1.0 利用Upyun批量上传SDK，实现文件的批量上传
// V2.0 TODO:提供断点续传功能
#import <Foundation/Foundation.h>

@interface RTUpyunBatchUploadManager : NSObject

@property (nonatomic,strong) NSMutableArray* uploadFiles;

+ (instancetype)sharedInstance;

- (void)setup:(NSString*)upyunBuket passcode:(NSString*)upyunPasscode;

@end
