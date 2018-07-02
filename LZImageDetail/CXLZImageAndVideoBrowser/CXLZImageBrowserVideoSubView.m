//
//  LZImageBrowserVideoSubView.m
//  LZImageDetail
//
//  Created by 爱恨的潮汐 on 2018/7/1.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "CXLZImageBrowserVideoSubView.h"
#import "CXLZImageBrowserModel.h"
#import "CXLZImageBrowserHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "CXMoviePlayerView.h"
@interface CXLZImageBrowserVideoSubView ()<UIScrollViewDelegate>
@property(nonatomic,strong)CXLZImageBrowserModel * imageBrowserModel;
@property(nonatomic,strong)UIScrollView * subScrollView;
@property(nonatomic,strong)UIImageView * subImageView;
@property(nonatomic,assign)NSInteger touchFingerNumber;

@property(nonatomic,strong)CXMoviePlayerView * mPlayer;
@property(nonatomic,weak) UIButton * buttontplay ;

@end

@implementation CXLZImageBrowserVideoSubView

- (id)initWithFrame:(CGRect)frame ImageBrowserModel:(CXLZImageBrowserModel *)imageBrowserModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageBrowserModel = imageBrowserModel;
        [self initView];
        
        //视频停止播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayNotf) name:@"LZStopPlay" object:nil];
    }
    return self;
}
- (void)initView {
    [self addSubview:self.subScrollView];
    [self.subScrollView addSubview:self.subImageView];
    //单击手势
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    [self addGestureRecognizer:singleTap];

    _imageBrowserModel.bigScrollView = self.subScrollView;
    _imageBrowserModel.bigImageView = self.subImageView;
    __weak typeof (self)ws = self;
    [self.subImageView sd_setImageWithURL:[NSURL URLWithString:_imageBrowserModel.urlStr] placeholderImage:_imageBrowserModel.smallImageView.image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            [ws updateSubScrollViewSubImageView];
        }
    }];
    
    //添加视频播放按钮--只有点击播放安妮才能播放
    UIButton * buttontplay = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttontplay =buttontplay;
    [buttontplay setImage:[UIImage imageNamed:@"LZ播放按钮"] forState:UIControlStateNormal];
    [self.subScrollView addSubview:buttontplay];
    buttontplay.userInteractionEnabled = YES;
    [buttontplay addTarget:self action:@selector(ActionbuttonPlay) forControlEvents:UIControlEventTouchUpInside];
    
    //最后更新坐标
    [self updateSubScrollViewSubImageView];
    
    //在主线程里才能播放
    dispatch_async(dispatch_get_main_queue(), ^{
        //判断在屏幕中就播放
        if ([self isViewAddWindowUp:self.subScrollView]==YES) {
            //首次点击在屏幕中就播放
            [self ActionbuttonPlay];
        }
        
    });
    

}


//播放
-(void)ActionbuttonPlay{
    [self stopPlayRemoView];//先停止播放
    NSURL * url = [NSURL fileURLWithPath:_imageBrowserModel.videoUrl];
    CXMoviePlayerView * mPlayer = [[CXMoviePlayerView alloc]initWithUrl:url AndAddSubView:self.subScrollView];
    self.mPlayer = mPlayer;
    [mPlayer play];
    __weak typeof (self)  weakSelf = self;
    [mPlayer setCloseVideoPlay:^{
        //点击关闭按钮
        //点击退出
        [weakSelf singleTapAction];
        
    }];
}


//收到滚动通知判断是否要停止
-(void)stopPlayNotf{
    if ([self isViewAddWindowUp:self.subScrollView]==NO) {
        //不在屏幕中的才停止播放
        [self stopPlayRemoView];
    }
}



//停止播放移除控制器
-(void)stopPlayRemoView{
//    NSLog(@"停止播放");
    [self.mPlayer stopPlay];
}



//单击 退出
- (void)singleTapAction{
    [self stopPlayRemoView];//停止播放
    if ([self.deleagte respondsToSelector:@selector(imageBrowserSubViewSingleTapWithModel:)]) {
        [self.deleagte imageBrowserSubViewSingleTapWithModel:_imageBrowserModel];
    }
}

//设置坐标
- (void)updateSubScrollViewSubImageView {
    [self.subScrollView setZoomScale:1.0 animated:NO];
    
    CGFloat imageW = _imageBrowserModel.bigImageSize.width;
    CGFloat imageH = _imageBrowserModel.bigImageSize.height;
    CGFloat height =  Screen_Width * imageH/imageW;
    self.subImageView.frame =CGRectMake(0, Screen_Height/2 - height/2, Screen_Width, height);
    self.subScrollView.contentSize = CGSizeMake(Screen_Width, height);
    
    //播放按钮坐标
    _buttontplay.frame = CGRectMake(Screen_Width/2-25, Screen_Height/2-25, 50, 50);
    
    
}

/**
 判断一块view是否在屏幕中
 
 @param myView  yes:在屏幕中 no：不在屏幕中
 */
- (BOOL)isViewAddWindowUp:(UIView*)myView{
    // 如果本控制器的view显示在最前面，就下拉刷新（必须要判断，否点击其他tabbar也会触发刷新）
    // 判断一个view是否显示在根窗口上，该方法在UIView的分类中实现
    // 把这个view在它的父控件中的frame(即默认的frame)转换成在window的frame
    CGRect convertFrame = [myView.superview convertRect:myView.frame toView: [UIApplication sharedApplication].keyWindow];
    CGRect windowBounds = [UIApplication sharedApplication].keyWindow.bounds;
    // 判断这个控件是否在主窗口上（即该控件和keyWindow有没有交叉）
    BOOL isOnWindow = CGRectIntersectsRect(convertFrame, windowBounds);
    // 再判断这个控件是否真正显示在窗口范围内（是否在窗口上，是否为隐藏，是否透明）
    BOOL isShowingOnWindow = (myView.window == [UIApplication sharedApplication].keyWindow) && !myView.isHidden && (myView.alpha > 0.01) && isOnWindow;
    
    return isShowingOnWindow;
}


#pragma mark -scrollView delegate---下拽关闭
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.subImageView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIPanGestureRecognizer * subScrollViewPan = [scrollView panGestureRecognizer];
    _touchFingerNumber = subScrollViewPan.numberOfTouches;
    _subScrollView.clipsToBounds = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //只有是一根手指事件才做出响应。
    if (contentOffsetY < 0 && _touchFingerNumber == 1) {
        [self changeSizeCenterY:contentOffsetY];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if ((contentOffsetY<0 && _touchFingerNumber==1) && (velocity.y<0 && fabs(velocity.y)>fabs(velocity.x))) {
         [self stopPlayRemoView];//停止播放
        //如果是向下滑动才触发消失的操作。
        if ([self.deleagte respondsToSelector:@selector(imageBrowserSubViewSingleTapWithModel:)]) {
            [self.deleagte imageBrowserSubViewSingleTapWithModel:_imageBrowserModel];
        }
    } else {
        [self changeSizeCenterY:0.0];
        CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        self.subImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }
    _touchFingerNumber = 0;
    self.subScrollView.clipsToBounds = YES;
}

- (void)changeSizeCenterY:(CGFloat)contentOffsetY {
    //contentOffsetY 为负值
    CGFloat multiple = (Screen_Height + contentOffsetY*1.75)/Screen_Height;
    if ([self.deleagte respondsToSelector:@selector(imageBrowserSubViewTouchMoveChangeMainViewAlpha:)]) {
        [self.deleagte imageBrowserSubViewTouchMoveChangeMainViewAlpha:multiple];
    }
    multiple = multiple>0.4?multiple:0.4;
    self.subScrollView.transform = CGAffineTransformMakeScale(multiple, multiple);
    self.subScrollView.center = CGPointMake(Screen_Width/2, Screen_Height/2 - contentOffsetY*0.5);
}

#pragma mark -lazy
- (UIScrollView *)subScrollView {
    if (_subScrollView == nil) {
        _subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        _subScrollView.delegate = self;
        _subScrollView.bouncesZoom = YES;
        _subScrollView.maximumZoomScale = 2.5;//最大放大倍数
        _subScrollView.minimumZoomScale = 1.0;//最小缩小倍数
        _subScrollView.multipleTouchEnabled = YES;
        _subScrollView.scrollsToTop = NO;
        _subScrollView.contentSize = CGSizeMake(Screen_Width, Screen_Height);
        _subScrollView.userInteractionEnabled = YES;
        _subScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _subScrollView.delaysContentTouches = NO;//默认yes  设置NO则无论手指移动的多么快，始终都会将触摸事件传递给内部控件；
        _subScrollView.canCancelContentTouches = NO; // 默认是yes
        _subScrollView.alwaysBounceVertical = YES;//设置上下回弹
        _subScrollView.showsVerticalScrollIndicator = NO;
        _subScrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            //表示只在ios11以上的版本执行
            _subScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _subScrollView;
}
- (UIImageView *)subImageView {
    if (_subImageView == nil) {
        _subImageView = [[UIImageView alloc] init];
        _subImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _subImageView;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
