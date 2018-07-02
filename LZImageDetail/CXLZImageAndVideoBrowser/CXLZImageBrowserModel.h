//
//  LZImageBrowserModel.h
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CXLZImageBrowserModel : NSObject
@property(nonatomic,copy)NSString * urlStr;
@property(nonatomic,assign)CGSize smallImageSize;
@property(nonatomic,weak)UIImageView * smallImageView;

@property(nonatomic,assign)CGSize bigImageSize;
@property(nonatomic,weak)UIImageView * bigImageView;
@property(nonatomic,weak)UIScrollView * bigScrollView;

@property(nonatomic,copy)NSString * type;//1代表图片，2代表视频
@property(nonatomic,copy)NSString * videoUrl;//视频播放连接

//检查当前的url是否已经存在
- (BOOL)isCacheImageKey:(NSString *)key;
//获取当前的image，如果有大图返回大图，无大图返回小图
- (UIImage *)getCurrentImage;

//在原始的window上的frame
- (CGRect)smallImageViewframeOriginWindow;
//图片放大后充满屏幕后的frame
- (CGRect)imageViewframeShowWindow;
//当前如果消失创建的iamge应该的frame
- (CGRect)bigImageViewFrameOnScrollView;

@end
