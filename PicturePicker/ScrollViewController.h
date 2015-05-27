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
 *  返回未选中的图片row  row : @0
 */
@property (nonatomic, copy) void(^selectedDic)(NSDictionary *dic);

@end
