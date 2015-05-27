//
//  ViedoViewController.h
//  PicturePicker
//
//  Created by 沈红榜 on 15/5/26.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViedoViewController : MPMoviePlayerViewController

@property (nonatomic, strong) NSURL *url;

/**
 *  是否选择 0:未 1:选
 */
@property (nonatomic, copy) void(^flagSelected)(BOOL flag);

@end
