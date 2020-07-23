//
//  HLNetWorkingTool.h
//  HLCommunity
//
//  Created by asd on 2017/5/9.
//  Copyright © 2017年 任翰林. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


#define BASE_URL @"http://zhihu.ivygate.cn/?/" /**< 网络请求*/
#define Photo_URL @"http://zhihu.ivy-gate.cn/" /**< 图片请求*/




@interface HLNetWorkingTool : AFHTTPSessionManager


/**
 post网络请求 默认显示loading（isShowLoading=YES）  默认不取消之前所有网络请求(isCancleResponsed=NO)
 
 @param url 请求地址
 @param params 请求参数
 @param succ 请求成功
 @param fail 请求失败
 */
+ (void)TM_PostUrl:(NSString *)url params:(NSDictionary *)params succ:(void(^)(NSDictionary * resultDic, NSDictionary * resultResponse))succ fail:(void(^)(NSString *errStr,NSError *error, NSDictionary * errResponse))fail;


/**
 post网络请求
 
 @param url 请求地址
 @param params 请求参数
 @param isShowLoading 是否显示loading
 @param isCancleResponsed 是否取消此前所有的网络请求
 @param isCanCancleTask 当前请求是否可取消，涉及到后台下载的情况设为不可取消 default yes可取消
 @param succ 请求成功 code = 0
 @param fail 请求失败 code ！= 0 (400/404没有连接到后台 和 后台返回的code！=0两种情况调用)
 */
+ (void)TMPostUrl:(NSString *)url params:(NSDictionary *)params isShowLoading:(BOOL)isShowLoading isCancleResponsed:(BOOL)isCancleResponsed isCanCancleTask:(BOOL)isCanCancleTask succ:(void(^)(NSDictionary * resultDic, NSDictionary * resultResponse))succ fail:(void(^)(NSString *errStr,NSError *error, NSDictionary * errResponse))fail;




/**
 post上传图片网络请求
 
 @param url 请求地址
 @param params 请求参数
 @param name name
 @param fileName 文件名称
 @param mimeType 类型
 @param imageData 图片文件
 @param isShowLoading 是否显示loading
 @param isCancleResponsed 是否取消此前所有的网络请求
 @param isCanCancleTask 当前请求是否可取消，涉及到后台下载的情况设为不可取消 default yes可取消
 @param succ 请求成功 code = 0
 @param fail 请求失败 code ！= 0 (400/404没有连接到后台 和 后台返回的code！=0两种情况调用)
 */
+ (void)TMUploadPostUrl:(NSString *)url params:(NSDictionary *)params name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType imageData:(NSData *)imageData isShowLoading:(BOOL)isShowLoading isCancleResponsed:(BOOL)isCancleResponsed isCanCancleTask:(BOOL)isCanCancleTask succ:(void(^)(NSDictionary * resultDic,NSDictionary * resultResponse))succ fail:(void(^)(NSString *errStr,NSError *error, NSDictionary * errResponse))fail;









/**
 get网络请求
 
 @param url 网络连接
 @param params 参数字典
 @param isShowLoading 是否显示loading
 @param isCancleResponsed 是否取消其他网络请求
 @param isCanCancleTask 是否可以被其他网络请求取消
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
+ (void)TMGetUrl:(NSString *)url params:(NSDictionary *)params isShowLoading:(BOOL)isShowLoading isCancleResponsed:(BOOL)isCancleResponsed isCanCancleTask:(BOOL)isCanCancleTask succ:(void(^)(NSDictionary * resultDic, NSDictionary * resultResponse))succ fail:(void(^)(NSString *errStr,NSError *error, NSDictionary * errResponse))fail;





@end
