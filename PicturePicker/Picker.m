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
    

    
}

+ (Picker *)sharedPicker {
    Picker *picker = [[Picker alloc] init];
    [picker getAllMedias];
    return picker;
}

- (void)getAllMedias {
    NSMutableArray *fileNames = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *countDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableDictionary *thumDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableDictionary *detailImageDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *viedos = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    ALAssetsLibrary *assLibrary = [[ALAssetsLibrary alloc] init];
    [assLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
           
            NSString *fileName = [group valueForProperty:ALAssetsGroupPropertyName];
            NSMutableDictionary *groupDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            if ([fileName isEqualToString:@"Camera Roll"]) {
                fileName = @"相机胶卷";
            }
            
            [fileNames addObject:fileName];
            
            UIImage *image = [UIImage imageWithCGImage:[group posterImage]];
            [thumDic setObject:image forKey:fileName];
            
            [countDic setObject:@(group.numberOfAssets) forKey:fileName];
            
            NSMutableArray *detail = [[NSMutableArray alloc] initWithCapacity:0];
            NSInteger count = group.numberOfAssets;
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    ALAssetRepresentation *representation = [result defaultRepresentation];
                    
                    NSURL *url = (NSURL *)representation.url;
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        [photos addObject:url];
                        [dataDic setObject:photos forKey:ALAssetTypePhoto];
                        [groupDic setObject:photos forKey:ALAssetTypePhoto];
                    } else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                        [viedos addObject:url];
                        [dataDic setObject:viedos forKey:ALAssetTypeVideo];
                        [groupDic setObject:viedos forKey:ALAssetTypeVideo];
                    }
                    
                    UIImage *detailImage = [UIImage imageWithCGImage:representation.fullResolutionImage];
                    [detail addObject:detailImage];
                    if (detail.count == count) {
//                        [detailImageDic setObject:detail forKey:fileName];
                        [detailImageDic setObject:groupDic forKey:fileName];
                        
                        
                        if (_allMedias) {
                            _allMedias(dataDic);
                        }
                        
                        if (_didSomeSth) {
                            _didSomeSth(fileNames, thumDic, countDic, detailImageDic);
                        }
                        
                    }
                    
                }
            }];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}



@end
