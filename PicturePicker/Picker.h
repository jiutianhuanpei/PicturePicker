//
//  Picker.h
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/22.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picker : NSObject


/**
 *  groupNames: 分组名数组 
    thumDic:    分组缩略图
    countDic:   分组元素个数
    detailDic:  分组内图片urls @{filename : @{ALAssetTypePhoto : @[urls], ALAssetTypeVideo : @[urls]}}
 */
@property (nonatomic, copy) void(^didSomeSth)(NSArray *groupNames, NSDictionary *thumDic, NSDictionary *countDic, NSDictionary *detailDic);

/**
 *  存储的是 url
 */
@property (nonatomic, copy) void(^allMedias)(NSDictionary *dataDic);

+ (Picker *)sharedPicker;


@end
