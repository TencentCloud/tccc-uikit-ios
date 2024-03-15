//
//  GenerateTestUserToken.m
//  tccc-agent-ios-example
//
//  Created by gavinwjwang on 2023/6/9.
//
#import "GenerateTestUserToken.h"
#import <Foundation/Foundation.h>



@implementation GenerateTestUserToken

+ (void)genTestUserToken:(NSString *)userId completion:(CompletionHandler)completion
{
    NSMutableDictionary *obj = [@{@"secretId": SECRETID,
                                  @"secretKey": SECRETKEY,
                                  @"SeatUserId": userId,
                                  @"isTest": @(false),
                                  @"SdkAppId": @(SDKAppID),
                                } mutableCopy];
    [self sendJSONPostRequestWithJSON:obj completion:completion];
}

+ (void)sendJSONPostRequestWithJSON:(NSDictionary *)jsonParams completion:(CompletionHandler)completion {
    // 将字典转换为JSON数据
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonParams options:0 error:&error];
    if (!jsonData) {
        NSLog(@"JSON序列化出错: %@", error.localizedDescription);
        if (completion) {
            completion(nil, error);
        }
        return;
    }

    // 创建URL
    NSURL *url = [NSURL URLWithString:@"https://tccc-gavin-5g19jovqc598f12b-1258344699.ap-guangzhou.app.tcloudbase.com/tccc-agent"];

    // 创建URLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = jsonData;

    // 创建NSURLSessionDataTask，执行请求
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            // 请求失败，异步回调
            if (completion) {
                completion(nil, error);
            }
            return;
        }

        // 请求成功，解析返回的JSON数据
        NSError *jsonError;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!responseJSON) {
            NSLog(@"JSON解析出错: %@", jsonError.localizedDescription);
            if (completion) {
                completion(nil, jsonError);
            }
            return;
        }

        // 回到主线程异步回调解析后的数据
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // long errorCode = responseJSON[@"errorCode"];
                NSNumber *errorCode = [responseJSON objectForKey:@"errorCode"];
                NSString *errorMessage = responseJSON[@"errorMessage"];
                if ([errorCode longValue] == 0) {
                    NSString *token = responseJSON[@"Token"];
                    completion(token, nil);
                } else {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"get token failed.", nil)};
                    NSError *error = [NSError errorWithDomain:errorMessage code:1001 userInfo:userInfo];
                    completion(errorMessage, error);
                }
            });
        }
    }];

    // 开始执行任务
    [dataTask resume];
}

@end
