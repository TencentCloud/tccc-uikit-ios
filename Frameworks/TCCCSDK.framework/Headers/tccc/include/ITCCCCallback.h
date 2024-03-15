//
//  腾讯云联络中心的事件回调接口
//  tccc-workstation-sdk
//
//  Created by gavinwjwang on 2022/7/19.
//

#ifndef TCCCCallback_h
#define TCCCCallback_h
#include "TCCCCode.h"
#include "TCCCTypeDef.h"
/// @defgroup TCCCCallback_cplusplus TCCC 主要回调事件
/// TCCC 主要回调事件
/// @{

namespace tccc {

class ITCCCCallback {
 public:
  virtual ~ITCCCCallback(){};

  /////////////////////////////////////////////////////////////////////////////////
  //
  //                    错误和警告事件
  //
  /////////////////////////////////////////////////////////////////////////////////
  /// @name 错误和警告事件
  /// @{
  /**
   * 1.1 错误事件回调
   *
   * 错误事件，表示 SDK 抛出的不可恢复的错误，比如设备开启失败、网络异常等。
   *
   * @param errCode 错误码
   * @param errMsg  错误信息
   * @param extInfo 扩展信息字段，个别错误码可能会带额外的信息帮助定位问题
   */
  virtual void onError(TCCCError errCode, const char* errMsg, void* extraInfo) = 0;
  /**
   * 1.2 警告事件回调
   *
   * 警告事件，表示 SDK 抛出的提示性问题，比如视频出现卡顿或 CPU 使用率太高等。
   *
   * @param warningCode 警告码
   * @param warningMsg 警告信息
   * @param extInfo 扩展信息字段，个别警告码可能会带额外的信息帮助定位问题
   */
  virtual void onWarning(TCCCCWarning warningCode, const char* warningMsg, void* extraInfo) = 0;

  /// @}
  /////////////////////////////////////////////////////////////////////////////////
  //
  //                    呼叫呼入相关事件回调
  //
  /////////////////////////////////////////////////////////////////////////////////
  /// @name 呼叫呼入相关事件回调
  /// @{

  /**
   * 2.1 新会话事件。包括呼入和呼出
   *
   * @param info 会话信息
   */
  virtual void onNewSession(TCCCSessionInfo info) = 0;

  /**
   * 结束原因
   */
  enum EndedReason {
    /// 系统错误
    Error,
    /// 超时
    Timeout,
    /// ended due to being replaced
    Replaced,
    /// 主叫挂断
    LocalBye,
    /// 对端挂断
    RemoteBye,
    /// 主叫取消拨打
    LocalCancel,
    /// 对端取消拨打
    RemoteCancel,
    /// 对端拒绝
    Rejected,  // Only as UAS, UAC has distinct onFailure callback
    /// 被转接而结束
    Referred  //! slg! - This is really Redirected - not sure why it is called Referred.  Only gets used when we send a
              //! redirect (ie: 302).
  };

  /**
   * 2.2 会话结束事件，用户挂断
   *
   * @param reason 会话结束类型
   *
   * @param reasonMessage 会话结束原因
   *
   * @param sessionId 会话ID
   */
  virtual void onEnded(EndedReason reason, const char* reasonMessage, const char* sessionId) = 0;

  /**
   * 2.3 对方接听事件
   *
   * @param sessionId 会话信息
   */
  virtual void onAccepted(const char* sessionId) = 0;

  /**
   * 2.4 音量大小的反馈回调
   *
   * @param volumeInfo 为一个数组，对于数组中的每一个元素，当 userId 为空时表示本地麦克风采集的音量大小，当 userId
   * 不为空时代表远端用户的音量大小。
   */
  virtual void onAudioVolume(TCCCVolumeInfo* volumeInfo){};

  /// @}
  /////////////////////////////////////////////////////////////////////////////////
  //
  //                    网络和技术指标统计回调
  //
  /////////////////////////////////////////////////////////////////////////////////
  /// @name 网络和技术指标统计回调
  /// @{

  /**
   * 4.1 网络质量的实时统计回调
   *
   * 该统计回调每间隔2秒抛出一次，用于通知 SDK 感知到的当前网络的上行和下行质量。
   * SDK 会使用一组内嵌的自研算法对当前网络的延迟高低、带宽大小以及稳定情况进行评估，并计算出一个的评估结果：
   * 如果评估结果为 1（Excellent） 代表当前的网络情况非常好，如果评估结果为 6（Down）代表当前网络无法支撑 RTC
   * 的正常通话。
   *
   * @note 回调参数 localQuality 和 remoteQuality 中的 userId
   * 如果为空置，代表本组数据统计的是自己本地的网络质量，否则是代表远端用户的网络质量。
   *
   * @param localQuality 上行网络质量
   * @param remoteQuality 下行网络质量
   */
  virtual void onNetworkQuality(TCCCQualityInfo localQuality, TCCCQualityInfo* remoteQuality,
                                uint32_t remoteQualityCount){};

  /**
   * 4.2 音视频技术指标的实时统计回调
   *
   * 该统计回调每间隔2秒抛出一次，用于通知 SDK 内部音频、视频以及网络相关的专业技术指标，这些信息在 {@link
   * TCCCStatistics} 均有罗列：
   * - 视频统计信息：视频的分辨率（resolution）、帧率（FPS）和比特率（bitrate）等信息。
   * - 音频统计信息：音频的采样率（samplerate）、声道（channel）和比特率（bitrate）等信息。
   * - 网络统计信息：SDK 和云端一次往返（SDK > Cloud >
   * SDK）的网络耗时（rtt）、丢包率（loss）、上行流量（sentBytes）和下行流量（receivedBytes）等信息。
   * @param statistics 统计数据，包括自己本地的统计信息和远端用户的统计信息，详情请参考 {@link TCCCStatistics}。
   * @note 如果您只需要获知当前网络质量的好坏，并不需要花太多时间研究本统计回调，更推荐您使用 {@link onNetworkQuality}
   * 来解决问题。
   */
  virtual void onStatistics(const TCCCStatistics& statistics) {}

  /**
   * 后台服务类型
   */
  enum TCCCServerType {
    /// TCCC的服务
    TCCCServer = 0,
    /// 实时通话的RTC服务
    TRTCServer = 1,
  };

  /**
   * 5.1 SDK 与云端的连接已经断开
   *
   * SDK
   * 会在跟云端的连接断开时抛出此事件回调，导致断开的原因大多是网络不可用或者网络切换所致，比如用户在通话中走进电梯时就可能会遇到此事件。
   * 在抛出此事件之后，SDK 会努力跟云端重新建立连接，重连过程中会抛出 {@link onTryToReconnect}，连接恢复后会抛出 {@link
   * onConnectionRecovery} 。 所以，SDK 会在如下三个连接相关的事件中按如下规律切换： <pre> [onConnectionLost] =====>
   * [onTryToReconnect] =====> [onConnectionRecovery]
   *               /|\                                                     |
   *                |------------------------------------------------------|
   * </pre>
   * @param serverType 0表示为TRTC的，1表示为TCCC server
   */
  virtual void onConnectionLost(TCCCServerType serverType){};

  /**
   * 5.2 SDK 正在尝试重新连接到云端
   *
   * SDK 会在跟云端的连接断开时抛出 {@link onConnectionLost}，之后会努力跟云端重新建立连接并抛出本事件，连接恢复后会抛出
   * {@link onConnectionRecovery}。
   * @param serverType 0表示为TRTC的，1表示为TCCC server
   */
  virtual void onTryToReconnect(TCCCServerType serverType){};

  /**
   * 5.3 SDK 与云端的连接已经恢复
   *
   * SDK 会在跟云端的连接断开时抛出 {@link onConnectionLost}，之后会努力跟云端重新建立连接并抛出{@link
   * onTryToReconnect}，连接恢复后会抛出本事件回调。
   * @param serverType 0表示为TRTC的，1表示为TCCC server
   */
  virtual void onConnectionRecovery(TCCCServerType serverType){};

  // /**
  //  * 4.2 网速测试的结果回调
  //  *
  //  * 该统计回调由 {@link startSpeedTest:} 触发。
  //  *
  //  * @param result 网速测试数据数据，包括丢包、往返延迟、上下行的带宽速率，详情请参考 {@link TCCCSpeedTestResult}。
  //  */
  // // virtual void onSpeedTestResult(const TCCCSpeedTestResult& result) = 0;

  /// @}

  /**
   * 仅供企点使用，外部客户请勿使用
   */
  virtual void onRemoteUserJoin(const char* rtcUserId){};
  /**
   * 仅供企点使用，外部客户请勿使用
   */
  virtual void onRemoteUserLeave(const char* rtcUserId, int reason){};
};

/**
 * Tccc普通回调类
 */
class ITXCallback {
 public:
  virtual ~ITXCallback(){};
  /**
   * 成功时回调，不带参数
   */
  virtual void OnSuccess() = 0;
  /**
   * 出错时回调
   *
   * @param error_code 错误码，详细描述请参见错误码表
   * @param error_message 错误描述
   */
  virtual void OnError(TCCCError error_code, const char* error_message) = 0;
};

/**
 * 模版回调类
 */
template <class T>
class ITXValueCallback {
 public:
  virtual ~ITXValueCallback(){};
  /**
   * 成功时回调，不带参数
   */
  virtual void OnSuccess(const T& value) = 0;
  /**
   * 出错时回调
   *
   * @param error_code 错误码，详细描述请参见错误码表
   * @param error_message 错误描述
   */
  virtual void OnError(TCCCError error_code, const char* error_message) = 0;
};

}  // namespace tccc

/// @}

#endif /* TCCCCallback_h */
