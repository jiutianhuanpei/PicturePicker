//
//  TableViewCell.h
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/22.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableModel;

@interface TableViewCell : UITableViewCell

- (void)setModel:(TableModel *)model;

@end

@interface TableModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *count;

@end
