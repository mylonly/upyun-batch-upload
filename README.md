## RTUpyunBatchUploader ##
[Upyun文件批量上传SDK][1]
- 功能介绍
  RTUpyunBatchUploader 是基于又拍云分块上传SDK而开发的批量上传SDK。

- 使用说明（`因为又拍云的SDK基于AFNetworking,需要在项目中提前添加`）
  
  1. 拷贝目录RTUpyunBatchUpload至工程目录下
  2. 需要使用的文件中包含头文件 `#import "RTUpyunBatchUploader.h"`
  3. 使用上传功能
    
    > 如果你仅仅关注文件的整体进度，请使用如下方法
    ```
    RTUpyunBatchUploader* batch = [[RTUpyunBatchUploader alloc] initWithBucket:@"你的又拍云buket" andPasscode:@"buket对应的passcode"];
    batch.logOn = YES;
    [batch uploadFiles:m_localPaths savePaths:m_serverPaths withProgress:^(double precent) {
        self.title = [NSString stringWithFormat:@"总上传进度:%f",precent];
    } withCompleted:^(BOOL success) {
        self.title = @"又拍云批量上传";
    }];
    ``` 
    > 如果你不仅仅需要文件的整体进度，还需要单个文件的进度，请参考下面的代码
    ```
    [m_localPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *  stop) {
        RTUpyunSingleUploader* uploader = [[RTUpyunSingleUploader alloc] initWithFilePath:obj savePath:m_serverPaths[idx] withBucket:@"babyun-stage" withPasscode:@"tFSoUOmw3NkNY6DKmqVnYcTqDaY="];
        if (!m_uploaders) {
            m_uploaders = [[NSMutableArray alloc] init];
        }
        [m_uploaders addObject:uploader];
        uploader.whenProgress = ^(double precent)
        {
            NSLog(@"上传进度:%f",precent);
        };
        uploader.whenCompleted = ^(BOOL success){
            NSLog(@"%@",success?@"上传成功":@"上传失败");
        };
    }];
    RTUpyunBatchUploader* batchUploader = [[RTUpyunBatchUploader alloc] init];
    batchUploader.maxUploading = 2;
    batchUploader.logOn = YES;
    [batchUploader uploadFiles:m_uploaders withProgress:^(double precent) {
        self.title = [NSString stringWithFormat:@"总上传进度:%f",precent];
    } withCompleted:^(BOOL success) {
        self.title = success?@"上传成功":@"上传失败";
    }];
    ```
    
- 更新日志
    1. V1.0.0 基本功能完毕
    2. V1.0.1 增加一种上传方式，可以查看单个文件的进度
- 将要做的(TODO)
    1. 添加CocoaPods支持
    2. 基于分块上传开发断点续传功能。


  [1]: https://github.com/mylonly/upyun-batch-upload
