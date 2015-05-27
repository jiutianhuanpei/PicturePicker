//
//  ViedoViewController.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/26.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "ViedoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface ViedoViewController ()

@end

@implementation ViedoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"视频";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteViedo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"d-back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToPhotos)];
    self.navigationItem.leftBarButtonItem = leftItem;
    // Do any additidonal setup after loading the view.
    
    NSLog(@"____%@", _url);
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:_url resultBlock:^(ALAsset *asset) {
        

        
    } failureBlock:^(NSError *error) { }];
    
    
    
    
    
    
}

- (void)deleteViedo {
    if (_flagSelected) {
        _flagSelected(NO);
    }
    [self.navigationController dismissMoviePlayerViewControllerAnimated];
}

- (void)backToPhotos {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
