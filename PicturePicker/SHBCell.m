//
//  SHBCell.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/21.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "SHBCell.h"

@implementation SHBCell {
    UIImageView *_imageView;
    UIView *_topView;
    BOOL _tempFlag;
    
    UIButton *_btn;
    
    UITapGestureRecognizer *_tap;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
         _tempFlag = NO;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_imageView];
        
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        _topView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_topView];
        
        _btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btn setTitle:@"1" forState:UIControlStateNormal];
        _btn.translatesAutoresizingMaskIntoConstraints = NO;
        [_btn addTarget:self action:@selector(flagIsSelected) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
//        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flagIsSelected)];
//        [self addGestureRecognizer:_tap];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _topView, _btn);
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_imageView]|" options:0 metrics:nil views:views]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:nil views:views]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_topView]|" options:0 metrics:nil views:views]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView]|" options:0 metrics:nil views:views]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_btn(20)]" options:0 metrics:nil views:views]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[_btn(20)]-10-|" options:0 metrics:nil views:views]];
        
        
        [self addConstraints:array];
    }
    return self;
}



- (BOOL)flag {
    _tempFlag = !_tempFlag;
    if (_tempFlag) {
        [_btn setTitle:@"2" forState:UIControlStateNormal];
        _topView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    } else {
        [_btn setTitle:@"1" forState:UIControlStateNormal];
        _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }
    return _tempFlag;
}



- (void)addImage:(UIImage *)image {
    _imageView.image = image;
}

@end
