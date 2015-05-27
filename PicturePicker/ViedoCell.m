
//
//  ViedoCell.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/25.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "ViedoCell.h"

@implementation ViedoCell {
    UIButton *_play;
    UILabel *_time;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *alphaView = [[UIView alloc] initWithFrame:CGRectZero];
        alphaView.translatesAutoresizingMaskIntoConstraints = NO;
        alphaView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        [self addSubview:alphaView];
        
        _play = [UIButton buttonWithType:UIButtonTypeSystem];
        _play.translatesAutoresizingMaskIntoConstraints = NO;
        [_play setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
        [self addSubview:_play];
        
        _time = [[UILabel alloc] initWithFrame:CGRectZero];
        _time.translatesAutoresizingMaskIntoConstraints = NO;
        _time.textColor = [UIColor whiteColor];
        _time.font = [UIFont systemFontOfSize:10];
        [self addSubview:_time];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(alphaView, _play, _time);
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[alphaView]|" options:0 metrics:nil views:views]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[alphaView(15)]|" options:0 metrics:nil views:views]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-7.5-[_play(10)]-(>=0)-[_time]-7.5-|" options:0 metrics:nil views:views]];
        [array addObject:[NSLayoutConstraint constraintWithItem:_play attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:10]];
        [array addObject:[NSLayoutConstraint constraintWithItem:_play attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:alphaView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [array addObject:[NSLayoutConstraint constraintWithItem:_time attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:alphaView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraints:array];
    }
    return self;
}

- (void)addTime:(NSString *)time {
    NSInteger tim = [time integerValue];
    double second = tim % 60;
    double min = tim / 60;
    time = [NSString stringWithFormat:@"%.f:%.f", min, second];
    _time.text = time;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
