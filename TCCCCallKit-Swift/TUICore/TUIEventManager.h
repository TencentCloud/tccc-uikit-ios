//
//  TUIEventManager.h
//  Pods
//
//  Created by gavinwjwang on 2024/3/4.
//

#ifndef TUIEventManager_h
#define TUIEventManager_h

#pragma mark - TUIEvent
/////////////////////////////////////////////////////////////////////////////////
//
//             Definition of TUIEvent, APIs
//
/////////////////////////////////////////////////////////////////////////////////

@protocol TUINotificationProtocol <NSObject>
@optional
- (void)onNotifyEvent:(NSString *)key subKey:(NSString *)subKey object:(nullable id)anObject param:(nullable NSDictionary *)param;

@end

@interface TUIEventManager : NSObject

+ (instancetype)shareInstance;

- (void)registerEvent:(NSString *)key subKey:(NSString *)subKey object:(id<TUINotificationProtocol>)object;
- (void)unRegisterEvent:(id<TUINotificationProtocol>)object;
- (void)unRegisterEvent:(nullable NSString *)key subKey:(nullable NSString *)subKey object:(nullable id<TUINotificationProtocol>)object;

- (void)notifyEvent:(NSString *)key subKey:(nullable NSString *)subKey object:(nullable id)object param:(nullable NSDictionary *)param;

@end

#endif /* TUIEventManager_h */
