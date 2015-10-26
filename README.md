## RTUpyunBatchUploader ##
[Upyun文件批量上传SDK][1]
- 功能介绍
  RTUpyunBatchUploader 是基于又拍云分块上传SDK而开发的批量上传SDK。
  ```
  为什么要开发这个SDK？
    
    因为又拍云官方仅仅提供了单个文件上传的SDK，而在实际使用过程中还是存在多个文件同时上传的情况，使用又拍云官方的SDK过程中会因为既需要管理单个文件的进度，而且也需要总的上传进度，给我们的代码带来很多繁琐的逻辑问题。
  ```
- 使用说明（`因为又拍云的SDK基于AFNetworking,需要项目中提取添加`）
  1. 拷贝目录RTUpyunBatchUpload至工程目录下
  2. 需要使用的文件中包含头文件 `#import "RTUpyunBatchUploader.h"`
  3. 使用上传功能
    ``` objc
    RTUpyunBatchUploader* batch = [[RTUpyunBatchUploader alloc] initWithBucket:@"你的又拍云buket" andPasscode:@"buket对应的passcode"];
    batch.logOn = YES;
    batch.singleProgress = ^(NSString* localPath, float percent)
    {
        NSInteger index = [m_localPaths indexOfObject:localPath];
        UITableViewCell* cell = [m_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.textLabel.text = [NSString stringWithFormat:@"%f",percent];
    };
    [batch uploadFiles:m_localPaths savePaths:m_serverPaths withProgress:^(double precent) {
        self.title = [NSString stringWithFormat:@"总上传进度:%f",precent];
    } withCompleted:^(BOOL success) {
        self.title = @"又拍云批量上传";
    }];
    ``` 
- 更新日志
    1. V1.0.0 基本功能完毕
- 将要做的(TODO)
    1. 添加CocoaPods支持
    2. 基于分块上传开发断点续传功能。


  [1]: https://github.com/mylonly/upyun-batch-upload
