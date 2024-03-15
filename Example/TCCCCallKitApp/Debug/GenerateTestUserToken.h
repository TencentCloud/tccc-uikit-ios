//
//  GenerateTestUserToken.h
//  tccc-agent-ios-example
//
//  Created by gavinwjwang on 2023/6/9.
//

/**
* 生成票据
*
* @note 请不要将如下代码发布到您的线上正式版本的 App 中，原因如下：
*
* 本文件中的代码虽然能够正确计算出 Token，但仅适合快速调通 SDK 的基本功能，不适合线上产品，
* 这是因为客户端代码中的 SECRETKEY 很容易被反编译逆向破解，尤其是 Web 端的代码被破解的难度几乎为零。
* 一旦您的密钥泄露，攻击者就可以计算出正确的 Token 来盗用您的腾讯云流量
*
* 正确的做法是将 Token 的计算代码和加密密钥放在您的业务服务器上，然后由 App 按需向您的服务器获取实时算出的 Token。
* 由于破解服务器的成本要高于破解客户端 App，所以服务器计算的方案能够更好地保护您的加密密钥。
*
* 文档：https://cloud.tencent.com/document/product/679/58260
*
*/
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
* 座席账号，格式为 ： xxx@qq.com
*/
static NSString * const USERID = @"";

/**
* 腾讯云联络中心 SDKAppId，需要替换为您自己账号下的 SDKAppId。
* 进入腾讯云联络中心[控制台](https://console.cloud.tencent.com/ccc ) 创建应用，即可看到 SDKAppId，
* 它是腾讯云用于区分客户的唯一标识。
*/
static const int SDKAppID = 0;

/**
* 计算签名用的加密密钥ID，[查看秘钥](https://console.cloud.tencent.com/cam/capi)
* 注意：该方案仅适用于调试Demo，正式上线前请将 UserSig 计算代码和密钥迁移到您的后台服务器上，以避免加密密钥泄露导致的流量盗用。
* 文档：https://cloud.tencent.com/document/product/679/58260
*/
static NSString * const SECRETID = @"";

/**
* 计算签名用的加密密钥Key，[查看秘钥](https://console.cloud.tencent.com/cam/capi)
* 注意：该方案仅适用于调试Demo，正式上线前请将 UserSig 计算代码和密钥迁移到您的后台服务器上，以避免加密密钥泄露导致的流量盗用。
* 文档：https://cloud.tencent.com/document/product/679/58260
*/
static NSString * const SECRETKEY = @"";

typedef void (^CompletionHandler)(NSString *token, NSError *error);

@interface GenerateTestUserToken : NSObject

/**
* 生成票据
*
* @note 请不要将如下代码发布到您的线上正式版本的 App 中，原因如下：
*
* 本文件中的代码虽然能够正确计算出 Token，但仅适合快速调通 SDK 的基本功能，不适合线上产品，
* 这是因为客户端代码中的 SECRETKEY 很容易被反编译逆向破解，尤其是 Web 端的代码被破解的难度几乎为零。
* 一旦您的密钥泄露，攻击者就可以计算出正确的 Token 来盗用您的腾讯云流量
*
* 正确的做法是将 Token 的计算代码和加密密钥放在您的业务服务器上，然后由 App 按需向您的服务器获取实时算出的 Token。
* 由于破解服务器的成本要高于破解客户端 App，所以服务器计算的方案能够更好地保护您的加密密钥。
*
* 文档：https://cloud.tencent.com/document/product/679/58260
*
*/
+ (void)genTestUserToken:(NSString *)userId completion:(CompletionHandler)completion;

+ (void)sendJSONPostRequestWithJSON:(NSDictionary *)jsonParams completion:(CompletionHandler)completion;
@end

NS_ASSUME_NONNULL_END

