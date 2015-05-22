//
//  ZoomView.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/22.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "ZoomView.h"

#define HandDoubleTap 2
#define HandOneTap 1
#define MaxZoomScaleNum 5.0
#define MinZoomScaleNum 1.0

@interface ZoomView ()<UIScrollViewDelegate>

@end

@implementation ZoomView {
    UIScrollView *_scrollView;
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        [_scrollView addSubview:_containerView];
        
        [self addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_containerView addSubview:_imageView];
        
        //双击
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(TapsAction:)];
        [doubleTapGesture setNumberOfTapsRequired:HandDoubleTap];
        [_containerView addGestureRecognizer:doubleTapGesture];
        
        //单击
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(TapsAction:)];
        [tapGesture setNumberOfTapsRequired:HandOneTap];
        [_containerView addGestureRecognizer:tapGesture];
        
        //双击失败之后执行单击
        [tapGesture requireGestureRecognizerToFail:doubleTapGesture];


        _scrollView.maximumZoomScale = MaxZoomScaleNum;
        _scrollView.minimumZoomScale = MinZoomScaleNum;
        _scrollView.zoomScale = MinZoomScaleNum;

        
        
    }
    return self;
}

#pragma mark- 手势事件
//单击 / 双击 手势
- (void)TapsAction:(UITapGestureRecognizer *)tap
{
    NSInteger tapCount = tap.numberOfTapsRequired;
    if (HandDoubleTap == tapCount) {
        //双击
        NSLog(@"双击");
        if (_scrollView.minimumZoomScale <= _scrollView.zoomScale && _scrollView.maximumZoomScale > _scrollView.zoomScale) {
            [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
        }else {
            [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
        }
        
    }else if (HandOneTap == tapCount) {
        //单击
        NSLog(@"单击");
        //        NSLog(@"imgUrl: %@, imgSize:(%f, %f) zoomScale:%f",downImgUrl,self.imageView.frame.size.width,self.imageView.frame.size.height,_scrollView.zoomScale);
        
    }
}


- (void)resetViewFrame:(CGRect)newFrame
{
    self.frame = newFrame;
    _scrollView.frame = self.bounds;
    _containerView.frame = self.bounds;
}

- (void)updateImage:(UIImage *)image {
    _scrollView.scrollEnabled = YES;
    self.image = image;
    [self setImageViewWithImg:self.image];
}

- (void)setImageViewWithImg:(UIImage *)img {
    _scrollView.scrollEnabled = YES;
    
    _imageView.image = img;
    CGSize showSize = [self newSizeByoriginalSize:img.size maxSize:self.bounds.size];
    _imageView.frame = CGRectMake(0, 0, showSize.width, showSize.height);
    
    _scrollView.zoomScale = 1;
    _scrollView.contentOffset = CGPointZero;
    _containerView.bounds = _imageView.bounds;
    _scrollView.zoomScale  = _scrollView.minimumZoomScale;
    [self scrollViewDidZoom:_scrollView];
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _containerView.frame.size.width;
    CGFloat H = _containerView.frame.size.height;
    
    CGRect rct = _containerView.frame;
    rct.origin.x = MAX((Ws-W)*0.5, 0);
    rct.origin.y = MAX((Hs-H)*0.5, 0);
    _containerView.frame = rct;
}

//获取图片和显示视图宽度的比例系数
- (float)getImgWidthFactor {
    return   self.bounds.size.width / self.image.size.width;
}
//获取图片和显示视图高度的比例系数
- (float)getImgHeightFactor {
    return  self.bounds.size.height / self.image.size.height;
}

//获获取尺寸
- (CGSize)newSizeByoriginalSize:(CGSize)oldSize maxSize:(CGSize)mSize
{
    if (oldSize.width <= 0 || oldSize.height <= 0) {
        return CGSizeZero;
    }
    
    CGSize newSize = CGSizeZero;
    if (oldSize.width > mSize.width || oldSize.height > mSize.height) {
        //按比例计算尺寸
        float bs = [self getImgWidthFactor];
        float newHeight = oldSize.height * bs;
        newSize = CGSizeMake(mSize.width, newHeight);
        
        if (newHeight > mSize.height) {
            bs = [self getImgHeightFactor];
            float newWidth = oldSize.width * bs;
            newSize = CGSizeMake(newWidth, mSize.height);
        }
    }else {
        
        newSize = oldSize;
    }
    return newSize;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
