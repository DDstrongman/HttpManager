//
//  DDHttpManager.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/21.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "DDHttpManager.h"

@implementation DDHttpManager

+ (DDHttpManager *) ShareInstance {
    static DDHttpManager *sharedHttpManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHttpManagerInstance = [[self alloc] init];
    });
    return sharedHttpManagerInstance;
}
#pragma mark - methods
- (void)commonHeadersForHttp:(AFHTTPSessionManager *)manager {
    if (_commonHeader) {
        [[_commonHeader allKeys] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:_commonHeader[obj] forHTTPHeaderField:obj];
        }];
    }
}

- (void)AFNetMethodsSupport:(NSString *)url
                 Parameters:(NSDictionary *)dic
                     Method:(DDHttpMethodType)method
              RequestMethod:(DDRequestType)request
                SucessBlock:(void (^)(id))success
                FailedBlock:(void (^)(NSError *))failure {
    [self AFNetMethodsSupport:url
                   Parameters:dic
                       Method:method
                RequestMethod:request
                    HeaderDic:nil
                  SucessBlock:success
                  FailedBlock:failure];
}

- (void)AFNetMethodsSupport:(NSString *)url
                 Parameters:(NSDictionary *)dic
                     Method:(DDHttpMethodType)method
              RequestMethod:(DDRequestType)request
                  HeaderDic:(NSDictionary *)header
                SucessBlock:(void (^)(id))success
                FailedBlock:(void (^)(NSError *))failure {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [self initRequestType:session RequestType:request];
    
    [self commonHeadersForHttp:session];
    [self addHttpHeader:header
              AFManager:session];
    
    
    [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    switch (method) {
        case DDHttpGet: {
            [session GET:url
              parameters:dic
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (success) {
                         success(responseObject);
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (failure) {
                         failure(error);
                     }
                 }];
        }
            break;
        case DDHttpPost: {
            [session POST:url
               parameters:dic
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (success) {
                          success(responseObject);
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (failure) {
                          failure(error);
                      }
                  }];
        }
            break;
        case DDHttpPut: {
            [session PUT:url
              parameters:dic
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (success) {
                         success(responseObject);
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (failure) {
                         failure(error);
                     }
                 }];
        }
            break;
        case DDHttpPatch: {
            [session PATCH:url
                parameters:dic
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       if (success) {
                           success(responseObject);
                       }
                   }
                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       if (failure) {
                           failure(error);
                       }
                   }];
        }
            break;
        case DDHttpDelete: {
            session.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
            [session DELETE:url
                 parameters:dic
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (success) {
                            success(responseObject);
                        }
                    }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
        }
            break;
            
        default: {
            [session GET:url
              parameters:dic
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (success) {
                         success(responseObject);
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (failure) {
                         failure(error);
                     }
                 }];
        }
            break;
    }
}
#pragma 没有加入progressBlock,需要过程中处理的话加入progressBlock
- (void)AFNetPOSTSupport:(NSString *)url
              Parameters:(NSDictionary *)dic
           RequestMethod:(DDRequestType)request
ConstructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))bodyblock
             SucessBlock:(void (^)(id))success
             FailedBlock:(void (^)(NSError *))failure {
    [self AFNetPOSTSupport:url
                Parameters:dic
                    Header:nil
             RequestMethod:request
 ConstructingBodyWithBlock:bodyblock
               SucessBlock:success
               FailedBlock:failure];
}

- (void)AFNetPOSTSupport:(NSString *)url
              Parameters:(NSDictionary *)dic
                  Header:(NSDictionary *)header
           RequestMethod:(DDRequestType)request
ConstructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))bodyblock
             SucessBlock:(void (^)(id))success
             FailedBlock:(void (^)(NSError *))failure {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [self initRequestType:session RequestType:request];
    
    [self commonHeadersForHttp:session];
    [self addHttpHeader:header
              AFManager:session];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else {
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [session POST:url
       parameters:dic
constructingBodyWithBlock:bodyblock
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (success) {
                  success(responseObject);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (failure) {
                  failure(error);
              }
          }];
}
#pragma mark - 因为afnetwork默认用muldata的格式传输，所以改传输方式
- (void)AFNetUrlPOSTSupport:(NSString *)url
                 Parameters:(NSDictionary *)dic
                SucessBlock:(void (^)(id))success
                FailedBlock:(void (^)(NSError *))failure {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else {
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSMutableURLRequest *formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                     URLString:url
                                                                                    parameters:dic
                                                                                         error:nil];
    [formRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self commonHeadersForHttp:manager];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer = responseSerializer;
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:formRequest
                                                   uploadProgress:nil
                                                 downloadProgress:nil
                                                completionHandler:^(NSURLResponse *_Nonnull response,id _Nullable responseObject,NSError *_Nullable error) {
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
#pragma mark - support methods
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
 新增AFNetwork设置http的头
 
 @param header 新增的http头的参数字典
 @param manager 设置头函数时候的对象
 */
- (void)addHttpHeader:(NSDictionary *)header AFManager:(AFHTTPSessionManager *)manager {
    if (header) {
        [[header allKeys] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:header[obj]
                             forHTTPHeaderField:obj];
        }];
    }
}

/**
 统一设置request

 @param session af的主体
 @param request request的种类
 */
- (void)initRequestType:(AFHTTPSessionManager *)session RequestType:(DDRequestType)request {
    switch (request) {
        case DDRequestHttp:
            session.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case DDRequestJson:
            session.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case DDRequestPlist:
            session.requestSerializer = [AFPropertyListRequestSerializer serializer];
            break;
        default:
            session.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
    }
    
    session.requestSerializer.timeoutInterval = 60;
}

@end
