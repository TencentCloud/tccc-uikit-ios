//
//  THelper.m
//  TUIKit
//
//  Created by kennethmiao on 2018/11/1.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <SDWebImage/SDImageCoderHelper.h>
#import "TUIGlobalization.h"
#import "TUIWeakProxy.h"
#import "TUIDefine.h"
#import "UIView+TUIToast.h"


@implementation TUITool

static NSMutableDictionary * gIMErrorMsgMap = nil;

+ (void)initialize {

}
+ (void)configIMErrorMap {
   
}

+ (NSData *)dictionary2JsonData:(NSDictionary *)dict {
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        if (error) {
            NSLog(@"[%@] Post Json Error", [self class]);
        }
        return data;
    } else {
        NSLog(@"[%@] Post Json is not valid", [self class]);
    }
    return nil;
}

+ (NSString *)dictionary2JsonStr:(NSDictionary *)dict {
    return [[NSString alloc] initWithData:[self dictionary2JsonData:dict] encoding:NSUTF8StringEncoding];
    ;
}

+ (NSDictionary *)jsonSring2Dictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err || ![dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Json parse failed: %@", jsonString);
        return nil;
    }
    return dic;
}

+ (NSDictionary *)jsonData2Dictionary:(NSData *)jsonData {
    if (jsonData == nil) {
        return nil;
    }
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err || ![dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Json parse failed");
        return nil;
    }
    return dic;
}

+ (void)asyncDecodeImage:(NSString *)path complete:(TAsyncImageComplete)complete {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      queue = dispatch_queue_create("com.tuikit.asyncDecodeImage", DISPATCH_QUEUE_SERIAL);
    });

    // callback on main thread
    void (^callback)(NSString *, UIImage *) = ^(NSString *path, UIImage *image) {
      if (complete == nil) {
          return;
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        complete(path, image);
      });
    };

    if (path == nil) {
        callback(nil, nil);
        return;
    }

    dispatch_async(queue, ^{
      // 路径结尾明确是.gif
      // The path ends with gif:
      if ([path containsString:@".gif"]) {
          UIImage *image = [UIImage sd_imageWithGIFData:[NSData dataWithContentsOfFile:path]];
          callback(path, image);
          return;
      }

      // load origin image
      UIImage *image = [UIImage imageNamed:path];
      if (image == nil) {
          image = [UIImage imageWithContentsOfFile:path];
      }

      // 没有路径结尾，但实际可能是gif图片
      // There is no path ending, but it may actually be a gif image
      if (image == nil) {
         NSString *formatPath = [path stringByAppendingString:@".gif"];
         image = [UIImage sd_imageWithGIFData:[NSData dataWithContentsOfFile:formatPath]];
         callback(formatPath, image);
         return;
      }
        
      if (image == nil) {
          callback(path, image);
          return;
      }

      // SDWebImage is priority
      UIImage *decodeImage = [SDImageCoderHelper decodedImageWithImage:image];
      if (decodeImage) {
          callback(path, decodeImage);
          return;
      }

      // Bitmap
      CGImageRef cgImage = image.CGImage;
      if (cgImage) {
          CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage) & kCGBitmapAlphaInfoMask;
          BOOL hasAlpha = NO;
          if (alphaInfo == kCGImageAlphaPremultipliedLast || alphaInfo == kCGImageAlphaPremultipliedFirst || alphaInfo == kCGImageAlphaLast ||
              alphaInfo == kCGImageAlphaFirst) {
              hasAlpha = YES;
          }
          CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
          bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
          size_t width = CGImageGetWidth(cgImage);
          size_t height = CGImageGetHeight(cgImage);
          CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
          if (context) {
              CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
              cgImage = CGBitmapContextCreateImage(context);
              decodeImage = [UIImage imageWithCGImage:cgImage scale:image.scale orientation:image.imageOrientation];
              CGContextRelease(context);
              CGImageRelease(cgImage);
          }
      }
      callback(path, decodeImage);
    });
}

+ (void)makeToast:(NSString *)str {
    if ([TUIConfig defaultConfig].enableToast) {
        [[UIApplication sharedApplication].keyWindow makeToast:str];
    }
}

+ (void)makeToast:(NSString *)str duration:(NSTimeInterval)duration {
    if ([TUIConfig defaultConfig].enableToast) {
        [[UIApplication sharedApplication].keyWindow makeToast:str duration:duration];
    }
}

+ (void)makeToast:(NSString *)str duration:(NSTimeInterval)duration position:(CGPoint)position {
    if ([TUIConfig defaultConfig].enableToast) {
        [[UIApplication sharedApplication].keyWindow makeToast:str duration:duration position:[NSValue valueWithCGPoint:position]];
    }
}

+ (void)makeToast:(NSString *)str duration:(NSTimeInterval)duration idposition:(id)position {
    if ([TUIConfig defaultConfig].enableToast) {
        [[UIApplication sharedApplication].keyWindow makeToast:str duration:duration position:position];
    }
}

+ (void)makeToastError:(NSInteger)error msg:(NSString *)msg {
    if ([TUIConfig defaultConfig].enableToast) {
        [[UIApplication sharedApplication].keyWindow makeToast:[self convertIMError:error msg:msg]];
    }
}

+ (void)hideToast {
    if ([TUIConfig defaultConfig].enableToast) {
        [[UIApplication sharedApplication].keyWindow hideToast];
    }
}

+ (void)makeToastActivity {
    if ([TUIConfig defaultConfig].enableToast) {
        [[UIApplication sharedApplication].keyWindow makeToastActivity:TUICSToastPositionCenter];
    }
}

+ (void)hideToastActivity {
    if ([TUIConfig defaultConfig].enableToast) {
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }
}

+ (NSString *)convertDateToStr:(NSDate *)date {
    if (!date) {
        return nil;
    }

    if ([date isEqualToDate:[NSDate distantPast]]) {
        return @"";
    }

    static NSDateFormatter *dateFmt = nil;
    if (dateFmt == nil) {
        dateFmt = [[NSDateFormatter alloc] init];
    }
    dateFmt.locale = nil;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = 7;
    NSDateComponents *nowComponent = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekOfMonth
                                                 fromDate:NSDate.new];
    NSDateComponents *dateCompoent = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekOfMonth
                                                 fromDate:date];

    if (nowComponent.year == dateCompoent.year) {
        // Same year
        if (nowComponent.month == dateCompoent.month) {
            // Same month
            if (nowComponent.weekOfMonth == dateCompoent.weekOfMonth) {
                // Same week
                if (nowComponent.day == dateCompoent.day) {
                    // Same day
                    dateFmt.dateFormat = @"HH:mm";
                } else {
                    // Not same day
                    dateFmt.dateFormat = @"EEEE";
                    NSString *identifer = [TUIGlobalization getPreferredLanguage];
                    dateFmt.locale = [NSLocale localeWithLocaleIdentifier:identifer];
                }
            } else {
                // Not same weeek
                dateFmt.dateFormat = @"MM/dd";
            }
        } else {
            // Not same month
            dateFmt.dateFormat = @"MM/dd";
        }
    } else {
        // Not same year
        dateFmt.dateFormat = @"yyyy/MM/dd";
    }

    NSString *str = [dateFmt stringFromDate:date];
    return str;
}

+ (NSString *)convertDateToHMStr:(NSDate *)date {
    if (!date) {
        return nil;
    }

    if ([date isEqualToDate:[NSDate distantPast]]) {
        return @"";
    }

    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"HH:mm";
    NSString *str = [dateFmt stringFromDate:date];
    return str;
}

+ (NSString *)convertIMError:(NSInteger)code msg:(NSString *)msg {
    NSString  *resultMsg = @"";
    resultMsg = gIMErrorMsgMap[@(code)];
    if (resultMsg.length > 0) {
        return resultMsg;
    }
    return msg;
}

+ (void)dispatchMainAsync:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}



+ (NSString *)deviceModel {
    static NSString *deviceModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      deviceModel = [[UIDevice currentDevice] model];
    });
    return deviceModel;
}

+ (NSString *)deviceVersion {
    static NSString *deviceVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      deviceVersion = [[UIDevice currentDevice] systemVersion];
    });
    return deviceVersion;
}

+ (NSString *)deviceName {
    static NSString *deviceName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      deviceName = [[UIDevice currentDevice] name];
    });
    return deviceName;
}

+ (void)openLinkWithURL:(NSURL *)url {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url
                                           options:@{}
                                 completionHandler:^(BOOL success) {
                                   if (success) {
                                       NSLog(@"Opened url");
                                   }
                                 }];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (void)addUnsupportNotificationInVC:(UIViewController *)vc {
    [self addUnsupportNotificationInVC:vc debugOnly:YES];
}

+ (void)addUnsupportNotificationInVC:(UIViewController *)vc debugOnly:(BOOL)debugOnly {
    BOOL enable = YES;
    if (debugOnly) {
#if DEBUG
        enable = YES;
#else
        enable = NO;
#endif
    }

    if (!enable) {
        return;
    }
    TUIWeakProxy *weakVC = [TUIWeakProxy proxyWithTarget:vc];
    [[NSNotificationCenter defaultCenter] addObserverForName:TUIKitNotification_onReceivedUnsupportInterfaceError
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *_Nonnull note) {
                                                    NSDictionary *userInfo = note.userInfo;
                                                    NSString *service = [userInfo objectForKey:@"service"];
                                                    NSString *serviceDesc = [userInfo objectForKey:@"serviceDesc"];
                                                    if (weakVC.target) {
                                                        [TUITool showUnsupportAlertOfService:service serviceDesc:serviceDesc onVC:weakVC.target];
                                                    }
                                                  }];
}

+ (void)postUnsupportNotificationOfService:(NSString *)service {
    [self postUnsupportNotificationOfService:service serviceDesc:nil debugOnly:YES];
}

+ (void)postUnsupportNotificationOfService:(NSString *)service serviceDesc:(NSString *)serviceDesc debugOnly:(BOOL)debugOnly {
    BOOL enable = YES;
    if (debugOnly) {
#if DEBUG
        enable = YES;
#else
        enable = NO;
#endif
    }

    if (!enable) {
        return;
    }

    if (!service) {
        NSLog(@"postNotificationOfService, service is nil");
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onReceivedUnsupportInterfaceError
                                                        object:nil
                                                      userInfo:@{@"service" : service ?: @"", @"serviceDesc" : serviceDesc ?: @""}];
}

+ (void)showUnsupportAlertOfService:(NSString *)service serviceDesc:(NSString *)serviceDesc onVC:(UIViewController *)vc {
    NSString *key = [NSString stringWithFormat:@"show_unsupport_alert_%@", service];
    BOOL isShown = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if (isShown) {
        return;
    }
    NSString *desc = [NSString stringWithFormat:@"%@%@%@", service, TUIKitLocalizableString(TUIKitErrorUnsupportIntefaceDesc), serviceDesc ?: @""];
    NSArray *buttons = @[ TUIKitLocalizableString(TUIKitErrorUnsupportIntefaceIGotIt), TUIKitLocalizableString(TUIKitErrorUnsupportIntefaceNoMoreAlert) ];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TUIKitLocalizableString(TUIKitErrorUnsupportIntefaceTitle)
                                                                             message:desc
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:desc];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, desc.length)];
    [attrStr addAttribute:NSLinkAttributeName value:@"https://" range:[desc rangeOfString:TUIKitLocalizableString(TUIKitErrorUnsupportIntefaceGuidelines)]];
    [alertController setValue:attrStr forKey:@"attributedMessage"];
    UILabel *msgLabel = [TUITool messageLabelInAlertController:alertController];
    msgLabel.userInteractionEnabled = YES;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:TUITool.class action:@selector(onTapLabel:)];
    [msgLabel addGestureRecognizer:tap];

    UIAlertAction *left = [UIAlertAction actionWithTitle:buttons[0]
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *_Nonnull action){
                                                 }];
    UIAlertAction *right = [UIAlertAction actionWithTitle:buttons[1]
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *_Nonnull action) {
                                                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                  }];
    [alertController tuitheme_addAction:left];
    [alertController tuitheme_addAction:right];
    [vc presentViewController:alertController animated:NO completion:nil];
}

+ (void)onTapLabel:(UIGestureRecognizer *)ges {
    NSString *chinesePurchase = @"https://cloud.tencent.com/document/product/269/11673#.E5.9F.BA.E7.A1.80.E6.9C.8D.E5.8A.A1.E8.AF.A6.E6.83.85";
    NSString *englishPurchase = @"https://intl.cloud.tencent.com/document/product/1047/36021?lang=en&pg=#changing-configuration";
    NSString *language = [TUIGlobalization tk_localizableLanguageKey];
    NSURL *url = [NSURL URLWithString:chinesePurchase];
    if (![language containsString:@"zh-"]) {
        url = [NSURL URLWithString:englishPurchase];
    }
    [TUITool openLinkWithURL:url];
}

+ (void)addValueAddedUnsupportNeedContactNotificationInVC:(UIViewController *)vc debugOnly:(BOOL)debugOnly {
    BOOL enable = YES;
    if (debugOnly) {
#if DEBUG
        enable = YES;
#else
        enable = NO;
#endif
    }
    if (!enable) {
        return;
    }

    [[NSNotificationCenter defaultCenter] addObserverForName:TUIKitNotification_onReceivedValueAddedUnsupportContactNeededError
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *_Nonnull note) {
        NSDictionary *userInfo = note.userInfo;
        NSString *service = [userInfo objectForKey:@"service"];
        [TUITool showValueAddedUnsupportNeedContactAlertOfService:service onVC:vc];
    }];
}

+ (void)addValueAddedUnsupportNeedPurchaseNotificationInVC:(UIViewController *)vc debugOnly:(BOOL)debugOnly {
    BOOL enable = YES;
    if (debugOnly) {
#if DEBUG
        enable = YES;
#else
        enable = NO;
#endif
    }
    if (!enable) {
        return;
    }

    [[NSNotificationCenter defaultCenter] addObserverForName:TUIKitNotification_onReceivedValueAddedUnsupportPurchaseNeededError
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *_Nonnull note) {
        NSDictionary *userInfo = note.userInfo;
        NSString *service = [userInfo objectForKey:@"service"];
        [TUITool showValueAddedUnsupportNeedPurchaseAlertOfService:service onVC:vc];
    }];
}

+ (void)postValueAddedUnsupportNeedContactNotification:(NSString *)service {
    [self postValueAddedUnsupportNotification:TUIKitNotification_onReceivedValueAddedUnsupportContactNeededError
                                      service:service
                                  serviceDesc:nil
                                    debugOnly:YES];
}

+ (void)postValueAddedUnsupportNeedPurchaseNotification:(NSString *)service {
    [self postValueAddedUnsupportNotification:TUIKitNotification_onReceivedValueAddedUnsupportPurchaseNeededError
                                      service:service
                                  serviceDesc:nil
                                    debugOnly:YES];
}

+ (void)postValueAddedUnsupportNotification:(NSString *)notification service:(NSString *)service serviceDesc:(NSString *)serviceDesc debugOnly:(BOOL)debugOnly {
    BOOL enable = YES;
    if (debugOnly) {
#if DEBUG
        enable = YES;
#else
        enable = NO;
#endif
    }

    if (!enable) {
        return;
    }

    if (!service) {
        NSLog(@"postNotificationOfService, service is nil");
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notification
                                                        object:nil
                                                      userInfo:@{@"service" : service ?: @"",
                                                                 @"serviceDesc" : serviceDesc ?: @""}];
}

+ (void)showValueAddedUnsupportNeedContactAlertOfService:(NSString *)service onVC:(UIViewController *)vc {
    [self showValueAddedUnsupportAlertOfService:service
                                    serviceDesc:TUIKitLocalizableString(TUIKitErrorValueAddedUnsupportIntefaceContactDesc)
                                           onVC:vc
                                  highlightText:TUIKitLocalizableString(TUIKitErrorValueAddedUnsupportIntefaceContactDescHighlight)
                                            sel:@selector(onTapValueAddedContactLabel)];
}

+ (void)showValueAddedUnsupportNeedPurchaseAlertOfService:(NSString *)service onVC:(UIViewController *)vc {
    [self showValueAddedUnsupportAlertOfService:service
                                    serviceDesc:TUIKitLocalizableString(TUIKitErrorValueAddedUnsupportIntefacePurchaseDesc)
                                           onVC:vc
                                  highlightText:TUIKitLocalizableString(TUIKitErrorValueAddedUnsupportIntefacePurchaseDescHighlight)
                                            sel:@selector(onTapValueAddedPurchaseLabel)];
}

+ (void)showValueAddedUnsupportAlertOfService:(NSString *)service serviceDesc:(NSString *)serviceDesc onVC:(UIViewController *)vc 
                                highlightText:(NSString *)text sel:(SEL)selector {
    NSString *desc = [NSString stringWithFormat:@"%@%@", service, serviceDesc ?: @""];
    NSString *button = TUIKitLocalizableString(TUIKitErrorUnsupportIntefaceIGotIt);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TUIKitLocalizableString(TUIKitErrorUnsupportIntefaceTitle)
                                                                             message:desc
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:desc];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, desc.length)];
    [attrStr addAttribute:NSLinkAttributeName value:@"https://" range:[desc rangeOfString:text]];
    [alertController setValue:attrStr forKey:@"attributedMessage"];
    
    UILabel *msgLabel = [TUITool messageLabelInAlertController:alertController];
    msgLabel.userInteractionEnabled = YES;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:TUITool.class action:selector];
    [msgLabel addGestureRecognizer:tap];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:button
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *_Nonnull action){
                                               }];
    [alertController tuitheme_addAction:ok];
    [vc presentViewController:alertController animated:NO completion:nil];
}

+ (void)onTapValueAddedContactLabel {
    NSURL *url = [NSURL URLWithString:@"https://zhiliao.qq.com"];
    [TUITool openLinkWithURL:url];
}

+ (void)onTapValueAddedPurchaseLabel {
    NSURL *url = [NSURL URLWithString:@"https://buy.cloud.tencent.com/avc?activeId=plugin&regionId=1"];
    [TUITool openLinkWithURL:url];
}


+ (UILabel *)messageLabelInAlertController:(UIAlertController *)alert {
    UIView *target = [TUITool targetSubviewInAlertController:alert];
    NSArray *subviews = [target subviews];
    if (subviews.count == 0) {
        return nil;
    }
    for (UIView *view in subviews) {
        if ([view isKindOfClass:UILabel.class]) {
            UILabel *label = (UILabel *)view;
            if (label.text.length > 10) {
                return label;
            }
        }
    }
    return nil;
}

+ (UIView *)targetSubviewInAlertController:(UIAlertController *)alert {
    UIView *view = alert.view;
    for (int i = 0; i < 5; i++) {
        view = view.subviews.firstObject;
    }
    return view;
}

+ (UIWindow *)applicationKeywindow {
    UIWindow *keywindow = UIApplication.sharedApplication.keyWindow;
    if (keywindow == nil) {
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in UIApplication.sharedApplication.connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    UIWindow *tmpWindow = nil;
                    if (@available(iOS 15.0, *)) {
                        tmpWindow = scene.keyWindow;
                    }
                    if (tmpWindow == nil) {
                        for (UIWindow *window in scene.windows) {
                            if (window.windowLevel == UIWindowLevelNormal && window.hidden == NO &&
                                CGRectEqualToRect(window.bounds, UIScreen.mainScreen.bounds)) {
                                tmpWindow = window;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    if (keywindow == nil) {
        for (UIWindow *window in UIApplication.sharedApplication.windows) {
            if (window.windowLevel == UIWindowLevelNormal && window.hidden == NO && CGRectEqualToRect(window.bounds, UIScreen.mainScreen.bounds)) {
                keywindow = window;
                break;
            }
        }
    }
    return keywindow;
}

@end
