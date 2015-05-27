//
//  GroupViewController.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/22.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "GroupViewController.h"
#import "Picker.h"
#import "TableViewCell.h"
#import <SVProgressHUD.h>

@interface GroupViewController ()

@end

@implementation GroupViewController {
    
    NSMutableArray *_dataArray;
    NSDictionary *_dataDic; //分组内图片 groupName : images
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"照片";
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _dataDic = [[NSDictionary alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
    
    [SVProgressHUD show];
    Picker *picker = [Picker sharedPicker];
//    [picker getAllMedias];
    picker.didSomeSth = ^(NSArray *groupNames, NSDictionary *thumDic, NSDictionary *countDic, NSDictionary *detailImgDic){
        _dataDic = detailImgDic;
        for (int i = 0; i < groupNames.count; i++) {
            NSString *name = groupNames[i];
            TableModel *model = [[TableModel alloc] init];
            model.name = name;
            model.image = (UIImage *)thumDic[name];
            model.count = [NSString stringWithFormat:@"%@", countDic[name]];
            [_dataArray addObject:model];
        }
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    };
}

- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class]) forIndexPath: indexPath];
    TableModel *model = _dataArray[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TableModel *model = _dataArray[indexPath.row];
    NSString *key = model.name;
    NSDictionary *imgUrls = _dataDic[key];
    if (_detailData) {
        _detailData(imgUrls);
    }
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
