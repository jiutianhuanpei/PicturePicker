//
//  ScrollViewController.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/21.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "ScrollViewController.h"
#import "ZoomView.h"
#import "GroupViewController.h"
#import <HexColor.h>

@interface ScrollViewController ()<UIScrollViewDelegate>

@end

@implementation ScrollViewController {
    UIScrollView *_scrollView;
    UIImageView *_imgView;
    UIImage *_image;
    UIView *_containerView;
    UIScrollView *smallView;
    
    NSMutableArray *selectArray;
    NSMutableDictionary *selectDic;
    UILabel *_btnTitle;
    NSArray *myKeys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    selectArray = [[NSMutableArray alloc] initWithCapacity:0];
    selectDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xuanze"] style:UIBarButtonItemStylePlain target:self action:@selector(selectImage)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"d-back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToPhotos)];
    self.navigationItem.leftBarButtonItem = leftItem;
    

    CGFloat maxWidth = CGRectGetWidth(self.view.frame);
    CGFloat maxHeight = CGRectGetHeight(self.view.frame);
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    self.view.contentMode = UIViewContentModeScaleAspectFill;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * _dataDic.allKeys.count, CGRectGetHeight(self.view.frame));
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    
    [self.view addSubview:_scrollView];
    
    NSArray *allKeys = _dataDic.allKeys;
    myKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, maxHeight - 49, maxWidth, 49)];
    toolView.backgroundColor = [UIColor colorWithHexString:@"413f55"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"yuan"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(maxWidth - 100, 0, 100, 49);
    [btn addTarget:self action:@selector(sendImage) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:btn];
    
    _btnTitle = [[UILabel alloc] initWithFrame:btn.imageView.bounds];
    _btnTitle.textAlignment = NSTextAlignmentCenter;
    _btnTitle.textColor = [UIColor whiteColor];
    _btnTitle.font = [UIFont systemFontOfSize:11];
    _btnTitle.text = [NSString stringWithFormat:@"%lu", (unsigned long)allKeys.count];
    [btn.imageView addSubview:_btnTitle];
    
    [self.view addSubview:toolView];


    for (int i = 0; i < allKeys.count; i++) {
        [selectArray addObject:@1];
        UIImage *image = (UIImage *)[_dataDic valueForKey:myKeys[i]];
        ZoomView *view = [[ZoomView alloc] initWithFrame:CGRectMake(maxWidth * i, 0, maxWidth, maxHeight)];
        view.image = image;
        view.singleClicked = ^(){
            if (toolView.hidden == YES) {
                self.navigationController.navigationBar.hidden = NO;
                toolView.hidden = NO;
            } else {
                self.navigationController.navigationBar.hidden = YES;
                toolView.hidden = YES;
            }
        };
        [view updateImage:image];
        [_scrollView addSubview:view];
    }

    
}

//获取图片和显示视图宽度的比例系数
- (float)getImgWidthFactor:(UIImage *)image {
    return   self.view.bounds.size.width / image.size.width;
}
//获取图片和显示视图高度的比例系数
- (float)getImgHeightFactor:(UIImage *)image {
    return  self.view.bounds.size.height / image.size.height;
}

//获获取尺寸
- (CGSize)newSizeByoriginalSize:(CGSize)oldSize maxSize:(CGSize)mSize image:(UIImage *)image
{
    if (oldSize.width <= 0 || oldSize.height <= 0) {
        return CGSizeZero;
    }
    
    CGSize newSize = CGSizeZero;
    if (oldSize.width > mSize.width || oldSize.height > mSize.height) {
        //按比例计算尺寸
        float bs = [self getImgWidthFactor:image];
        float newHeight = oldSize.height * bs;
        newSize = CGSizeMake(mSize.width, newHeight);
        
        if (newHeight > mSize.height) {
            bs = [self getImgHeightFactor:image];
            float newWidth = oldSize.width * bs;
            newSize = CGSizeMake(newWidth, mSize.height);
        }
    }else {
        
        newSize = oldSize;
    }
    return newSize;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger i = scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
    NSNumber *count = selectArray[i];
    switch ([count integerValue]) {
        case 0: {
            self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"weixuan"];
            break;
        }
        case 1: {
            self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"xuanze"];
            break;
        }
        default:
            break;
    }
    
}



- (void)selectImage {
    NSInteger i = _scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
    if (![selectArray[i] integerValue]) {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"xuanze"];
        selectArray[i] = @1;
    } else {
        selectArray[i] = @0;
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"weixuan"];
    }
    
    int count = 0;
    for (NSNumber *num in selectArray) {
        if ([num integerValue]) {
            count++;
        }
    }
    _btnTitle.text = [NSString stringWithFormat:@"%d", count];
}

- (void)sendImage {

    for (int i = 0; i < selectArray.count; i++) {
        NSNumber *count = selectArray[i];
        
        
        NSString *key = myKeys[i];
        if (![count integerValue]) {
            [selectDic setObject:@0 forKey:key];
        }
    }
    if (_selectedDic) {
        _selectedDic(selectDic);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
}

- (void)backToPhotos {
    [self.navigationController popViewControllerAnimated:YES];
}

@end


