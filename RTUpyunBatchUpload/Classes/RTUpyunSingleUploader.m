//
//  RTUpyunSingleUploader.m
//  RTUpyunBatchUploadDemo
//
//  Created by 田祥根 on 15/10/22.
//  Copyright © 2015年 田祥根. All rights reserved.
//

#import "RTUpyunSingleUploader.h"
#import "UMUUploaderManager.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"

@interface RTUpyunSingleUploader()
{
    NSData* m_uploadData;
    NSString* m_signature;
    NSString* m_policy;
    
    UMUUploaderOperation* m_operation;
}
@end

@implementation RTUpyunSingleUploader


- (id)initWithBuket:(NSString *)buket withPasscode:(NSString *)passcode
{
    self  = [super init];
    if (self)
    {
        _bucket = buket;
        _passcode = passcode;
    }
    return self;
}

- (id)initWithFilePath:(NSString*)localPath savePath:(NSString*)serverPath withBucket:(NSString *)bucket withPasscode:(NSString *)passcode
{
    self = [super init];
    if (self)
    {
        _bucket = bucket;
        _passcode = passcode;
        self.uploadFileServerPath = serverPath;
        self.uploadFileLocalPath = localPath;
    }
    return self;
}


- (void)setUploadFileLocalPath:(NSString *)uploadFileLocalPath
{
    _uploadFileLocalPath = uploadFileLocalPath;
    m_uploadData = [NSData dataWithContentsOfFile:_uploadFileLocalPath];
    
    NSDictionary * fileInfo = [UMUUploaderManager fetchFileInfoDictionaryWith:m_uploadData];//获取文件信息
    NSDictionary * signaturePolicyDic =[self constructingSignatureAndPolicyWithFileInfo:fileInfo];
    
    m_signature = signaturePolicyDic[@"signature"];
    m_policy = signaturePolicyDic[@"policy"];
    _bucket = signaturePolicyDic[@"bucket"];
}

- (void)runloop
{
    if (_nextState != _state)
    {
        [self changeState:_nextState];
    }
}

- (void)changeState:(RTUPLOADSTATE)newState
{
    if (_state == newState)
    {
        return;
    }
    _state = newState;
    _nextState = newState;
    
    if (RTUPLOADSTATE_CREATED == _state)
    {
        //noting to do
    }
    else if (RTUPLOADSTATE_SENDING == _state)
    {
        [self notifySending];
    }
    else if (RTUPLOADSTATE_WAITING == _state)
    {
        //nothing to do
    }
    else if (RTUPLOADSTATE_SUCCESS == _state)
    {
        [self notifySuccess];
    }
    else if (RTUPLOADSTATE_FAILED == _state)
    {
        [self notifyFailed];
    }
    else if (RTUPLOADSTATE_CANCELED == _state)
    {
        [self notifyCanceled];
    }
    else if (RTUPLOADSTATE_SUSPEND == _state)
    {
        [self notifySuspend];
    }
}

- (void)upload
{
    if (!_isSend)
    {
        [self setNextState:RTUPLOADSTATE_SENDING];
        [[RTUpyunBatchUploadManager sharedInstance] addUploader:self];
    }
}

- (void)notifySending
{
    UMUUploaderManager * manager = [UMUUploaderManager managerWithBucket:_bucket];
    m_operation = [manager uploadWithFile:m_uploadData policy:m_policy signature:m_signature progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
        NSLog(@"%f",percent);
        self.percent = percent;
        if (_whenProgress)
        {
            _whenProgress(percent);
        }
    } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
        NSLog(@"completed");
        [self setNextState:completed?RTUPLOADSTATE_SUCCESS:RTUPLOADSTATE_FAILED];
    }];
    NSLog(@"Uploader Sending....");
    [self setNextState:RTUPLOADSTATE_WAITING];
}

- (void)notifySuccess
{
    if (_whenCompleted)
    {
        _whenCompleted(YES);
    }
    [self setNextState:RTUPLOADSTATE_WAITING];
    [[RTUpyunBatchUploadManager sharedInstance] removeUploader:self];
}

- (void)notifyFailed
{
    if (_whenCompleted)
    {
        _whenCompleted(NO);
    }
    [self setNextState:RTUPLOADSTATE_WAITING];
}

- (void)notifyCanceled
{
    if (_whenCompleted)
    {
        _whenCompleted(NO);
    }
}

- (void)notifySuspend
{
    
}



/**
 *  根据文件信息生成Signature\Policy\bucket (安全起见，以下算法应在服务端完成)
 *
 *  @param paramaters 文件信息
 *
 *  @return
 */
- (NSDictionary *)constructingSignatureAndPolicyWithFileInfo:(NSDictionary *)fileInfo
{
    
    NSString * bucket = _bucket;
    NSString * secret = _passcode;
    
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]initWithDictionary:fileInfo];
    [mutableDic setObject:@(ceil([[NSDate date] timeIntervalSince1970])+60) forKey:@"expiration"];//设置授权过期时间
    [mutableDic setObject:_uploadFileServerPath forKey:@"path"];//设置保存路径
    /**
     *  这个 mutableDic 可以塞入其他可选参数 见：http://docs.upyun.com/api/form_api/#Policy%e5%86%85%e5%ae%b9%e8%af%a6%e8%a7%a3
     */
    NSString * signature = @"";
    NSArray * keys = [mutableDic allKeys];
    keys= [keys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * key in keys) {
        NSString * value = mutableDic[key];
        signature = [NSString stringWithFormat:@"%@%@%@",signature,key,value];
    }
    signature = [signature stringByAppendingString:secret];
    
    return @{@"signature":[signature MD5],
             @"policy":[self dictionaryToJSONStringBase64Encoding:mutableDic],
             @"bucket":bucket};
}

- (NSString *)dictionaryToJSONStringBase64Encoding:(NSDictionary *)dic
{
    id paramesData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:paramesData
                                                 encoding:NSUTF8StringEncoding];
    return [jsonString base64encode];
}


@end
