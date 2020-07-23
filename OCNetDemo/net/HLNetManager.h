//
//  HLNetManager.h
//  HLCommunity
//
//  Created by 纪志刚 on 2017/6/14.
//  Copyright © 2017年 任翰林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLNetManager : NSObject


/**
 获取AFHTTPSessionManager的单利类

 @return AFHTTPSessionManager单利对象
 */
+ (AFHTTPSessionManager *)shareManager:(NSTimeInterval)timeOutInt;

@end
