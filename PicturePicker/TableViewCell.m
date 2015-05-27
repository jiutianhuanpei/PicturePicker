//
//  TableViewCell.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/22.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "TableViewCell.h"
#import <HexColor.h>

@implementation TableViewCell {
    UIImageView *_imgView;
    UILabel *_nameLbl;
    UILabel *_countLbl;
    UILabel *_right;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_imgView];
        
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLbl.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLbl.font = [UIFont systemFontOfSize:16];
        _nameLbl.textColor = [UIColor colorWithHexString:@"413f55"];
        [self addSubview:_nameLbl];
        
        _countLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLbl.translatesAutoresizingMaskIntoConstraints = NO;
        _countLbl.font = [UIFont systemFontOfSize:13];
        _countLbl.textColor = [UIColor colorWithHexString:@"dddcdb"];
        [self addSubview:_countLbl];
        
        _right = [[UILabel alloc] initWithFrame:CGRectZero];
        _right.translatesAutoresizingMaskIntoConstraints = NO;
        _right.text = @"〉";
        [self addSubview:_right];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_imgView, _nameLbl, _countLbl, _right);
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-7-[_imgView(51)]-20-[_nameLbl]-10-[_countLbl]-(>=0)-[_right]-21.5-|" options:0 metrics:nil views:views]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_imgView(51)]-7-|" options:0 metrics:nil views:views]];
        
        [array addObject:[NSLayoutConstraint constraintWithItem:_nameLbl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imgView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [array addObject:[NSLayoutConstraint constraintWithItem:_countLbl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imgView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [array addObject:[NSLayoutConstraint constraintWithItem:_right attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imgView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraints:array];
        
    }
    return self;
}

- (void)setModel:(TableModel *)model {
    
    _imgView.image = model.image;
    _nameLbl.text = model.name;
    _countLbl.text = [NSString stringWithFormat:@"(%@)", model.count];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation TableModel



@end



