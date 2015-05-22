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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    selectArray = [[NSMutableArray alloc] initWithCapacity:0];
    selectDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(selectImage)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(goToGroup)];
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
    NSArray *myKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (int i = 0; i < allKeys.count; i++) {
        [selectArray addObject:@1];
        
        UIImage *image = (UIImage *)[_dataDic valueForKey:myKeys[i]];
        
        ZoomView *view = [[ZoomView alloc] initWithFrame:CGRectMake(maxWidth * i, 0, maxWidth, maxHeight)];
        view.image = image;
        [view updateImage:image];
        [_scrollView addSubview:view];
     
    }
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, maxHeight - 49, maxWidth, 49)];
    toolView.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"Send" forState:UIControlStateNormal];
    btn.frame = CGRectMake(maxWidth - 100, 0, 100, 49);
    [btn addTarget:self action:@selector(sendImage) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:btn];
    [self.view addSubview:toolView];
    
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

#pragma mark- 手势事件
//单击 / 双击 手势
- (void)TapsAction:(UITapGestureRecognizer *)tap
{
    NSInteger tapCount = tap.numberOfTapsRequired;
    if (2 == tapCount) {
        //双击
        NSLog(@"双击");
        if (_scrollView.minimumZoomScale <= _scrollView.zoomScale && _scrollView.maximumZoomScale > _scrollView.zoomScale) {
            [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
        }else {
            [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
        }
        
    }else if (1 == tapCount) {
        //单击
        NSLog(@"单击");

        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger i = scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
    NSNumber *count = selectArray[i];
    switch ([count integerValue]) {
        case 0: {
            [self.navigationItem.rightBarButtonItem setTitle:@"选择"];
            break;
        }
        case 1: {
            [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
            break;
        }
        default:
            break;
    }
    
}



- (void)selectImage {
    NSInteger i = _scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"选择"]) {
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        selectArray[i] = @1;
    } else {
        selectArray[i] = @0;
        [self.navigationItem.rightBarButtonItem setTitle:@"选择"];
    }
}

- (void)sendImage {
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < selectArray.count; i++) {
        
        NSInteger i = _scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
        NSNumber *count = selectArray[i];
        NSArray *allKeys = _dataDic.allKeys;
        if ([count integerValue]) {
            NSString *key = allKeys[i];
            UIImage *image = (UIImage *)_dataDic[key];
            [tempArray addObject:image];
        }
        _images = [NSArray arrayWithArray:tempArray];
    }
    if (_selectedImages) {
        _selectedImages(_images);
    }
}

- (void)goToGroup {
    for (int i = 0; i < selectArray.count; i++) {
        NSInteger i = _scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
        NSNumber *count = selectArray[i];
        NSArray *allKeys = _dataDic.allKeys;
        NSString *key = allKeys[i];
        if (![count integerValue]) {
            [selectDic setObject:_dataDic[key] forKey:key];
        }
        if (_selectedDic) {
            _selectedDic(selectDic);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end


