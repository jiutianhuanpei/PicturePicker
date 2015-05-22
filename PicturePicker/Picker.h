//
//  Picker.h
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/22.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picker : NSObject



@property (nonatomic, copy) void(^didSomeSth)(NSArray *groupNames, NSDictionary *thumDic, NSDictionary *countDic);

+ (Picker *)sharedPicker;
- (void)getAllMedias;

@end
