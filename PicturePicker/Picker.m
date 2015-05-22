//
//  Picker.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/22.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "Picker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@implementation Picker {
    
    NSMutableDictionary *_dataDic; // 被选中的图片
    
    NSMutableArray *_groupArray;
    NSMutableArray *_medioArray;

    
}

+ (Picker *)sharedPicker {
    static Picker *picker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!picker) {
            picker = [[Picker alloc] init];
            
        }
    });
    
    return picker;
}

- (void)getAllMedias {
    NSMutableArray *fileNames = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *countDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableDictionary *thumDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    ALAssetsLibrary *assLibrary = [[ALAssetsLibrary alloc] init];
    [assLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSString *fileName = [group valueForProperty:ALAssetsGroupPropertyName];

            
            [fileNames addObject:fileName];
            
            
            [countDic setObject:@(group.numberOfAssets) forKey:fileName];
            
            
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    
                    UIImage *thumImg = [UIImage imageWithCGImage:result.thumbnail];
                    [thumDic setObject:thumImg forKey:fileName];
                    
                    NSURL *url = (NSURL *)[result defaultRepresentation].url;
                    [_medioArray addObject:url];
                    
                    if (_didSomeSth) {
                        _didSomeSth(fileNames, thumDic, countDic);
                    }
                    
                }
            }];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}



@end
