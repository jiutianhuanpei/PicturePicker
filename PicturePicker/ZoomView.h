//
//  ZoomView.h
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/22.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomView : UIView

{
    CGFloat viewscale;
    NSString *downImgUrl;
    
}


@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) BOOL isViewing;
@property (nonatomic, retain)UIView *containerView;

- (void)resetViewFrame:(CGRect)newFrame;
- (void)updateImage:(UIImage *)image;

@end
