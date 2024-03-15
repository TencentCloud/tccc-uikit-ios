/**
 * Module:   TCCC 音视频设备管理模块
 * Function: 用于管理摄像头、麦克风和扬声器等音视频相关的硬件设备
 */
/// @defgroup ITCCCDeviceManager_cplusplus  TCCC 音视频设备管理模块
///  TCCC 音视频设备管理模块
/// @{

#ifndef ITCCCDeviceManager_h
#  define ITCCCDeviceManager_h

#  include <stdint.h>
#  ifdef __APPLE__
#    include <TargetConditionals.h>
#  endif

namespace tccc {
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
enum TCCCAudioRoute {

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
enum TCCCMediaDeviceType {

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
enum TCCCMediaDeviceState {

  /// 设备已被插入
  TCCCMediaDeviceStateAdd = 0,

  /// 设备已被移除
  TCCCMediaDeviceStateRemove = 1,

  /// 设备已启用
  TCCCMediaDeviceStateActive = 2,

};

/**
 * 摄像头采集偏好
 *
 * 该枚举类型用于摄像头采集参数设置。
 */
#  ifdef _WIN32

#  endif

/**
 * 音视频设备的相关信息（仅适用于桌面平台）
 *
 * 该结构体用于描述一个音视频设备的关键信息，比如设备ID、设备名称等等，以便用户能够在用户界面上选择自己期望使用的音视频设备。
 */
class ITCCCDeviceInfo {
 protected:
  virtual ~ITCCCDeviceInfo() {}

 public:
  virtual void release() = 0;

  /// 设备 id （UTF-8）
  virtual const char* getDevicePID() = 0;

  /// 设备名称 （UTF-8）
  virtual const char* getDeviceName() = 0;
};

/**
 * 设备信息列表（仅适用于桌面平台）
 *
 * 此结构体的作用相当于 std::vector<ITCCCDeviceInfo>，用于解决不同版本的 STL 容器的二进制兼容问题。
 */
class ITCCCDeviceCollection {
 protected:
  virtual ~ITCCCDeviceCollection() {}

 public:
  /// 设备数量
  virtual uint32_t getCount() = 0;

  /// 设备名字 (UTF-8)，index 为设备索引，值为 [0,getCount)。返回值为设备名称 （UTF-8）
  virtual const char* getDeviceName(uint32_t index) = 0;

  /// 设备唯一标识 (UTF-8) index 为设备索引，值为 [0,getCount)
  virtual const char* getDevicePID(uint32_t index) = 0;

  /// 设备信息（json格式）
  ///@note
  ///  - 示例：{"SupportedResolution":[{"width":640,"height":480},{"width":320,"height":240}]}
  ///  param index 设备索引，值为 [0,getCount)，return 返回 json 格式的设备信息
  virtual const char* getDeviceProperties(uint32_t index) = 0;

  /// 释放设备列表，请不要使用 delete 释放资源 !!!
  virtual void release() = 0;
};

#  if (__APPLE__ && TARGET_OS_MAC && !TARGET_OS_IPHONE) || _WIN32
class ITXDeviceObserver {
 public:
  virtual ~ITXDeviceObserver() {}

  /**
   * 本地设备的通断状态发生变化（仅适用于桌面系统）
   *
   * 当本地设备（包括摄像头、麦克风以及扬声器）被插入或者拔出时，SDK 便会抛出此事件回调。
   * @param deviceId 设备 ID
   * @param type 设备类型
   * @param state 通断状态，0：设备已添加；1：设备已被移除；2：设备已启用。
   */
  virtual void onDeviceChanged(const char* deviceId, TCCCMediaDeviceType type, TCCCMediaDeviceState state) {}
};
#  endif

class ITCCCDeviceManager {
 public:
  virtual ~ITCCCDeviceManager() {}

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
  virtual void setAudioCaptureVolume(int volume) = 0;

  /**
   * 4.4 获取本地音频的采集音量
   */
  virtual int getAudioCaptureVolume() = 0;

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
  virtual void setAudioPlayoutVolume(int volume) = 0;

  /**
   * 4.6 获取远端音频的播放音量
   */
  virtual int getAudioPlayoutVolume() = 0;

/// @}

/////////////////////////////////////////////////////////////////////////////////
//
//                    移动端设备操作接口（iOS Android）
//
/////////////////////////////////////////////////////////////////////////////////
/// @name 移动端设备操作接口
/// @{
#  if __ANDROID__ || (__APPLE__ && TARGET_OS_IOS)
  /**
   * 1.1 判断当前是否为前置摄像头（仅适用于移动端）
   */
  // virtual bool isFrontCamera() = 0;
  //
  //  /**
  //  * 1.2 切换前置或后置摄像头（仅适用于移动端）
  //  */
  // virtual int switchCamera(bool frontCamera) = 0;

  /**
   * 1.9 设置音频路由（仅适用于移动端）
   *
   * 手机有两个音频播放设备：一个是位于手机顶部的听筒，一个是位于手机底部的立体声扬声器。
   * 设置音频路由为听筒时，声音比较小，只有将耳朵凑近才能听清楚，隐私性较好，适合用于接听电话。
   * 设置音频路由为扬声器时，声音比较大，不用将手机贴脸也能听清，因此可以实现“免提”的功能。
   */
  virtual int setAudioRoute(TCCCAudioRoute route) = 0;
#  endif
/// @}
/////////////////////////////////////////////////////////////////////////////////
//
//                    桌面端设备操作接口（Windows Mac）
//
/////////////////////////////////////////////////////////////////////////////////
/// @name 桌面端设备操作接口
/// @{
#  if (__APPLE__ && TARGET_OS_MAC && !TARGET_OS_IPHONE) || _WIN32

  /**
   * 2.1 获取设备列表（仅适用于桌面端）
   *
   * @param type  设备类型，指定需要获取哪种设备的列表。详见 TCCCMediaDeviceType 定义。
   * @note
   *   - 使用完毕后请调用 release 方法释放资源，这样可以让 SDK 维护 ITCCCDeviceCollection 对象的生命周期。
   *   - 不要使用 delete 释放返回的 Collection 对象，delete ITCCCDeviceCollection* 指针会导致异常崩溃。
   *   - type 只支持 TCCCMediaDeviceTypeMic、TCCCMediaDeviceTypeSpeaker、TCCCMediaDeviceTypeCamera。
   *   - 此接口只支持 Mac 和 Windows 平台
   */
  virtual ITCCCDeviceCollection* getDevicesList(TCCCMediaDeviceType type) = 0;

  /**
   * 2.2 设置当前要使用的设备（仅适用于桌面端）
   *
   * @param type 设备类型，详见 TCCCMediaDeviceType 定义。
   * @param deviceId 设备ID，您可以通过接口 {@link getDevicesList} 获得设备 ID。
   * @return 0：操作成功；负数：操作失败。
   */
  virtual int setCurrentDevice(TCCCMediaDeviceType type, const char* deviceId) = 0;

  /**
   * 2.3 获取当前正在使用的设备（仅适用于桌面端）
   */
  virtual ITCCCDeviceInfo* getCurrentDevice(TCCCMediaDeviceType type) = 0;

  /**
   * 2.4 设置当前设备的音量（仅适用于桌面端）
   *
   * 这里的音量指的是麦克风的采集音量或者扬声器的播放音量，摄像头是不支持设置音量的。
   * @param volume 音量大小，取值范围为0 - 100，默认值：100。
   * @note 如果将 volume 设置成 100 之后感觉音量还是太小，可以将 volume 最大设置成 150，但超过 100 的 volume
   * 会有爆音的风险，请谨慎操作。
   */
  virtual int setCurrentDeviceVolume(TCCCMediaDeviceType type, uint32_t volume) = 0;

  /**
   * 2.5 获取当前设备的音量（仅适用于桌面端）
   *
   * 这里的音量指的是麦克风的采集音量或者扬声器的播放音量，摄像头是不支持获取音量的。
   */
  virtual uint32_t getCurrentDeviceVolume(TCCCMediaDeviceType type) = 0;

  /**
   * 2.6 设置当前设备的静音状态（仅适用于桌面端）
   *
   * 这里的音量指的是麦克风和扬声器，摄像头是不支持静音操作的。
   */
  virtual int setCurrentDeviceMute(TCCCMediaDeviceType type, bool mute) = 0;

  /**
   * 2.7 获取当前设备的静音状态（仅适用于桌面端）
   *
   * 这里的音量指的是麦克风和扬声器，摄像头是不支持静音操作的。
   */
  virtual bool getCurrentDeviceMute(TCCCMediaDeviceType type) = 0;

  /**
   * 2.8 设置 SDK 使用的音频设备根据跟随系统默认设备（仅适用于桌面端）
   *
   * 仅支持设置麦克风和扬声器类型，摄像头暂不支持跟随系统默认设备
   * @param type 设备类型，详见 TCCCMediaDeviceType 定义。
   * @param enable 是否跟随系统默认的音频设备。
   *         - true：跟随。当系统默认音频设备发生改变时，SDK 立即切换音频设备。
   *         - false：不跟随。只有当 SDK 使用的音频设备被移除后或插入新的音频设备为系统默认设备时，SDK
   * 才切换至系统默认的音频设备。
   */
  virtual int enableFollowingDefaultAudioDevice(TCCCMediaDeviceType type, bool enable) = 0;

#  endif
  /// @}
};

}  // namespace tccc

#endif /* ITCCCDeviceManager_h */
       /// @}