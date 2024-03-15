//
//  TUIConfig.m
//  TUIKit
//
//  Created by kennethmiao on 2018/11/5.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "TUIConfig.h"
#import "TUICommonModel.h"
#import "TUIDefine.h"
#import "TUIThemeManager.h"

@interface TUIConfig ()

@property(nonatomic, strong) UIImage *defaultGroupAvatarImage_Public;
@property(nonatomic, strong) UIImage *defaultGroupAvatarImage_Meeting;
@property(nonatomic, strong) UIImage *defaultGroupAvatarImage_AVChatRoom;
@property(nonatomic, strong) UIImage *defaultGroupAvatarImage_Community;

@end

@implementation TUIConfig

- (id)init {
    self = [super init];
    if (self) {
        _avatarCornerRadius = 5.f;
        _defaultAvatarImage = TUICoreBundleThemeImage(@"default_c2c_head_img", @"default_c2c_head");
        _defaultGroupAvatarImage = TUICoreBundleThemeImage(@"default_group_head_img", @"default_group_head");
        _defaultGroupAvatarImage_Public = TUICoreBundleThemeImage(@"default_group_head_public_img", @"default_group_head_public");
        _defaultGroupAvatarImage_Meeting = TUICoreBundleThemeImage(@"default_group_head_meeting_img", @"default_group_head_meeting");
        _defaultGroupAvatarImage_AVChatRoom = TUICoreBundleThemeImage(@"default_group_head_avchatroom_img", @"default_group_head_avchatRoom");
        _defaultGroupAvatarImage_Community = TUICoreBundleThemeImage(@"", @"default_group_head_community");

        _isExcludedFromUnreadCount = NO;
        _isExcludedFromLastMessage = NO;
        _enableToast = YES;
        _displayOnlineStatusIcon = NO;
        _enableGroupGridAvatar = YES;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onChangeTheme) name:TUIDidApplyingThemeChangedNotfication object:nil];
    }
    return self;
}

+ (id)defaultConfig {
    static dispatch_once_t onceToken;
    static TUIConfig *config;
    dispatch_once(&onceToken, ^{
      config = [[TUIConfig alloc] init];
    });
    return config;
}

- (void)onChangeTheme {
    self.defaultAvatarImage = TUICoreBundleThemeImage(@"default_c2c_head_img", @"default_c2c_head");
    self.defaultGroupAvatarImage = TUICoreBundleThemeImage(@"default_group_head_img", @"default_group_head");
    self.defaultGroupAvatarImage_Public = TUICoreBundleThemeImage(@"default_group_head_public_img", @"default_group_head_public");
    self.defaultGroupAvatarImage_Meeting = TUICoreBundleThemeImage(@"default_group_head_meeting_img", @"default_group_head_meeting");
    self.defaultGroupAvatarImage_AVChatRoom = TUICoreBundleThemeImage(@"default_group_head_avchatroom_img", @"default_group_head_avchatroom");
    self.defaultGroupAvatarImage_Community = TUICoreBundleThemeImage(@"default_group_head_community_img", @"default_group_head_community");
}



@end
