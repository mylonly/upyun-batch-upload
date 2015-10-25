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
    
    NSMutableArray* m_testImagesPath;
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

    m_testImagesPath = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <4;i++)
    {
        NSString * url = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"jpg"];
        [m_testImagesPath addObject:url];
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
    NSArray* serverPaths = @[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg"];
    RTUpyunBatchUploader* batch = [[RTUpyunBatchUploader alloc] initWithBucket:@"babyun-stage" andPasscode:@"tFSoUOmw3NkNY6DKmqVnYcTqDaY="];
    [batch uploadFiles:m_testImagesPath savePaths:serverPaths withProgress:^(double precent) {
        self.title = [NSString stringWithFormat:@"上传进度:%f",precent];
    } withCompleted:^(BOOL success) {
        self.title = @"又拍云批量上传";
    }];
}


#pragma mark tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_testImagesPath.count;
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
