//
//  RootViewController.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/25.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "RootViewController.h"
#import <HexColor.h>
#import "Picker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCell.h"
#import "ViedoCell.h"

#import "ScrollViewController.h"
#import "GroupViewController.h"
#import <SVProgressHUD.h>
#import "ViedoViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface RootViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation RootViewController {
    UIView *_toolView;
    UILabel *_countLbl;
    UICollectionView *_collectionView;
    
    NSMutableArray *_photoArray;
    NSMutableArray *_viedoArray;
    
    NSMutableArray *_durArray;; //如果 是视频 存其时长, 若为照版 存 0
    
    NSMutableArray *_dataArray; // 存储所有的 image
    
    NSMutableArray *_consultArray;  // 选择参照; 0:未    1:选
    
    NSMutableDictionary *_dataDic;   // 被选中的图片 @{row : image, }
    
    NSMutableDictionary *_urlsDic;  // 每张图片对应的url @{row : url, ALAssetTypeVideo : viedo}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _photoArray = [[NSMutableArray alloc] initWithCapacity:0];
    _viedoArray = [[NSMutableArray alloc] initWithCapacity:0];
    _durArray = [[NSMutableArray alloc] initWithCapacity:0];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _consultArray = [[NSMutableArray alloc] initWithCapacity:0];
    _dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    _urlsDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"d-back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToGroupView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickedCancelBtn)];
    [SVProgressHUD show];
    
    [self creatToolView];
    
    [self getAllMedias];
    
}

/**
 *  创建 集合视图
 */
- (void)creatCollectionView {
    CGFloat maxWidth = CGRectGetWidth(self.view.frame);
    CGFloat maxHeight = CGRectGetHeight(self.view.frame);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 7;
    layout.minimumInteritemSpacing = 7;
    CGFloat w = (maxWidth - 5 * 7) / 4.;
    layout.itemSize = CGSizeMake(w, w);
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 0, 7);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, maxWidth, maxHeight - 64 - 49) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    //注册
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:NSStringFromClass([PhotoCell class])];
    [_collectionView registerClass:[ViedoCell class] forCellWithReuseIdentifier:NSStringFromClass([ViedoCell class])];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *du = _durArray[indexPath.row];
    UIImage *image = (UIImage *)_dataArray[indexPath.row];
    if (![du integerValue]) {
        PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoCell class]) forIndexPath:indexPath];
        [cell addImage:image];
        return cell;
    }
    ViedoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ViedoCell class]) forIndexPath:indexPath];
    [cell addImage:image];
    [cell addTime:du];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    
    UIImage *image = (UIImage *)_dataArray[indexPath.row];
    NSString *row = [NSString stringWithFormat:@"%d", indexPath.row];
    
    NSString *dur = _durArray[indexPath.row];
    NSString *consult = _consultArray[indexPath.row];
    if ([consult integerValue]) {   //已选中的
        _consultArray[indexPath.row] = @"0";
        if ([dur integerValue]) {
            cell = (ViedoCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [(ViedoCell *)cell flagSelected:NO];
            [_dataDic removeObjectForKey:ALAssetTypeVideo];
        } else {
            cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [(PhotoCell *)cell flagSelected:NO];
            [_dataDic removeObjectForKey:row];
        }
    } else {    // 未选中的
        for (int i = 0; i < _consultArray.count; i++) {
            NSString *count = _consultArray[i];
            if ([count integerValue]) {
                UICollectionViewCell *tempCell = [collectionView cellForItemAtIndexPath:indexPath];
                UICollectionViewCell *kkCell = [collectionView cellForItemAtIndexPath: [NSIndexPath indexPathForItem:i inSection:0]];
                if (tempCell.class == kkCell.class) {
                    if ([kkCell isKindOfClass:[ViedoCell class]] || [tempCell isKindOfClass:[ViedoCell class]]) {
                        UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"只能选择一个视频文件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [al show];
                        return;
                    }
                } else {
                    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"只能选择一种文件类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [al show];
                    return;
                }
            }
        }
        _consultArray[indexPath.row] = @"1";
        if ([dur integerValue]) {
            cell = (ViedoCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [(ViedoCell *)cell flagSelected:YES];
            [_dataDic setObject:image forKey:ALAssetTypeVideo];
        } else {
            cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [(PhotoCell *)cell flagSelected:YES];
            [_dataDic setObject:image forKey:row];
        }
        
    }
    
    int btnTitle = 0;
    for (NSString *count in _consultArray) {
        if ([count integerValue]) {
            btnTitle++;
        }
    }
    _countLbl.text = [NSString stringWithFormat:@"%d", btnTitle];
    
}

/**
 *  获取 数据
 */
- (void)getAllMedias {
    Picker *picker = [Picker sharedPicker];
    picker.allMedias = ^(NSDictionary *dataDic){
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        int count = 0;
        NSArray *keys = dataDic.allKeys;
        for (int i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            NSArray *data = dataDic[key];
            count += data.count;
        }
        int k = 0;
        for (int i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            NSArray *data = dataDic[key];
            for (int j = 0; j < data.count; j++) {
                NSURL *url = (NSURL *)data[j];
                [_urlsDic setObject:url forKey:[NSString stringWithFormat:@"%d", k]];
                k++;
                
                [assetsLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                    ALAssetRepresentation *detail = [asset defaultRepresentation];
                    UIImage *image = [UIImage imageWithCGImage:[detail fullResolutionImage]];
                    [_dataArray addObject:image];
                    if ([key isEqualToString:ALAssetTypePhoto]) {
                        [_durArray addObject:@"0"];
                    } else {
                        [_durArray addObject:[NSString stringWithFormat:@"%@", [asset valueForProperty:ALAssetPropertyDuration]]];
                    }
                    if (k == count) {
                        NSLog(@"这此返回最终数据");
                        NSLog(@"_durArray: %@", _durArray);
                        for (int i = 0; i < _durArray.count; i++) {
                            [_consultArray addObject:@"0"];
                        }
                        
                        /**
                         *  创建集合视图
                         */
                        [self creatCollectionView];
                        [SVProgressHUD dismiss];
                    }
                } failureBlock:^(NSError *error) { }];
            }
        }
    };
}

/**
 *  完成
 */
- (void)clickedOverBtn {
    if (_selectedMedias) {
        _selectedMedias(_dataDic);
    }
    
}

/**
 *  去 预览 页面
 */
- (void)goToPreView {
    if (!_dataDic.count) {
        return;
    }
    
    NSArray *tempAllKeys = _dataDic.allKeys;
    NSString *firstKey = tempAllKeys[0];
    if ([firstKey isEqualToString:ALAssetTypeVideo]) {  //视频 预览
        for (int i = 0; i < _consultArray.count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d", i];
            NSURL *url = (NSURL *)_urlsDic[key];
            ViedoViewController *viedoVC = [[ViedoViewController alloc] initWithContentURL:url];
            NSString *consult = _consultArray[i];
            if ([consult integerValue]) {
                NSIndexPath *viedoPath = [NSIndexPath indexPathForItem:i inSection:0];
                ViedoCell *cell = (ViedoCell *)[_collectionView cellForItemAtIndexPath:viedoPath];
                viedoVC.flagSelected = ^(BOOL flag){
                    if (flag) {
                        [cell flagSelected:YES];
                    } else {
                        [cell flagSelected:NO];
                        _consultArray[viedoPath.row] = @"0";
                        [_dataDic removeObjectForKey:ALAssetTypeVideo];
                    }
                };

                [self.navigationController presentMoviePlayerViewControllerAnimated:viedoVC];
                

            }
        }
    } else {    //图片 预览
        ScrollViewController *scrollVC = [[ScrollViewController alloc] init];
        scrollVC.dataDic = _dataDic;
        scrollVC.selectedDic = ^(NSDictionary *dic) {
            NSArray *allKeys = dic.allKeys;
            UICollectionViewCell *cell = nil;
            NSArray *selectedKeys = _dataDic.allKeys;
            for (int i = 0; i < selectedKeys.count; i++) {
                NSString *tempKey = selectedKeys[i];
                for (NSString *key in allKeys) {
                    if ([tempKey isEqualToString:key]) {
                        //  此时 这个照片已 不被选择   key 就是 row
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[key integerValue] inSection:0];
                        NSString *dur = _durArray[[key integerValue]];
                        if ([dur integerValue]) {
                            cell = (ViedoCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                            [(ViedoCell *)cell flagSelected:NO];
                        } else {
                            cell = (PhotoCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                            [(PhotoCell *)cell flagSelected:NO];
                        }
                        _consultArray[indexPath.row] = @"0";
                        [_dataDic removeObjectForKey:key];
                    }
                }
            }
            int btnTitle = 0;
            for (NSString *count in _consultArray) {
                if ([count integerValue]) {
                    btnTitle++;
                }
            }
            _countLbl.text = [NSString stringWithFormat:@"%d", btnTitle];
        };
        [self.navigationController pushViewController:scrollVC animated:YES];
    }
}

/**
 *  去分组页面
 */
- (void)goToGroupView {
    GroupViewController *groupVC = [[GroupViewController alloc] init];
    groupVC.detailData = ^(NSDictionary *images){
        [SVProgressHUD show];
        [_dataArray removeAllObjects];
        [_durArray removeAllObjects];
        [_consultArray removeAllObjects];
        if (!images.count) {
            [SVProgressHUD dismiss];
            [_collectionView reloadData];
            return ;
        }
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSArray *keys = images.allKeys;
        int count = 0;
        for (int i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            NSArray *data = images[key];
            count += data.count;
        }
        int k = 0;
        [_urlsDic removeAllObjects];
        for (int i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            NSArray *urls = images[key];
            for (int j = 0; j < urls.count; j++) {
                NSURL *url = (NSURL *)urls[j];
                [_urlsDic setObject:url forKey:[NSString stringWithFormat:@"%d", k]];
                k++;
                [library assetForURL:url resultBlock:^(ALAsset *asset) {
                    
                    ALAssetRepresentation *detail = [asset defaultRepresentation];
                    UIImage *image = [UIImage imageWithCGImage:[detail fullResolutionImage]];
                    [_dataArray addObject:image];
                    if ([key isEqualToString:ALAssetTypePhoto]) {
                        [_durArray addObject:@"0"];
                    } else {
                        [_durArray addObject:[NSString stringWithFormat:@"%@", [asset valueForProperty:ALAssetPropertyDuration]]];
                    }
                    if (k == count) {
                        for (int i = 0; i < _durArray.count; i++) {
                            [_consultArray addObject:@"0"];
                        }
                        [_collectionView reloadData];
                        [SVProgressHUD dismiss];
                    }
                } failureBlock:^(NSError *error) { }];
            }
        }
    };
    [self.navigationController pushViewController:groupVC animated:YES];
}

/**
 *  取消
 */
- (void)clickedCancelBtn {
    
}

/**
 *  添加 toolView
 */
- (void)creatToolView {
    CGFloat maxWidth = CGRectGetWidth(self.view.frame);
    CGFloat maxHeight = CGRectGetHeight(self.view.frame);
    
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, maxHeight - 49, maxWidth, 49)];
    _toolView.backgroundColor = [UIColor colorWithHexString:@"F7F6F6"];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"CECDCD"];
    [_toolView addSubview:line];
    [self.view addSubview:_toolView];
    
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [preBtn setTitle:@"预览" forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor colorWithHexString:@"9998c0"] forState:UIControlStateNormal];
    preBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    preBtn.frame = CGRectMake(0, 0, 50, 49);
    [preBtn addTarget:self action:@selector(goToPreView) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:preBtn];
    
    UIButton *overBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [overBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [overBtn setTitle:@"完成" forState:UIControlStateNormal];
    [overBtn setTitleColor:[UIColor colorWithHexString:@"9998c0"] forState:UIControlStateNormal];
    overBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [overBtn setImage:[UIImage imageNamed:@"yuan"] forState:UIControlStateNormal];
    [overBtn addTarget:self action:@selector(clickedOverBtn) forControlEvents:UIControlEventTouchUpInside];
    overBtn.frame = CGRectMake(maxWidth - 70, 0, 70, 49);
    [_toolView addSubview:overBtn];
    
    _countLbl = [[UILabel alloc] initWithFrame:overBtn.imageView.bounds];
    _countLbl.textColor = [UIColor whiteColor];
    _countLbl.textAlignment = NSTextAlignmentCenter;
    _countLbl.font = [UIFont systemFontOfSize:10];
    _countLbl.text = @"0";
    [overBtn.imageView addSubview:_countLbl];
}


@end
