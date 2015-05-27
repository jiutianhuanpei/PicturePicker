//
//  SHBCell.h
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/21.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

- (void)addImage:(UIImage *)image;
- (void)flagSelected:(BOOL)flag;


@end