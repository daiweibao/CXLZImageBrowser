//
//  MoviePlayerView.h
//  KLine
//
//  Created by wangxiangheng on 2017/3/28.
//  Copyright © 2017年 wangxiangheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXMoviePlayerView : UIView

- (instancetype)initWithUrl:(NSURL *)url AndAddSubView:(UIView *)playSubView;

//开始播放
- (void)play;
//停止播放
- (void)stopPlay;

//掉关闭视频播放器
@property(nonatomic,copy) void(^closeVideoPlay)(void);

@end
