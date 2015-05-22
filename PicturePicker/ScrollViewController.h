//
//  ScrollViewController.h
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/21.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollViewController : UIViewController

@property (nonatomic, strong) NSDictionary *dataDic;

/**
 *  存储最终选择的图片
 */
@property (nonatomic, strong, readonly) NSArray *images;

@property (nonatomic, copy) void(^selectedImages)(NSArray *images);
@property (nonatomic, copy) void(^selectedDic)(NSDictionary *dic);

@end
