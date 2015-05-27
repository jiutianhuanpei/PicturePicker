//
//  SHBCell.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/21.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell {
    UIImageView *_imageView;
    UIImageView *_btnView;
    
    
    UITapGestureRecognizer *_tap;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
                
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_imageView];
        
        _btnView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _btnView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_btnView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _btnView);
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_imageView]|" options:0 metrics:nil views:views]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:nil views:views]];

        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_btnView(20)]" options:0 metrics:nil views:views]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[_btnView(20)]-5-|" options:0 metrics:nil views:views]];
        [self addConstraints:array];
    }
    return self;
}



- (void)addImage:(UIImage *)image {
    _imageView.image = image;
    _btnView.image = [UIImage imageNamed:@"weixuan"];
}

- (void)flagSelected:(BOOL)flag {
    if (flag) {
        _btnView.image = [UIImage imageNamed:@"xuanze"];
    } else {
        _btnView.image = [UIImage imageNamed:@"weixuan"];
    }
}



@end
