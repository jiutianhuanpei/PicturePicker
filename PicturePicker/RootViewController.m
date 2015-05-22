//
//  RootViewController.m
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/21.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "RootViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SHBCell.h"
#import "ScrollViewController.h"
#import "GroupViewController.h"

@interface RootViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    
    ALAssetsLibrary *library;
    
    NSArray *imageArray;
    
    NSMutableArray *mutableArray;
    
}





@end

static int count=0;


@implementation RootViewController {
    UICollectionView *_collectionView;
    
    NSMutableDictionary *_dataDic; // 被选中的图片
    
    NSMutableArray *_groupArray;
    NSMutableArray *_medioArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    _groupArray = [[NSMutableArray alloc] initWithCapacity:0];
    _medioArray = [[NSMutableArray alloc] initWithCapacity:0];
    /*
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
    NSMutableArray *mediaArray = [[NSMutableArray alloc] initWithCapacity:0];//存放media的数组
    NSMutableArray *groupArray = [[NSMutableArray alloc] initWithCapacity:0];//存放相册数组
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {//获取所有group
        
        [groupArray addObject:group];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {//从group里面
            
            [mediaArray addObject:result];
            
            NSString* assetType = [result valueForProperty:ALAssetPropertyType];
            
            if ([assetType isEqualToString:ALAssetTypePhoto]) {
                NSLog(@"Photo");
                
            }else if([assetType isEqualToString:ALAssetTypeVideo]){
                NSLog(@"Video");
               
            }else if([assetType isEqualToString:ALAssetTypeUnknown]){
                NSLog(@"Unknow AssetType");
               
            }
            
            NSDictionary *assetUrls = [result valueForProperty:ALAssetPropertyURLs];
            NSUInteger assetCounter = 0;
            for (NSString *assetURLKey in assetUrls) {
                NSLog(@"Asset URL %lu = %@",(unsigned long)assetCounter,[assetUrls objectForKey:assetURLKey]);
            }
            
            NSLog(@"Representation Size = %lld",[[result defaultRepresentation]size]);
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"Enumerate the asset groups failed.");
    }];
    */
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"分组" style:UIBarButtonItemStylePlain target:self action:@selector(toGroupView)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendImage)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    [self getAllPictures];
    [self getAllMedias];
    
}

- (void)creatCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 0, 20);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64 - 49) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor yellowColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [_collectionView registerClass:[SHBCell class] forCellWithReuseIdentifier:NSStringFromClass([SHBCell class])];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49)];
    toolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"预览" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 40);
    button.center = CGPointMake(CGRectGetWidth(toolView.frame) / 2., 24.5);
    [button addTarget: self action:@selector(preView) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:button];
}

- (void)preView {
    if (!_dataDic.count) {
        return;
    }
    
    ScrollViewController *scrollVC = [[ScrollViewController alloc] init];
    
    scrollVC.dataDic = _dataDic;
    
    /**
     *  返回最终 的图片数组
     */
    scrollVC.selectedImages = ^(NSArray *images) {
        
        NSLog(@"最终 的图片数组 : %@", images);
    };
    scrollVC.selectedDic = ^(NSDictionary *dic) {
        NSArray *allKeys = dic.allKeys;
        for (NSString *key in allKeys) {
            UIImage *image = (UIImage *)dic[key];
            NSInteger row = [key integerValue];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            SHBCell *cell = (SHBCell *)[_collectionView cellForItemAtIndexPath:indexPath];
            if (cell.flag) {
                [_dataDic setObject:image forKey:key];
            } else {
                [_dataDic removeObjectForKey:key];
            }
        }
    };
    
    [self.navigationController pushViewController:scrollVC animated:YES];
}

#pragma mark - 分组
- (void)toGroupView {
    GroupViewController *groupVC = [[GroupViewController alloc] init];
    [self.navigationController pushViewController:groupVC animated:YES];
}

#pragma mark - 发送
- (void)sendImage {
    NSLog(@"被选的图片: %@", _dataDic);
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SHBCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SHBCell class]) forIndexPath:indexPath];
    UIImage *image = (UIImage *)imageArray[indexPath.row];
    cell.image = image;
    cell.backgroundColor = [UIColor redColor];
    [cell addImage:image];
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(100, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *image = (UIImage *)imageArray[indexPath.row];
    NSString *row = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    SHBCell *cell = (SHBCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.flag) {
        [_dataDic setObject:image forKey:row];
        
    } else {
        [_dataDic removeObjectForKey:row];
    }

}

- (void)getAllMedias {
    NSMutableArray *tempImages = [[NSMutableArray alloc] initWithCapacity:0];
    
    ALAssetsLibrary *assLibrary = [[ALAssetsLibrary alloc] init];
    [assLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [_groupArray addObject:group];
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    
                    NSURL *url = (NSURL *)[result defaultRepresentation].url;
                    [_medioArray addObject:url];
                    
                    [assLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                        
                        ALAssetRepresentation *detail = [asset defaultRepresentation];
                        
                        UIImage *image = [UIImage imageWithCGImage:[detail fullResolutionImage]];
                        
                        [tempImages addObject:image];
                        if (tempImages.count == group.numberOfAssets) {
                            imageArray = tempImages;
                            [self creatCollectionView];
                        }
                        
                    } failureBlock:^(NSError *error) {
                        
                    }];
                }
            }];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}


#pragma mark - 获取所有图片
-(void)getAllPictures {
    
    imageArray=[[NSArray alloc] init];
    
    mutableArray =[[NSMutableArray alloc]init];
    
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if(result != nil) {
            
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto] || [[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation] url];
                
                [library assetForURL:url resultBlock:^(ALAsset *asset) {
                             
                             [mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                             
                             if ([mutableArray count] == count)
                                 
                             {
                                 
                                 imageArray=[[NSArray alloc] initWithArray:mutableArray];
                                 
                                 /**
                                  *  创建 集合视图
                                  */
                                 [self creatCollectionView];
                                 
                             }
                             
                         } failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
                
                
                
                
            }
            
        }
        
    };
    
    
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        
        if(group) {
            
            [group enumerateAssetsUsingBlock:assetEnumerator];
            NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
            NSDate *date = [group valueForProperty:ALAssetPropertyDate];
            
            [assetGroups addObject:groupName];
            NSLog(@"^^^^^\n%@\n", group);
            count = [group numberOfAssets];
            
        }
        
    };
    
    
    
    assetGroups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
     
                           usingBlock:assetGroupEnumerator
     
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
    
    
}







@end
