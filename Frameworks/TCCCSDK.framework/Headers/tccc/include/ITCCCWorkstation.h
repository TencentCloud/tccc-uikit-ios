/**
 * Module:   TCCC 主功能接口
 * Function: 登录、呼叫、会话管理相关接口
 * Version: 0.1.1933
 */
#ifndef ITCCCWorkstation_h
#define ITCCCWorkstation_h

#include "IAgentInfoManager.h"
#include "ITCCCCallback.h"
#include "ITCCCDeviceManager.h"
#include "TCCCCode.h"
#include "TCCCTypeDef.h"

/// @defgroup TCCCWorkstation_cplusplus TCCC 主功能接口
/// 腾讯云 TCCC 主功能接口
/// @{
namespace tccc {
class ITCCCWorkstation;
}

/// Export the following C-style interface to facilitate “LoadLibrary()”
/// You can use the following methods to create and destroy TCCCWorkstation instance：
/// <pre>
///    ITCCCWorkstation *tcccCloud = getTCCCShareInstance();
///    if(tcccCloud) {
///        std::string version(tcccCloud->getSDKVersion());
///    }
///    //
///    //
///    destroyTCCCShareInstance();
///    tcccCloud = nullptr;
/// </pre>
///
extern "C" {
/// @name Exported C function
/// @{
#ifdef __ANDROID__
TCCC_API tccc::ITCCCWorkstation* getTCCCShareInstance(void* context);
#else
TCCC_API tccc::ITCCCWorkstation* getTCCCShareInstance();
#endif
TCCC_API void destroyTCCCShareInstance();
/// @}
}

namespace tccc {

class ITCCCWorkstation {
 protected:
  virtual ~ITCCCWorkstation(){};

 public:
  /////////////////////////////////////////////////////////////////////////////////
  //
  //                    创建实例和事件回调
  //
  /////////////////////////////////////////////////////////////////////////////////
  /// @name 创建实例和事件回调
  /// @{

  /**
   * 1.1 创建 TCCCWorkstation 实例（单例模式）
   *
   * @param context 仅适用于 Android 平台，SDK 内部会将其转化为 Android 平台的 ApplicationContext 用于调用 Androud
   * System API。 如果传入的 context 参数为空，SDK 内部会自动获取当前进程的 ApplicationContext。
   * @note
   * 1. 如果您使用 delete ITCCCWorkstation* 会导致编译错误，请使用 destroyTCCCShareInstance 释放对象指针。
   * 2. 在 Windows、Mac 和 iOS 平台上，请调用 getTCCCShareInstance() 接口。
   * 3. 在 Android 平台上，请调用 getTCCCShareInstance(void *context) 接口。
   */
#ifdef __ANDROID__
  static tccc::ITCCCWorkstation* getShareInstance(void* context);
#else
  static tccc::ITCCCWorkstation* getShareInstance();
#endif

  /**
   * 1.2 销毁 TCCCWorkstation 实例（单例模式）
   */
  static void destroyShareInstance();

  /**
   * 1.3 设置 TCCC 事件回调
   *
   * 您可以通过 {@link ITCCCCallback} 获得来自 SDK 的各类事件通知（比如：错误码，警告码，音视频状态参数等）。
   *
   * @param callback 回调
   */
  virtual void addCallback(ITCCCCallback* callback) = 0;

  /**
   * 1.4 移除 TCCC 事件回调
   *
   * @param callback 回调
   */
  virtual void removeCallback(ITCCCCallback* callback) = 0;

  /// @}
  /////////////////////////////////////////////////////////////////////////////////
  //
  //                    登录相关接口函数
  //
  /////////////////////////////////////////////////////////////////////////////////
  /// @name 登录相关接口函数
  /// @{

  /**
   * 2.1 登录 TCCC 联络中心
   *
   * @param loginParam 登录参数
   *
   * @param callback 登录成功与否回调
   */
  virtual void login(const TCCCLoginParams& loginParam, ITXValueCallback<TCCCLoginInfo>* callback) = 0;

  /**
   * 2.2 退出 TCCC 联络中心
   *
   * @param callback 退出成功与否回调
   */
  virtual void logout(ITXCallback* callback) = 0;

  /// @}
  /////////////////////////////////////////////////////////////////////////////////
  //
  //                    呼叫相关接口函数
  //
  /////////////////////////////////////////////////////////////////////////////////
  /// @name 呼叫相关接口函数
  /// @{

  /**
   * 3.1 发起呼出
   *
   * @param param 呼出参数
   *
   * @param startCallback 呼出回调,仅仅表示发起呼叫是否成功。当onNewSession回调了表示新会话，
   * 对端接听用onAccepted，对端挂断用onEnded
   */
  virtual void call(const TCCCStartCallParams& param, ITXCallback* startCallback) = 0;

  /**
   * 3.2 结束会话
   *
   */
  virtual void terminate() = 0;

  /**
   * 3.3 接听
   *
   * @param answerCallback 接听成功与否回调
   */
  virtual void answer(ITXCallback* answerCallback) = 0;

  // /**
  //  * 3.5 删除会话
  //  *
  //  * @param sessionId 会话ID
  //  *
  //  * @param callback 删除会话成功与否回调
  //  */
  // // virtual void deleteCall(const char *sessionId, ITXCallback* callback) = 0;

  // /**
  //  * 3.6 呼叫保持
  //  *
  //  * @param sessionId 会话ID
  //  *
  //  * @param callback 呼叫保持成功与否回调
  //  */
  // // virtual void hold(const char *sessionId, ITXCallback* callback) = 0;

  // /**
  //  * 3.7 取消通话保持
  //  *
  //  * @param sessionId 会话ID
  //  *
  //  * @param callback 取消通话保持成功与否回调
  //  */
  // // virtual void unHold(const char *sessionId, ITXCallback* callback) = 0;

  /**
   * 3.8 发送 DTMF（双音多频信号）
   *
   * @param digits DTMF参数是一个字符串，可以包含字符 0-9、*、#。
   *
   * @param callback 发送 DTMF成功与否回调，调用一次就会播放一次按键声音
   * @note
   *  该方法仅仅在通话建立后才生效。需要注意的是前后按键需要保证一定的间隔，否则会出现可能出现对端无法感知的问题。
   */
  virtual void sendDTMF(const char digit, ITXCallback* callback) = 0;

  // /**
  //  * 3.9 转接会话
  //  *
  //  * @param params 转接参数
  //  *
  //  * @param callback 转接会话成功与否回调
  //  */
  // virtual void transfer(TCCCtransferParams params, ITXCallback* callback) = 0;

  /// @}
  /////////////////////////////////////////////////////////////////////////////////
  //
  //                    音频相关接口函数
  //
  /////////////////////////////////////////////////////////////////////////////////
  /// @name 音频相关接口函数
  /// @{

  /**
   * 4.1 静音
   */
  virtual void mute() = 0;

  /**
   * 4.2 取消静音
   */
  virtual void unmute() = 0;

  /**
   * 4.7 启用音量大小提示。
   *
   * 开启此功能后，SDK 会在 {@link ITCCCCallback} 中的 {@link onVoiceVolume} 回调中反馈远端音频的音量大小。
   * @note 如需打开此功能，请在 接听或者发起呼叫 之前调用才可以生效。
   * @param interval 设置 onVoiceVolume 回调的触发间隔，单位为ms，最小间隔为100ms，如果小于等于 0
   * @param enable_vad  true：打开本地人声检测 ；false：关闭本地人声检测。默认是FALSE
   则会关闭回调，建议设置为300ms；
   */
  virtual void enableAudioVolumeEvaluation(uint32_t interval, bool enable_vad) = 0;

  /**
   * 4.8 开始播放音乐
   *
   * @param path 音乐路径。
   * @param loopCount 音乐循环播放的次数。取值范围为0 - 任意正整数，默认值：1。1
   * 表示播放音乐一次,以此类推。0表示无限循环，手动停止
   */
  virtual void startPlayMusic(const char* path, int loopCount) = 0;

  /**
   * 4.9 停止播放音乐
   */
  virtual void stopPlayMusic() = 0;

  /// @}
  /////////////////////////////////////////////////////////////////////////////////
  //
  //                    设备&坐席管理相关接口
  //
  /////////////////////////////////////////////////////////////////////////////////
  /// @name  设备管理相关接口
  /// @{

  /**
   * 10.1 获取设备管理类（ITCCCDeviceManager）
   */
  virtual ITCCCDeviceManager* getDeviceManager() = 0;

  // /**
  //  * 10.2 获取坐席信息管理类（IAgentInfoManager）
  //  */
  // // virtual IAgentInfoManager* getAgentInfoManager() = 0;

  /// @}

  /////////////////////////////////////////////////////////////////////////////////
  //
  //                    调试相关接口
  //
  /////////////////////////////////////////////////////////////////////////////////
  /// @name  调试相关接口
  /// @{
  /**
   * 12.1 获取 SDK 版本信息
   */
  virtual const char* getSDKVersion() = 0;

  /**
   * 12.2 调用实验性接口
   *
   * @param commandType 类型
   * @param jsonStr 参数
   */
  virtual void callExperimentalAPI(const char* commandType, const char* jsonStr) = 0;

  /**
   * 12.3 设置 Log 输出级别，该方法必须在login前调用才生效
   *
   * @param level 参见 {@link TCCCLogLevel}，默认值：{@link TCCCLogLevelInfo}
   */
  virtual void setLogLevel(TCCCLogLevel level) = 0;

  /**
   * 12.4 启用/禁用控制台日志打印
   *
   * @param enabled 指定是否启用，默认:禁止状态
   */
  virtual void setConsoleEnabled(bool enabled) = 0;

  /**
   * 12.5 设置日志文件夹,登录前调用才有效
   *
   * @param logPath 日志文件夹路径
   */
  virtual void setLogDirectory(const char* logPath) = 0;

  /**
   * 12.6 启用/禁用timer功能。
   *
   * timer功能启用后。如果在预定的时间内没有收到响应，就会触发超时事件，这可能会导致终止会话操作。
   *
   * 注意该功能仅支持在 login 前调用才有效
   *
   * @param isEnable 是否开启timer，默认：开启状态。
   */
  virtual void setEnableTimer(bool isEnable) = 0;

  /*
   * 当网络异常不能恢复的时候调用，通常用于手机切后台后不能恢复。
   * 不要轻易调用,建议在手机后台切回前台的时候，checkLogin-->onError-->resetSip-->checkLogin
   */
  virtual void resetSip(bool isNeedCallReLogin) = 0;

  /*
   * 检查登录状态。
   *
   * @param callback 是否已登录回调
   */
  virtual void checkLogin(ITXCallback* callback) = 0;

  // 只能在内部使用。
  virtual void genTestTokenByUser(const char* secretId, const char* secretKey, const char* userId, uint32_t sdkAppId,
                                  ITXCallback* callback) = 0;
  /// @}
};
}  // namespace tccc
/// @}

#endif /* ITCCCWorkstation_h */
