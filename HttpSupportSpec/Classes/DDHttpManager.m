//
//  DDHttpManager.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/21.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "DDHttpManager.h"

@implementation DDHttpManager

+ (HttpManager *) ShareInstance {
    static HttpManager *sharedHttpManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHttpManagerInstance = [[self alloc] init];
    });
    return sharedHttpManagerInstance;
}

- (void)AFNetGETSupport:(NSString *)url Parameters:(NSDictionary *)dic SucessBlock:(void (^)(id))success FailedBlock:(void (^)(NSError *))failure {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.requestSerializer.timeoutInterval = 60;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [session GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
#pragma 没有加入progressBlock,需要过程中处理的话加入progressBlock
- (void)AFNetPOSTSupport:(NSString *)url Parameters:(NSDictionary *)dic ConstructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))bodyblock SucessBlock:(void (^)(id))success FailedBlock:(void (^)(NSError *))failure {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.requestSerializer.timeoutInterval = 60;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else {
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [session POST:url parameters:dic constructingBodyWithBlock:bodyblock progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
#pragma mark - 因为afnetwork默认用muldata的格式传输，所以改传输方式
- (void)AFNetUrlPOSTSupport:(NSString *)url Parameters:(NSDictionary *)dic SucessBlock:(void (^)(id))success FailedBlock:(void (^)(NSError *))failure {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else {
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:dic error:nil];
    [formRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer = responseSerializer;
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:formRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *_Nonnull response,id _Nullable responseObject,NSError *_Nullable error) {
        if(error) {
            if (failure) {
                failure(error);
            }
        }
        if (responseObject && success) {
            success(responseObject);
        }
    }];
    
    [dataTask resume];
}

- (NSData *)httpGetSupport:(NSString *)urlString{
    //第一步，创建URL
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else {
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:3];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    
    //            其中缓存协议是个枚举类型包含：
    //
    //            NSURLRequestUseProtocolCachePolicy（基础策略）
    //
    //            NSURLRequestReloadIgnoringLocalCacheData（忽略本地缓存）
    //
    //            NSURLRequestReturnCacheDataElseLoad（首先使用缓存，如果没有本地缓存，才从原地址下载）
    //
    //            NSURLRequestReturnCacheDataDontLoad（使用本地缓存，从不下载，如果本地没有缓存，则请求失败，此策略多用于离线操作）
    //
    //            NSURLRequestReloadIgnoringLocalAndRemoteCacheData（无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载）
    //
    //            NSURLRequestReloadRevalidatingCacheData（如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载）
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return received;
}

- (NSData *)httpPostSupport:(NSString *)urlString PostName:(NSData *)fileData FileType:(NSString *)fileType FileTrail:(NSString *)fileTrail{
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else {
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:3];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@%@\"\r\n",fileTrail,[self gettime],@""]];
    //声明上传文件的格式
    [body appendFormat:[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",fileType]];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:fileData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return received;
}

- (NSString *)gettime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *strUrl = [currentDateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *newdate=[strUrl substringToIndex:8];
    return newdate;
}



/**
 AFNetwork设置http的头，当是get方法时，参数代入header,当是post方法时，只用设置基本用户信息
 
 @param headerDic get方式时，传给服务器的参数字典
 @param manager 设置头函数时候的对象
 */
- (void)initHttpHeader:(NSDictionary *)headerDic AFManager:(AFHTTPSessionManager *)manager {
    
}

@end
