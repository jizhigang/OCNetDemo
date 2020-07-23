//
//  HLNetWorkingTool.m
//  HLCommunity
//
//  Created by asd on 2017/5/9.
//  Copyright © 2017年 任翰林. All rights reserved.
//

#import "HLNetWorkingTool.h"
#import "SVProgressHUD.h"
#import "HLNetManager.h"

@implementation HLNetWorkingTool





/**
 post网络请求 默认显示loading（isShowLoading=YES）  默认不取消之前所有网络请求(isCancleResponsed=NO)
 
 @param url 请求地址
 @param params 请求参数
 @param succ 请求成功
 @param fail 请求失败
 */
+ (void)TM_PostUrl:(NSString *)url params:(NSDictionary *)params succ:(void(^)(NSDictionary * resultDic, NSDictionary * resultResponse))succ fail:(void(^)(NSString *errStr,NSError *error, NSDictionary * errResponse))fail {
    [HLNetWorkingTool TMPostUrl:url params:params isShowLoading:YES isCancleResponsed:NO isCanCancleTask:YES succ:succ fail:fail];
}

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
+ (void)TMPostUrl:(NSString *)url params:(NSDictionary *)params isShowLoading:(BOOL)isShowLoading isCancleResponsed:(BOOL)isCancleResponsed isCanCancleTask:(BOOL)isCanCancleTask succ:(void(^)(NSDictionary * resultDic, NSDictionary * resultResponse))succ fail:(void(^)(NSString *errStr,NSError *error, NSDictionary * errResponse))fail {
    
    
    //拼接完整的url
    NSString *theUrl = [NSString stringWithFormat:@"%@",url];

    
    
    
    if (isCancleResponsed) {//取消之前所有的网络请求
        
        AFHTTPSessionManager *netManager = [HLNetManager shareManager:10];
        if (netManager.tasks && [netManager.tasks isKindOfClass:[NSArray class]] && netManager.tasks.count > 0) {
            for (NSURLSessionDataTask *task in [HLNetManager shareManager:defaultTimeOutInt].tasks) {
//                如果当前task为可取消状态，取消之，否则不取消
                if (![task.taskDescription isEqualToString:KunifiedKey]) {
                    [task cancel];
                }
            }
        }
    }
    
    if (isShowLoading) {//显示LOADING
        [HLNetWorkingTool referenceCountChangeFun:YES];
    }
    
//    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *theTask =
    [[HLNetManager shareManager:defaultTimeOutInt] POST:theUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [SVProgressHUD dismiss];
        if (isShowLoading) {//显示LOADING
            [HLNetWorkingTool referenceCountChangeFun:NO];
        }
        
        NSLog(@"succURL = %@, PARAMS = %@, responseObject = %@",theUrl ,params ,responseObject);

        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {//判断请求的数据结构是否正确
            if ([[responseObject objectForKey:@"errno"] integerValue] == 1) {//请求成功
                id responstDic = [responseObject objectForKey:@"rsm"];
                if (responstDic) {
                    if ([responstDic isKindOfClass:[NSDictionary class]]) {//当data时一个字典时
                        succ(responstDic,responseObject);
                    }else if([responstDic isKindOfClass:[NSString class]]){//当data时一个字符串时
                        NSDictionary *dic = @{KunifiedKey:responstDic};
                        succ(dic, responseObject);
                    }else if([responstDic isKindOfClass:[NSArray class]]){
                        NSDictionary *dic = @{KunifiedKey:responstDic};
                        succ(dic, responseObject);
                    }else{
                        NSString *responseStr = [NSString stringWithFormat:@"%@", responstDic];
                        NSDictionary *dic = [NSDictionary dictionaryWithObject:responseStr forKey:KunifiedKey];
                        succ(dic, responseObject);
                    }
                }else{
                    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"请求成功" forKey:KunifiedKey];
                    succ(dic, responseObject);
                }

            }else{
                fail([responseObject objectForKey:kresponseMsg],NULL,responseObject);

            }
        }else{
            fail(KResponseFail,NULL,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isShowLoading) {//显示LOADING
            [HLNetWorkingTool referenceCountChangeFun:NO];
        }
//         task取消返回-999
        if (error.code != -999) { //非手动取消
            fail(KResponseFail,error,nil);
        }else{//手动取消
            fail(@"手动取消了",error,nil);
        }
        
        NSLog(@"failURL = %@, PARAMS = %@, error = %@",theUrl ,params ,error);
    }];
    
    
    if (!isCanCancleTask) { //当前网络请求是不可取消的状态，例如 后台下载
        theTask.taskDescription = KunifiedKey;
    }
}




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
+ (void)TMUploadPostUrl:(NSString *)url params:(NSDictionary *)params name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType imageData:(NSData *)imageData isShowLoading:(BOOL)isShowLoading isCancleResponsed:(BOOL)isCancleResponsed isCanCancleTask:(BOOL)isCanCancleTask succ:(void(^)(NSDictionary * resultDic,NSDictionary * resultResponse))succ fail:(void(^)(NSString *errStr,NSError *error, NSDictionary * errResponse))fail{
    
    //在这里可以根据自己需求拼接网络请求
    NSString *theUrl = [NSString stringWithFormat:@"%@",url];

    
    if (isShowLoading) {//显示LOADING
        [HLNetWorkingTool referenceCountChangeFun:YES]; //LOADING的引用计数加1
    }
    
    //    __weak typeof(self) weakSelf = self;
    
    AFHTTPSessionManager *theManager = [HLNetManager shareManager:uploadTimeOutInt];
    
     [theManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *theTask =
    [theManager POST:theUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (isShowLoading) {
            [HLNetWorkingTool referenceCountChangeFun:NO];
        }
        
        NSLog(@"URL = %@, PARAMS = %@, responseObject = %@",theUrl ,params ,responseObject);
        
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {//请求成功

            if ([responseObject objectForKey:@"code"]) {

                if ([[responseObject objectForKey:@"code"] integerValue] == 0) {//成功
                    if ([responseObject objectForKey:@"data"]) {
                        if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                            succ([responseObject objectForKey:@"data"],responseObject);
                        }else{
                            NSDictionary *theDic = [NSDictionary dictionaryWithObject:[responseObject objectForKey:@"data"] forKey:KunifiedKey];
                            succ(theDic,responseObject);
                        }

                    }else{
                        succ(@{},responseObject);
                    }
                }else{
                    fail(KResponseFail,[NSError new],nil);
                }

            }

        }else{
            fail(KResponseFail,[NSError new],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // task取消返回-999
        if (error.code != -999) { //非手动取消
            fail(KResponseFail,error,nil);
        }else{//手动取消
            fail(@"手动取消了",error,nil);
        }

        if (isShowLoading) {
            [HLNetWorkingTool referenceCountChangeFun:NO];
        }
        
        NSLog(@"URL = %@, PARAMS = %@, error = %@",theUrl ,params ,error);
    }];
    if (!isCanCancleTask) { //当前网络请求是不可取消的状态，例如 后台下载
        theTask.taskDescription = KunifiedKey;
    }
    
}






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
+ (void)TMGetUrl:(NSString *)url params:(NSDictionary *)params isShowLoading:(BOOL)isShowLoading isCancleResponsed:(BOOL)isCancleResponsed isCanCancleTask:(BOOL)isCanCancleTask succ:(void(^)(NSDictionary * resultDic, NSDictionary * resultResponse))succ fail:(void(^)(NSString *errStr,NSError *error, NSDictionary * errResponse))fail {
    
    
    //拼接完整的url
    //    NSString *theUrl = [BaseUrlString stringByAppendingPathComponent:url];
//    NSString *theUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    NSString *theUrl = [NSString stringWithFormat:@"%@",url];

    if (isCancleResponsed) {//取消之前所有的网络请求
        
        AFHTTPSessionManager *netManager = [HLNetManager shareManager:defaultTimeOutInt];
        
        if (netManager.tasks && [netManager.tasks isKindOfClass:[NSArray class]] && netManager.tasks.count > 0) {
            for (NSURLSessionDataTask *task in [HLNetManager shareManager:defaultTimeOutInt].tasks) {
                            
//            如果当前task为可取消状态，取消之，否则不取消
                            if (![task.taskDescription isEqualToString:KunifiedKey]) {
                                [task cancel];
                            }
                        }
        }
    }
    
//    if (isShowLoading) {//显示LOADING
//        [SVProgressHUD show]; //LOADING的引用计数加1
//    }
    if (isShowLoading) {//显示LOADING
        [HLNetWorkingTool referenceCountChangeFun:YES];
    }
    
    //    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *theTask =
    [[HLNetManager shareManager:defaultTimeOutInt] GET:theUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [SVProgressHUD dismiss];
        if (isShowLoading) {//显示LOADING
            [HLNetWorkingTool referenceCountChangeFun:NO];
        }
        NSLog(@"succURL = %@, PARAMS = %@, responseObject = %@",theUrl ,params ,responseObject);
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {//判断请求的数据结构是否正确
            if ([[responseObject objectForKey:@"code"] integerValue] == 0) {//请求成功
                id responstDic = [responseObject objectForKey:@"data"];
                if (responstDic) {
                    if ([responstDic isKindOfClass:[NSDictionary class]]) {//当data时一个字典时
                        succ(responstDic,responseObject);
                    }else if([responstDic isKindOfClass:[NSString class]]){//当data时一个字符串时
                        NSDictionary *dic = @{KunifiedKey:responstDic};
                        succ(dic, responseObject);
                    }else if([responstDic isKindOfClass:[NSArray class]]){
                        NSDictionary *dic = @{KunifiedKey:responstDic};
                        succ(dic, responseObject);
                    }else{
                        NSString *responseStr = [NSString stringWithFormat:@"%@", responstDic];
                        NSDictionary *dic = [NSDictionary dictionaryWithObject:responseStr forKey:KunifiedKey];
                        succ(dic, responseObject);
                    }
                }else{
                    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"请求成功" forKey:KunifiedKey];
                    succ(dic, responseObject);
                }
                
            }else{
                fail([responseObject objectForKey:kresponseMsg],NULL,responseObject);
                
            }
        }else{
            fail(KResponseFail,NULL,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isShowLoading) {//显示LOADING
            [HLNetWorkingTool referenceCountChangeFun:NO];
        }
        //         task取消返回-999
        if (error.code != -999) { //非手动取消
            fail(KResponseFail,error,nil);
        }else{//手动取消
            fail(@"手动取消了",error,nil);
        }
        
        NSLog(@"failURL = %@, PARAMS = %@, error = %@",theUrl ,params ,error);
    }];
    
    
    
        if (!isCanCancleTask) { //当前网络请求是不可取消的状态，例如 后台下载
            theTask.taskDescription = KunifiedKey;
        }
    
}








/**
 管理loading的引用计数
 
 @param isAdd 有新的网络请求，需要做+1操作
 */
+ (void)referenceCountChangeFun:(BOOL)isAdd {
    
    
    
    if (!KNetReferenceCount) {
        KNetReferenceCount = 0;
    }
    
    if (isAdd) { //有新的网络请求
        KNetReferenceCount += 1;
        [[HLLoadingView shareInstance]showTitle:@"正在加载"];
        //        KSVPShowRequestState //开始loading
    }else{ //有网络请求结束了（成功/失败）
        KNetReferenceCount -= 1;
        if (KNetReferenceCount <= 0) {
            KNetReferenceCount = 0;
            //            KSVPDismiss //结束loading
            [[HLLoadingView shareInstance]dismissLoading];
        }
    }
    
}






@end
