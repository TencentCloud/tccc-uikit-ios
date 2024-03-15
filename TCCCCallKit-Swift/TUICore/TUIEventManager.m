//
//  TUIEventManager.m
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/3/4.
//

#import <Foundation/Foundation.h>
#import "TUIEventManager.h"
#import "TUIWeakProxy.h"

#pragma mark - TUIEvent

@interface TUIEventManager ()

@property(nonatomic, strong) NSMutableArray<NSDictionary *> *eventList;

@end

@implementation TUIEventManager

+ (instancetype)shareInstance {
    static id instance = nil;
    if (instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
          instance = [[self alloc] init];
        });
    }
    return instance;
}

- (void)registerEvent:(NSString *)key subKey:(NSString *)subKey object:(id<TUINotificationProtocol>)object {
    NSAssert(key.length > 0, @"invalid key");
    NSAssert(object != nil, @"invalid object");

    if (subKey.length == 0) {
        subKey = @"";
    }

    if (key && subKey && object) {
        NSDictionary *event = @{@"key" : [key copy], @"subKey" : [subKey copy], @"object" : [TUIWeakProxy proxyWithTarget:object]};

        @synchronized(self.eventList) {
            [self.eventList addObject:event];
        }
    }
}

- (void)unRegisterEvent:(id<TUINotificationProtocol>)object {
    [self unRegisterEvent:nil subKey:nil object:object];
}

- (void)unRegisterEvent:(nullable NSString *)key subKey:(nullable NSString *)subKey object:(nullable id<TUINotificationProtocol>)object {
    @synchronized(self.eventList) {
        NSMutableArray *removeEventList = [NSMutableArray array];
        for (NSDictionary *event in self.eventList) {
            NSString *pkey = [event objectForKey:@"key"];
            NSString *pSubKey = [event objectForKey:@"subKey"];
            id pObject = [event objectForKey:@"object"];

            if (pObject == nil || [(TUIWeakProxy *)pObject target] == nil) {
                [removeEventList addObject:event];
            }
            if (key == nil && subKey == nil && pObject == object) {
                [removeEventList addObject:event];
            } else if ([pkey isEqualToString:key] && subKey == nil && object == nil) {
                [removeEventList addObject:event];
            } else if ([pkey isEqualToString:key] && [subKey isEqualToString:pSubKey] && object == nil) {
                [removeEventList addObject:event];
            } else if ([pkey isEqualToString:key] && [subKey isEqualToString:pSubKey] && pObject == object) {
                [removeEventList addObject:event];
            }
        }
        [self.eventList removeObjectsInArray:removeEventList];
    }
}

- (void)notifyEvent:(NSString *)key subKey:(NSString *)subKey object:(nullable id)object param:(nullable NSDictionary *)param {
    NSAssert(key.length > 0, @"invalid key");

    if (subKey.length == 0) {
        subKey = @"";
    }

    @synchronized(self.eventList) {
        for (NSDictionary *event in self.eventList) {
            NSString *pkey = [event objectForKey:@"key"];
            NSString *pSubKey = [event objectForKey:@"subKey"];

            if ([pkey isEqualToString:key] && [pSubKey isEqualToString:subKey]) {
                id<TUINotificationProtocol> pObject = [event objectForKey:@"object"];
                if (pObject) {
                    [pObject onNotifyEvent:key subKey:subKey object:object param:param];
                }
            }
        }
    }
}

- (NSMutableArray<NSDictionary *> *)eventList {
    if (_eventList == nil) {
        _eventList = [NSMutableArray array];
    }
    return _eventList;
}

@end
