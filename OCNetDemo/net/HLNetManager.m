//
//  HLNetManager.m
//  HLCommunity
//
//  Created by 纪志刚 on 2017/6/14.
//  Copyright © 2017年 任翰林. All rights reserved.
//

#import "HLNetManager.h"

@implementation HLNetManager

static AFHTTPSessionManager *manager;

/**
 获取AFHTTPSessionManager的单利类
 
 @return AFHTTPSessionManager单利对象
*/
+ (AFHTTPSessionManager *)shareManager:(NSTimeInterval)timeOutInt {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    [self setupHeaderWithManager:manager timeOutInt:timeOutInt];
    return manager;
}

+ (void)setupHeaderWithManager:(AFHTTPSessionManager *)manager timeOutInt:(NSTimeInterval)timeOutInt
{
    manager.requestSerializer.timeoutInterval = timeOutInt;//设置超时时间
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"If-None-Match"]; //解决404问题
}

@end
