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

@interface GroupViewController ()

@end

@implementation GroupViewController {
    NSArray *names;
    NSDictionary *thums;
    NSDictionary *counts;
    
    NSMutableArray *_dataArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"照片";
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
    
    Picker *picker = [Picker sharedPicker];
    [picker getAllMedias];
    picker.didSomeSth = ^(NSArray *groupNames, NSDictionary *thumDic, NSDictionary *countDic){
        names = [[NSArray alloc] initWithArray:groupNames];
        thums = [[NSDictionary alloc] initWithDictionary:thumDic];
        counts = [[NSDictionary alloc] initWithDictionary:countDic];
        
        for (int i = 0; i < groupNames.count; i++) {
            NSString *name = groupNames[i];
            TableModel *model = [[TableModel alloc] init];
            model.name = name;
            model.image = (UIImage *)thumDic[name];
            model.count = [NSString stringWithFormat:@"%@", countDic[name]];
            [_dataArray addObject:model];
            
        }
        
        [self.tableView reloadData];
    };
    
    
    

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
