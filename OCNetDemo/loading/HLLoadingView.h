//
//  HLLoadingView.h
//  loadingTest
//
//  Created by 纪志刚 on 2017/8/10.
//  Copyright © 2017年 纪志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLLoadingView : UIView


/**
 创建单利对象

 @return <#return value description#>
 */
+ (instancetype) shareInstance;





/**
 显示loading

 @param title loading标题
 */
- (void) showTitle:(NSString *)title;



/**
 loading去掉
 */
- (void) dismissLoading;


@end
