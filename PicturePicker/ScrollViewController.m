//
//  ScrollViewController.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/21.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()<UIScrollViewDelegate>

@end

@implementation ScrollViewController {
    UIScrollView *_scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(selectImage)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * _dataDic.allKeys.count, CGRectGetHeight(self.view.frame));
    _scrollView.bounces = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    NSArray *allKeys = _dataDic.allKeys;
    for (int i = 0; i < allKeys.count; i++) {
        NSString *key = (NSString *)allKeys[i];
        UIImage *image = (UIImage *)[_dataDic valueForKey:key];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * i, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        imgView.image = image;
        [_scrollView addSubview:imgView];
    }
    [self.view addSubview:_scrollView];
}


- (void)selectImage {
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"选择"]) {
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
    } else {
        [self.navigationItem.rightBarButtonItem setTitle:@"选择"];
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"___");
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
