//
//  LZImageBrowserSubView.h
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXLZImageBrowserModel;

@protocol LZImageBrowserSubViewDelegate <NSObject>
/* 单击 后的操作 */
- (void)imageBrowserSubViewSingleTapWithModel:(CXLZImageBrowserModel *)imageBrowserModel;
/* 改变主视图 的 透明度 */
- (void)imageBrowserSubViewTouchMoveChangeMainViewAlpha:(CGFloat)alpha;

@end

@interface CXLZImageBrowserSubView : UIView

@property(nonatomic,weak)id<LZImageBrowserSubViewDelegate> deleagte;

- (id)initWithFrame:(CGRect)frame ImageBrowserModel:(CXLZImageBrowserModel *)imageBrowserModel;

@end
