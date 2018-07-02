//
//  MoviePlayerView.m
//  KLine
//
//  Created by wangxiangheng on 2017/3/28.
//  Copyright © 2017年 wangxiangheng. All rights reserved.
//

#import "CXMoviePlayerView.h"
#import "CXPlayerToolView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+CXFrameExpand.h"


@interface CXMoviePlayerView()

@property (nonatomic, strong) AVPlayer *player ;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) CXPlayerToolView *toolView;

@property(nonatomic,copy) NSString * videoPath;

@end

@implementation CXMoviePlayerView

- (instancetype)initWithUrl:(NSURL *)url AndAddSubView:(UIView *)playSubView
{
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame:(CGRect){0, 0,screenSize }];
    
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
         [playSubView addSubview:self];
        //传入地址
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        // 播放器
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        
        // 播放器layer
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        
        
        _playerLayer.frame = self.bounds;
        // 视频填充模式
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        // 添加到imageview的layer上
        [self.layer addSublayer:_playerLayer];
        // 隐藏提示框 开始播放
        
        //视频沙盒地址
        self.videoPath = [url path];
        
        //静音模式也能播放
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)]];
        
        //监听程序状态栏方向改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutSubviews) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        
        //长按保存视频
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSaveVideo)];
        [self addGestureRecognizer:longPressGr];
        
    }
    
    return self;
}



- (void)setupMainView {
//    NSLog(@"5.setupMainView方法，初始化界面");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.bounds = window.bounds;
    self.center = window.center;
    //1. toolView
    
    [self addSubview:self.toolView];

}
- (CXPlayerToolView *)toolView
{
    if (_toolView == nil) {
        _toolView = [[CXPlayerToolView alloc]initWithFrame:self.bounds];
        _toolView.player = _player;
        __weak typeof (self)  weakSelf = self;
        _toolView.closeBlock = ^(){
            //点击关闭按钮回调
            if (weakSelf.closeVideoPlay) {
                weakSelf.closeVideoPlay();
            }
            [weakSelf close];
        };
    }
    
    return _toolView;
}
- (void)tapView
{
    self.toolView.hidden = !self.toolView.hidden;
  
}
- (void)play
{
    [self setupMainView];
    // 播放
    [self.player play];
    [self.toolView PlayOrStop:YES];
    
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:self];
    
    //动画
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];


    
}

//停止播放
- (void)stopPlay{
    [self close];
}

- (void)close
{
    [self.player pause];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.frame = (CGRect){0, 0,screenSize };
    [self.playerLayer setFrame:(CGRect){0, 0, screenSize} ];
    
    self.toolView.frame = self.frame;
    
}

//长按保存视频
-(void)longPressSaveVideo{

//    [AlertCXView AlertMyCXSheetAllViewWithController:[UIApplication sharedApplication].keyWindow.rootViewController Title:@"提示" otherItemArrays:@[@"保存视频"] ShowRedindex:-1 isShowCancel:YES CancelTitle:@"取消" Type:-1 handler:^(NSInteger index) {
//        if (index==0) {
//            //保存视频到相册
//            [[UIImage new] saveVideoToPhone:self.videoPath];
//        }
//    }];
    
}

//
//- (void)downloadurl:(NSString *)url{
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"video.mp4"];
//    
//    NSURL *urlNew = [NSURL URLWithString:url];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
//    
//    NSURLSessionDownloadTask *task =
//    
//    [manager downloadTaskWithRequest:request
//     
//                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//                                
//                                return [NSURL fileURLWithPath:fullPath];
//                                
//                            }
//     
//                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//                       
//                       NSLog(@"%@",response);
//                       
////                       [self saveVideo:fullPath];
//                       //            //保存视频到相册
//                        [[UIImage new] saveVideoToPhone:fullPath];
//                       
//                   }];
//    
//    [task resume];
//    
//    
//    
//}




-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
