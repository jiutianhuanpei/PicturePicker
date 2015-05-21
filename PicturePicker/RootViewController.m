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

@interface RootViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    
    ALAssetsLibrary *library;
    
    NSArray *imageArray;
    
    NSMutableArray *mutableArray;
    
}



-(void)allPhotosCollected:(NSArray*)imgArray;

@end

static int count=0;


@implementation RootViewController {
    UICollectionView *_collectionView;
    
    NSMutableDictionary *_dataDic; // 被选中的图片
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    /*
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
    NSMutableArray *mediaArray = [[NSMutableArray alloc]init];//存放media的数组
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {//获取所有group
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {//从group里面
            NSString* assetType = [result valueForProperty:ALAssetPropertyType];
            if ([assetType isEqualToString:ALAssetTypePhoto]) {
                NSLog(@"Photo");
                NSLog(@"__%@++%lu", result, (unsigned long)index);
            }else if([assetType isEqualToString:ALAssetTypeVideo]){
                NSLog(@"Video");
                NSLog(@"__%@++%lu", result, (unsigned long)index);
            }else if([assetType isEqualToString:ALAssetTypeUnknown]){
                NSLog(@"Unknow AssetType");
                NSLog(@"__%@++%lu", result, (unsigned long)index);
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
    
    
    [self getAllPictures];
    
    
}

- (void)creatCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
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
    [button setTitle:@"click" forState:UIControlStateNormal];
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
    [self.navigationController pushViewController:scrollVC animated:YES];

}

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
    UIImage *image = (UIImage *)imageArray[indexPath.row];
    CGFloat itemW = CGRectGetWidth(_collectionView.frame) / 2.3;
    CGFloat itemH = image.size.height * itemW / image.size.width;
    
    return CGSizeMake(itemW, itemH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *image = (UIImage *)imageArray[indexPath.row];
    NSString *row = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    SHBCell *cell = (SHBCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.flag) {
        [_dataDic setObject:image forKey:row];
//        [_dataDic setValue:image forKey:row];
        
    } else {
        [_dataDic removeObjectForKey:row];
    }

}


-(void)getAllPictures

{
    
    imageArray=[[NSArray alloc] init];
    
    mutableArray =[[NSMutableArray alloc]init];
    
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if(result != nil) {
            
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto] || [[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                
                
                [library assetForURL:url
                 
                         resultBlock:^(ALAsset *asset) {
                             
                             [mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                             
                             if ([mutableArray count] == count)
                                 
                             {
                                 
                                 imageArray=[[NSArray alloc] initWithArray:mutableArray];
                                 
                                 [self allPhotosCollected:imageArray];
                                 
                                 /**
                                  *  创建 集合视图
                                  */
                                 [self creatCollectionView];
                                 
                             }
                             
                         }
                 
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
                
            }
            
        }
        
    };
    
    
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        
        if(group != nil) {
            
            [group enumerateAssetsUsingBlock:assetEnumerator];
            
            [assetGroups addObject:group];
            
            count = [group numberOfAssets];
            
        }
        
    };
    
    
    
    assetGroups = [[NSMutableArray alloc] init];
    
    
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
     
                           usingBlock:assetGroupEnumerator
     
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
    
}



-(void)allPhotosCollected:(NSArray*)imgArray

{
    
    //write your code here after getting all the photos from library...
    
    NSLog(@"all pictures are %@",imgArray);
    
}





@end
