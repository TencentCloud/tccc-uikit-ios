#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/////////////////////////////////////////////////////////////////////////////////
//
//                    音视频设备相关的类型定义
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 音频路由（即声音的播放模式）
 *
 * 音频路由，即声音是从手机的扬声器还是从听筒中播放出来，因此该接口仅适用于手机等移动端设备。
 * 手机有两个扬声器：一个是位于手机顶部的听筒，一个是位于手机底部的立体声扬声器。
 * - 设置音频路由为听筒时，声音比较小，只有将耳朵凑近才能听清楚，隐私性较好，适合用于接听电话。
 * - 设置音频路由为扬声器时，声音比较大，不用将手机贴脸也能听清，因此可以实现“免提”的功能。
 */
typedef NS_ENUM(NSInteger, CCCAudioRoute) {

  /// Speakerphone：使用扬声器播放（即“免提”），扬声器位于手机底部，声音偏大，适合外放音乐。
  TCCCAudioRouteSpeakerphone = 0,

  /// Earpiece：使用听筒播放，听筒位于手机顶部，声音偏小，适合需要保护隐私的通话场景。
  TCCCAudioRouteEarpiece = 1,

};

/**
 * 设备类型（仅适用于桌面平台）
 *
 * 该枚举值用于定义三种类型的音视频设备，即摄像头、麦克风和扬声器，以便让一套设备管理接口可以操控三种不同类型的设备。
 */
typedef NS_ENUM(NSInteger, CCCMediaDeviceType) {

  /// 未定义的设备类型
  TCCCMediaDeviceTypeUnknown = -1,

  /// 麦克风类型设备
  TCCCMediaDeviceTypeMic = 0,

  /// 扬声器类型设备
  TCCCMediaDeviceTypeSpeaker = 1,

  /// 摄像头类型设备
  TCCCMediaDeviceTypeCamera = 2,

};

/**
 * 设备操作
 *
 * 该枚举值用于本地设备的状态变化通知{@link onDeviceChanged}。
 */
typedef NS_ENUM(NSInteger, CCCMediaDeviceState) {
  /// 设备已被插入
  TCCCMediaDeviceStateAdd = 0,

  /// 设备已被移除
  TCCCMediaDeviceStateRemove = 1,

  /// 设备已启用
  TCCCMediaDeviceStateActive = 2,
};

/**
 * 音视频设备的相关信息（仅适用于桌面平台）
 *
 * 该结构体用于描述一个音视频设备的关键信息，比如设备 ID、设备名称等等，以便用户能够在用户界面上选择自己期望使用的音视频设备。
 */
#if TARGET_OS_MAC && !TARGET_OS_IPHONE

#endif

@interface TCCCDeviceManager : NSObject

/////////////////////////////////////////////////////////////////////////////////
//
//                    音频、音量相关接口
//
/////////////////////////////////////////////////////////////////////////////////
/// @name 音频、音量相关接口
/// @{

/**
 * 4.3 设定本地音频的采集音量
 *
 * @param volume 音量大小，取值范围为0 - 100；默认值：100
 * @note 如果将 volume 设置成 100 之后感觉音量还是太小，可以将 volume 最大设置成 150，但超过 100 的 volume
 * 会有爆音的风险，请谨慎操作。
 */
- (void)setAudioCaptureVolume:(NSInteger)volume;

/**
 * 4.4 获取本地音频的采集音量
 */
- (NSInteger)getAudioCaptureVolume;

/**
 * 4.5 设定远端音频的播放音量
 *
 * 该接口会控制 SDK
 * 最终交给系统播放的声音音量，调节效果会影响到本地音频录制文件的音量大小，但不会影响到耳返的音量大小。
 *
 * @param volume 音量大小，取值范围为0 - 100，默认值：100。
 * @note 如果将 volume 设置成 100 之后感觉音量还是太小，可以将 volume 最大设置成 150，但超过 100 的 volume
 * 会有爆音的风险，请谨慎操作。
 */
- (void)setAudioPlayoutVolume:(NSInteger)volume;

/**
 * 4.6 获取远端音频的播放音量
 */
- (NSInteger)getAudioPlayoutVolume;
/// @}

/////////////////////////////////////////////////////////////////////////////////
//
//                    移动端设备操作接口（iOS Android）
//
/////////////////////////////////////////////////////////////////////////////////

#if TARGET_OS_IPHONE
/**
 * 1.9 设置音频路由（仅适用于移动端）
 *
 * 手机有两个音频播放设备：一个是位于手机顶部的听筒，一个是位于手机底部的立体声扬声器。
 * 设置音频路由为听筒时，声音比较小，只有将耳朵凑近才能听清楚，隐私性较好，适合用于接听电话。
 * 设置音频路由为扬声器时，声音比较大，不用将手机贴脸也能听清，因此可以实现“免提”的功能。
 */
- (void)setAudioRoute:(CCCAudioRoute)route;

#endif

/////////////////////////////////////////////////////////////////////////////////
//
//                    桌面端设备操作接口（Windows Mac）
//
/////////////////////////////////////////////////////////////////////////////////

#if !TARGET_OS_IPHONE && TARGET_OS_MAC

#endif

@end

NS_ASSUME_NONNULL_END
