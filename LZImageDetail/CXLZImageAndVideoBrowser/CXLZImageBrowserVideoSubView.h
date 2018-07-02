//
//  LZImageBrowserVideoSubView.h
//  LZImageDetail
//
//  Created by 爱恨的潮汐 on 2018/7/1.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//
//浏览视频
#import <UIKit/UIKit.h>
@class CXLZImageBrowserModel;
@protocol LZImageBrowserVideoSubViewDelegate <NSObject>
/* 单击 后的操作 */
- (void)imageBrowserSubViewSingleTapWithModel:(CXLZImageBrowserModel *)imageBrowserModel;
/* 改变主视图 的 透明度 */
- (void)imageBrowserSubViewTouchMoveChangeMainViewAlpha:(CGFloat)alpha;

@end

@interface CXLZImageBrowserVideoSubView : UIView
@property(nonatomic,weak)id<LZImageBrowserVideoSubViewDelegate> deleagte;

- (id)initWithFrame:(CGRect)frame ImageBrowserModel:(CXLZImageBrowserModel *)imageBrowserModel;
@end
