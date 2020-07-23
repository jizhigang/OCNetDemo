//
//  TMHomeTopicModel.m
//  滕门全知道
//
//  Created by 纪志刚 on 2018/3/28.
//  Copyright © 2018年 ivygate. All rights reserved.
//

#import "TMHomeTopicModel.h"

@implementation TMHomeTopicModel


/**
 请求话题列表
 
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
+ (void)requestTopicListSucc:(void(^)(NSArray *topicArr))succ fail:(void(^)(NSString *errStr))fail {
    [HLNetWorkingTool TMGetUrl:@"你的网络请求地址" params:@{} isShowLoading:YES isCancleResponsed:YES isCanCancleTask:YES succ:^(NSDictionary *resultDic, NSDictionary *resultResponse) {
        id resultArr = [resultDic objectForKey:KunifiedKey];
        if (resultArr && [resultArr isKindOfClass:[NSArray class]]) {
            NSArray *arr = [TMHomeTopicModel mj_objectArrayWithKeyValuesArray:resultArr];
            succ(arr);
        }else{
            fail(KResponseFail);
        }
    } fail:^(NSString *errStr, NSError *error, NSDictionary *errResponse) {
        fail(errStr);
    }];
}


@end
