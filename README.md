# OCNetDemo
OC网络请求
开发时习惯将接口返回的json数据转化为我们自己的model类来使用，那么将json解析和转model封装起来，网络请求成功直接返回可以用的model是我要达到的目的，使用AFNetworking配合MJExtension来实现
### 一、AFHTTPSessionManager单例对象
如果每次网络请求都生成一个AFHTTPSessionManager对象会增加系统开销，我们可以用单例实现全局只有一个AFHTTPSessionManager对象，这样做的好处不仅可以解决系统开销同时也方便维护。
假设我们有版本检查的接口，那么在检测到app需要升级时希望用户不在调用其他接口，已经调用还没返回数据的接口最好也可以终止掉，那么通过AFHTTPSessionManager对象的tasks属性就可以实现，后面会介绍到，先上代码
```
//
//  HLNetManager.h
//  HLCommunity
//
//  Created by 纪志刚 on 2017/6/14.
//  Copyright © 2017年 纪志刚  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLNetManager : NSObject


/**
 获取AFHTTPSessionManager的单利类

 @return AFHTTPSessionManager单利对象
 */
+ (AFHTTPSessionManager *)shareManager:(NSTimeInterval)timeOutInt;

@end


```

```
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

```

使用方法
```
    AFHTTPSessionManager *theManager = [HLNetManager shareManager:uploadTimeOutInt];
```

ps: `uploadTimeOutInt `是网络超时时间

### 二、通过AFHTTPSessionManager对象进行网络请求并持有网络请求的tasks

通过阅读AFNetworking的源码可以看到每一次网络请求会生成一个NSURLSessionDataTask对象，通过这个对象我们就可以实现撤回网络请求的功能

```
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

```

这里需要介绍一下这两个参数
- isCancleResponsed 是否取消其他网络请求
如果设置为YES，那么尚未结束的并且设置isCanCancleTask=YES的网络请求会被撤回
- isCanCancleTask 是否可以被其他网络请求取消
当前网络请求是否可以被撤回


这里我们用referenceCountChangeFun方法解决多个网络请求loading显示不正确的问题
<https://www.jianshu.com/p/5bbc277d206f>

![3305752-4f806f85ec4294eb.png](https://upload-images.jianshu.io/upload_images/3305752-61bf85058c101d49.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 三、使用
我们同时调用四个网络请求方法
```
//点击开始网络请求
- (void) didClicked{
     
        MJWeakSelf
        [TMHomeTopicModel requestTopicListSucc:^(NSArray *topicArr) {
            weakSelf.lab1.text = @"网络请求1成功";
        } fail:^(NSString *errStr) {
            weakSelf.lab1.text = [NSString stringWithFormat:@"网络请求1失败：%@",errStr];
        }];
        
            [TMHomeTopicModel requestTopicListSucc:^(NSArray *topicArr) {
                weakSelf.lab2.text = @"网络请求2成功";
            } fail:^(NSString *errStr) {
                weakSelf.lab2.text = [NSString stringWithFormat:@"网络请求2失败：%@",errStr];
            }];
        
            [TMHomeTopicModel requestTopicListSucc:^(NSArray *topicArr) {
                weakSelf.lab3.text = @"网络请求3成功";
            } fail:^(NSString *errStr) {
                weakSelf.lab3.text = [NSString stringWithFormat:@"网络请求3失败：%@",errStr];
            }];
        
            [TMHomeTopicModel requestTopicListSucc:^(NSArray *topicArr) {
                weakSelf.lab4.text = @"网络请求4成功";
            } fail:^(NSString *errStr) {
                weakSelf.lab4.text = [NSString stringWithFormat:@"网络请求4失败：%@",errStr];
            }];
}
```

如果我们将isCancleResponsed和isCanCancleTask都设置为NO，那么这四个网络请求相互之间没有影响

![WechatIMG597.png](https://upload-images.jianshu.io/upload_images/3305752-6d32261b33743cb9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


如果我们将isCancleResponsed设置为YES将isCanCancleTask设置为NO，那么每一个网络请求都想撤回其他网络请求，但是其他网络请求都不让他撤回，于是结果还是

![WechatIMG598.png](https://upload-images.jianshu.io/upload_images/3305752-212e03b75e14433e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


如果我们将isCancleResponsed和isCanCancleTask都设置为YES，那么后边的网络请求想撤回前边的还没完成的网络请求，前边的还没完成的网络请求也乐意被后边的撤回，于是效果为
![WechatIMG599.png](https://upload-images.jianshu.io/upload_images/3305752-1a803262a2f9e14d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 四、MJExtension介绍
使用MJExtension实现json转model，教程很多，基础用法这里不在赘述
<https://www.jianshu.com/p/1efa3c2ffde3>
<https://www.jianshu.com/p/99aaf2e85432>
<https://www.cnblogs.com/Acee/p/10930008.html>

有两点需要注意
1. 如果数组中的内容是自定义对象类型，需要注明
```
+(NSDictionary *)mj_objectClassInArray
{
    return @{
          @"topics":@"TMHomeListTopicsArrModel",
          @"数组":@"数组中的类型"
    };
}
```

2. 想要重命名某个字段，例如后台返回id我们不能直接声明id属性
```
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
```
