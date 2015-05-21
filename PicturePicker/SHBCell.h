//
//  SHBCell.h
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/21.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, readonly) BOOL flag;

- (void)addImage:(UIImage *)image;
- (void)fuzzyView;

@end
