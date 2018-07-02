//
//  LZImageBrowserMainView.h
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXLZImageBrowserMainView : UIView

/*
 //初始化主视图,imageUrls格式如下案例
 NSArray * images = @[@{@"type":@"1",@"image":@"http://olxnvuztq.bkt.clouddn.com/s01.jpg"},
 @{@"type":@"2",@"image":@"http://olxnvuztq.bkt.clouddn.com/s02.jpg",@"videoUrl":@"http://tb-video.bdstatic.com/tieba-smallvideo/45_a68a54ff67c9db5bb05748e14c600a3b.mp4"},
 @{@"type":@"2",@"image":@"http://olxnvuztq.bkt.clouddn.com/s03.jpg",@"videoUrl":@"http://tb-video.bdstatic.com/videocp/16514218_b3883a9f1e041a181bda58804e0a5192.mp4"},
 @{@"type":@"1",@"image":@"http://olxnvuztq.bkt.clouddn.com/s04.jpg",@"videoUrl":@""},
 @{@"type":@"1",@"image":@"http://olxnvuztq.bkt.clouddn.com/s05.jpg",@"videoUrl":@""},
 @{@"type":@"1",@"image":@"http://olxnvuztq.bkt.clouddn.com/s06.jpg",@"videoUrl":@""},
 ];
 */


/**
 初始化主视图,imageUrls格式如下案例

 @param imageUrls 大图的下载地址
 @param originImageViews 原始的小图的 iamgeView
 @param selectPage 当前选中的是哪一个iamgeView
 @return 主视图
 */
+ (id)imageBrowserMainViewUrlStr:(NSArray<NSString *>*)imageUrls originImageViews:(NSArray<UIImageView *>*)originImageViews selectPage:(NSInteger)selectPage;

/**
 展示主视图的方法
 */
- (void)showImageBrowserMainView;

/**
 移除主视图的方法
 */
- (void)dismissImageBrowserMainView;




@end
