//
//  TMHomeTopicModel.h
//  滕门全知道
//
//  Created by 纪志刚 on 2018/3/28.
//  Copyright © 2018年 ivygate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMHomeTopicModel : NSObject


@property (nonatomic, strong) NSNumber * add_time; /**< 添加时间*/
@property (nonatomic, strong) NSNumber * discuss_count;/**< */
@property (nonatomic, strong) NSNumber * discuss_count_last_month; /**< */
@property (nonatomic, strong) NSNumber * discuss_count_last_week; /**< */
@property (nonatomic, strong) NSNumber * discuss_count_update; /**< */
@property (nonatomic, strong) NSNumber * flag; /**< */
@property (nonatomic, strong) NSNumber * focus_count; /**< */
@property (nonatomic, strong) NSNumber * is_parent; /**< 是否父级*/
@property (nonatomic, strong) NSNumber * listorder; /**< 排序*/
@property (nonatomic, strong) NSNumber * merged_id; /**< */
@property (nonatomic, strong) NSNumber * parent_id; /**< 父级ID*/
@property (nonatomic, strong) NSString * seo_title; /**< */
@property (nonatomic, strong) NSString * topic_description; /**< */
@property (nonatomic, strong) NSNumber * topic_id; /**< 话题ID*/
@property (nonatomic, strong) NSNumber * topic_lock; /**< 是否锁定*/
@property (nonatomic, strong) NSString * topic_pic; /**< */
@property (nonatomic, strong) NSString * topic_title; /**< 话题*/
@property (nonatomic, strong) NSString * url_token; /**< */
@property (nonatomic, strong) NSNumber * user_related; /**< */




/**
 请求话题列表

 @param succ <#succ description#>
 @param fail <#fail description#>
 */
+ (void)requestTopicListSucc:(void(^)(NSArray *topicArr))succ fail:(void(^)(NSString *errStr))fail;


@end
