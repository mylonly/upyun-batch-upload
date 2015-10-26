//
//  ViewController.m
//  RTUpyunBatchUploadDemo
//
//  Created by 田祥根 on 15/10/22.
//  Copyright © 2015年 田祥根. All rights reserved.
//

#import "ViewController.h"
#import "RTUpyunBatchUploader.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView* m_tableView;
    
    NSMutableArray* m_localPaths;
    NSMutableArray* m_serverPaths;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"又拍云批量上传";

    m_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];

    m_localPaths = [[NSMutableArray alloc] init];
    m_serverPaths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <10;i++)
    {
        NSString * url = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"jpg"];
        [m_localPaths addObject:url];
        [m_serverPaths addObject:[NSString stringWithFormat:@"%d.jpg",i]];
    }
    
    UIButton* upload = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [upload setTitle:@"上传" forState:UIControlStateNormal];
    upload.titleLabel.font = [UIFont systemFontOfSize:14];
    [upload addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
    [upload setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:upload];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark ACTION
- (void)uploadAction:(UIButton*)sender
{
    RTUpyunBatchUploader* batch = [[RTUpyunBatchUploader alloc] initWithBucket:@"babyun-stage" andPasscode:@"tFSoUOmw3NkNY6DKmqVnYcTqDaY="];
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
}


#pragma mark tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_localPaths.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",(int)indexPath.row]];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
