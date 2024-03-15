
/**
 * Module:   TCCC 关键类型定义
 * Function: 登录参数、呼叫、会话参数和常量值的定义
 */
/// @defgroup TCCCTypeDef_cplusplus TCCC 关键类型定义
/// 腾讯云联络中心的关键类型定义
/// @{
#ifndef TCCCTypeDef_h
#  define TCCCTypeDef_h

#  include <stdint.h>
#  include <memory>

#  ifdef _WIN32
#    ifndef WIN32_LEAN_AND_MEAN
#      define WIN32_LEAN_AND_MEAN
#    endif
#    include <windows.h>
#    ifdef TCCC_EXPORTS
#      define TCCC_API __declspec(dllexport)
#    else
#      define TCCC_API __declspec(dllimport)
#    endif
#  elif __APPLE__
#    include <TargetConditionals.h>
#    define TCCC_API __attribute__((visibility("default")))
#  elif __ANDROID__
#    define TCCC_API __attribute__((visibility("default")))
#  else
#    define TCCC_API
#  endif

#  define TARGET_PLATFORM_DESKTOP ((__APPLE__ && TARGET_OS_MAC && !TARGET_OS_IPHONE) || _WIN32)
#  define TARGET_PLATFORM_PHONE (__ANDROID__ || (__APPLE__ && TARGET_OS_IOS))
#  define TARGET_PLATFORM_MAC (__APPLE__ && TARGET_OS_MAC && !TARGET_OS_IPHONE)

namespace tccc {
/////////////////////////////////////////////////////////////////////////////////
//
//                    TCCC 核心类型定义
//
/////////////////////////////////////////////////////////////////////////////////
/**
 * 1.1 登录模式
 */
enum TCCCLoginType {
  /// sip模式
  Sip = 0,
  /// 坐席模式
  Agent = 1,
  ///  特殊模式(为企点提供)，外部客户不需要使用该类型
  NoDomainModel = 2,
};

/**
 * 1.1 登录参数
 */
struct TCCCLoginParams {
  /// 【字段含义】应用标识（必填），腾讯云基于 sdkAppId 完成计费统计。暂时无作用可不填写
  /// 【推荐取值】在 [联络中心控制台](https://console.cloud.tencent.com/cccc/) 创建应用后可以在账号信息页面中得到该 ID。
  uint32_t sdkAppId;

  /// 【字段含义】用户标识（必填），当前用户的 userId，相当于用户名，使用 UTF-8 编码。
  /// 【推荐取值】格式 <scheme> : <user> @<host>。如
  ///  sip:3013@1400xxxx.tccc.qcloud.com，其中3013为分机号，1400xxxx为你的tccc应用ID
  const char *userId;
  /// sip 密码。在登录模式为Sip、NoDomainModel必填
  const char *password;

  /// 登录票据，在登录模式为Agent必填。更多详情请参见[创建 SDK 登录
  /// Token](https://cloud.tencent.com/document/product/679/49227)
  const char *token;

  /// 【字段含义】登录模式，默认是Sip模式。Sip模式下需要userId和password，坐席模式暂时不支持
  TCCCLoginType type;

  TCCCLoginParams() : sdkAppId(0), userId(""), password(""), token(""), type(TCCCLoginType::Sip) {}
};
/**
 * 1.2 登录返回值
 */
struct TCCCLoginInfo {
  /// 【字段含义】用户标识（必填），当前用户的 userId，相当于用户名，使用 UTF-8 编码。
  /// 【推荐取值】如果一个用户在您的帐号系统中的 ID 为“mike”，则 userId 即可设置为“mike”。
  const char *userId;
  /// 用户Aor。格式 user@host[:port]
  const char *userAor;
  /// 其他信息，用来定位问题。
  const char *otherInfo;

  TCCCLoginInfo() : userId(nullptr), userAor(nullptr), otherInfo(nullptr) {}
};
/**
 * 1.3 呼叫类型
 */
enum TCCCCallType {
  /// Voip
  Voip = 0,
  /// 视频
  Video = 1,
};

/**
 * 1.4 拨打参数
 */
struct TCCCStartCallParams {
  /// 【字段含义】被叫号码（必填），可以是电话号码，如手机号为1343xxxx
  const char *to;

  /// 【字段含义】号码备注，在通话条中会替代号码显示（可选）
  const char *remark;

  /// 【字段含义】户自定义数据（可选），传入后可通过 [电话 CDR
  /// 事件](https://cloud.tencent.com/document/product/679/67257) 推送返回
  ///  参考 https://cloud.tencent.com/document/product/679/67257
  const char *uui;

  /// 【字段含义】指定技能组内绑定的外呼号码（可选）
  const char *skillGroupId;

  /// 【字段含义】指定外呼号码（可选），暂时不支持
  const char *callerPhoneNumber;

  /// 【字段含义】号码加密类型（可选）。目前仅支持'reflect'或者是'base64'，在开启 号码映射
  /// 时强制使用真实号码。暂时不支持
  const char *phoneEncodeType;

  /// 【字段含义】指定号码 ID 列表（可选）。该字符串其实是一个数组1|2|3|4，用|分割。暂时不支持
  const char *servingNumberGroupIds;

  /// 【字段含义】呼叫类型（可选），默认是语音
  TCCCCallType type;

  TCCCStartCallParams()
      : to(""),
        remark(nullptr),
        uui(nullptr),
        skillGroupId(nullptr),
        callerPhoneNumber(nullptr),
        phoneEncodeType(nullptr),
        servingNumberGroupIds(nullptr),
        type(TCCCCallType::Voip) {}
};

/**
 * 1.5 Tccc 会话方向
 */
enum TCCCSessionDirection {
  /// 呼入
  CallIn = 0,
  /// 呼出
  CallOut = 1,
};

/**
 * 1.6 Tccc 会话信息
 */
struct TCCCSessionInfo {
  /// 【字段含义】会话ID。
  const char *sessionID;

  /// 【字段含义】被叫（必填），可以是电话号码，使用 UTF-8 编码。
  const char *toUserID;

  // 【字段含义】被叫。格式 <user>@<host>:[:port]
  const char *toAor;

  /// 【字段含义】主叫，可以是电话号码，使用 UTF-8 编码。
  const char *fromUserID;

  /// 【字段含义】主叫Aor , 格式 <user>@<host>:[:port]
  const char *fromAor;

  /// 获取所有自定义字段和值
  const char *customHeaderJson;

  /// 获取会话方向
  TCCCSessionDirection sessionDirection;

  TCCCSessionInfo(const char *sessionID_, const char *toUserID_, const char *toAor_, const char *fromUserID_,
                  const char *fromAor_, const char *customHeaderJson_, TCCCSessionDirection sessionDirection_)
      : sessionID(sessionID_),
        toUserID(toUserID_),
        toAor(toAor_),
        fromUserID(fromUserID_),
        fromAor(fromAor_),
        customHeaderJson(customHeaderJson_),
        sessionDirection(sessionDirection_) {}
  TCCCSessionInfo()
      : sessionID(nullptr),
        toUserID(nullptr),
        toAor(nullptr),
        fromUserID(nullptr),
        fromAor(nullptr),
        customHeaderJson(nullptr),
        sessionDirection(TCCCSessionDirection::CallIn) {}
};

/**
 * 1.7 Tccc 转接会话参数
 */
struct TCCCtransferParams {
  const char *sessionId;
  TCCCtransferParams() : sessionId(nullptr) {}
};

/// 坐席状态
enum AgentStatus {
  /// 离线
  Offline = 0,
  /// 空闲
  Free = 100,
  ///
  Busy = 200,
  ///
  Rest = 300,
  ///
  Countdown = 400,
  ///
  Arrange = 500,
  ///
  StopRest = 600,
  ///
  NotReady = 700,
  ///
  StopNotRead = 800,

};

/////////////////////////////////////////////////////////////////////////////////
//
//                    网络相关枚举值定义
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 5.5 网络质量
 *
 * TCCC 会每隔两秒对当前的网络质量进行评估，评估结果为六个等级：Excellent 表示最好，Down 表示最差。
 */
enum TCCCQuality {

  /// 未定义
  TCCCQuality_Unknown = 0,

  /// 当前网络非常好
  TCCCQuality_Excellent = 1,

  /// 当前网络比较好
  TCCCQuality_Good = 2,

  /// 当前网络一般
  TCCCQuality_Poor = 3,

  /// 当前网络较差
  TCCCQuality_Bad = 4,

  /// 当前网络很差
  TCCCQuality_Vbad = 5,

  /// 当前网络不满足 TCCC 的最低要求
  TCCCQuality_Down = 6,

};

/**
 * 5.6 网络质量
 *
 * 表征网络质量的好坏，您可以通过该数值在用户界面上展示每个用户的网络质量。
 */
struct TCCCQualityInfo {
  /// 用户 ID
  const char *userId;

  /// 网络质量
  TCCCQuality quality;
  TCCCQualityInfo() : userId(nullptr), quality(TCCCQuality_Unknown) {}
};

/**
 * 5.7 测速参数
 *
 * 您可以在用户进入房间前通过 {@link startSpeedTest} 接口测试网速（注意：请不要在通话中调用）。
 */
struct TCCCSpeedTestParams {
  /// 应用标识，请参考 {@link TCCCSpeedTestParams} 中的相关说明。
  int sdkAppId;

  /// 用户标识，请参考 {@link TCCCSpeedTestParams} 中的相关说明。
  const char *userId;

  /// 用户签名，请参考 {@link TCCCSpeedTestParams} 中的相关说明。
  const char *userSig;

  /// 预期的上行带宽（kbps，取值范围： 10 ～ 5000，为 0 时不测试）。
  int expectedUpBandwidth;

  /// 预期的下行带宽（kbps，取值范围： 10 ～ 5000，为 0 时不测试）。
  int expectedDownBandwidth;

  TCCCSpeedTestParams()
      : sdkAppId(0), userId(nullptr), userSig(nullptr), expectedUpBandwidth(0), expectedDownBandwidth(0) {}
};

/**
 * 5.8 网络测速结果
 *
 * 您可以在用户进入房间前通过 {@link startSpeedTest:} 接口进行测速（注意：请不要在通话中调用）。
 */
struct TCCCSpeedTestResult {
  /// 测试是否成功。
  bool success;

  /// 带宽测试错误信息。
  const char *errMsg;

  /// 服务器 IP 地址。
  const char *ip;

  /// 内部通过评估算法测算出的网络质量，更多信息请参见 {@link TCCCQuality}。
  TCCCQuality quality;

  /// 上行丢包率，取值范围是 [0 - 1.0]，例如 0.3 表示每向服务器发送 10 个数据包可能会在中途丢失 3 个。
  float upLostRate;

  /// 下行丢包率，取值范围是 [0 - 1.0]，例如 0.2 表示每从服务器收取 10 个数据包可能会在中途丢失 2 个。
  float downLostRate;

  /// 延迟（毫秒），指当前设备到 RTC 服务器的一次网络往返时间，该值越小越好，正常数值范围是10ms - 100ms。
  int rtt;

  /// 上行带宽（kbps，-1：无效值）。
  int availableUpBandwidth;

  /// 下行带宽（kbps，-1：无效值）。
  int availableDownBandwidth;

  TCCCSpeedTestResult()
      : success(false),
        errMsg(nullptr),
        ip(nullptr),
        quality(TCCCQuality_Unknown),
        upLostRate(0.0f),
        downLostRate(0.0f),
        rtt(0),
        availableUpBandwidth(0),
        availableDownBandwidth(0) {}
};

/////////////////////////////////////////////////////////////////////////////////
//
//                    音频相关枚举值定义
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 6.1 音量大小信息
 */
struct TCCCVolumeInfo {
  /// 说话者的 userId, 如果 userId 为空则代表是当前用户自己。
  const char *userId;
  /// 说话者的音量大小, 取值范围[0 - 100]。
  uint32_t volume;
  TCCCVolumeInfo() : userId(""), volume(0) {}
};

/////////////////////////////////////////////////////////////////////////////////
//
//                      更多枚举值定义
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 4.1 Log 级别
 *
 * 不同的日志等级定义了不同的详实程度和日志数量，推荐一般情况下将日志等级设置为：TCCCLogLevelInfo。
 */
enum TCCCLogLevel {
  /// 输出所有级别的 Log
  TCCCLogLevelVerbose = 0,

  /// 输出 DEBUG，INFO，WARNING，ERROR 和 FATAL 级别的 Log
  TCCCLogLevelDebug = 1,

  /// 输出 INFO，WARNING，ERROR 和 FATAL 级别的 Log
  TCCCLogLevelInfo = 2,

  /// 输出WARNING，ERROR 和 FATAL 级别的 Log
  TCCCLogLevelWarn = 3,

  /// 输出ERROR 和 FATAL 级别的 Log
  TCCCLogLevelError = 4,

  /// 仅输出 FATAL 级别的 Log
  TCCCLogLevelFatal = 5,

  /// 不输出任何 SDK Log
  TCCCLogLevelNone = 6,

};

/**
 * 5.1 视频流类型
 *
 * TCCC 内部有三种不同的视频流，分别是：
 *  - 高清大画面：一般用来传输摄像头的视频数据。
 *  - 低清小画面：小画面和大画面的内容相互，但是分辨率和码率都比大画面低，因此清晰度也更低。
 *  -
 * 辅流画面：一般用于屏幕分享，同一时间在同一个房间中只允许一个用户发布辅流视频，其他用户必须要等该用户关闭之后才能发布自己的辅流。
 * @note 不支持单独开启低清小画面，小画面必须依附于大画面而存在，SDK 会自动设定低清小画面的分辨率和码率。
 */
enum TCCCVideoStreamType {

  /// 高清大画面，一般用来传输摄像头的视频数据。
  TCCCVideoStreamTypeBig = 0,

  /// 低清小画面：小画面和大画面的内容相互，但是分辨率和码率都比大画面低，因此清晰度也更低。
  TCCCVideoStreamTypeSmall = 1,

  /// 辅流画面：一般用于屏幕分享，同一时间在同一个房间中只允许一个用户发布辅流视频，其他用户必须要等该用户关闭之后才能发布自己的辅流。
  TCCCVideoStreamTypeSub = 2,

};

/////////////////////////////////////////////////////////////////////////////////
//
//                    网络和性能的汇总统计指标
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 本地的音视频统计指标
 */
struct TCCCLocalStatistics {
  /// 【字段含义】本地视频的宽度，单位 px。
  uint32_t width;

  /// 【字段含义】本地视频的高度，单位 px。
  uint32_t height;

  /// 【字段含义】本地视频的帧率，即每秒钟会有多少视频帧，单位：FPS。
  uint32_t frameRate;

  /// 【字段含义】本地视频的码率，即每秒钟新产生视频数据的多少，单位 Kbps。
  uint32_t videoBitrate;

  /// 【字段含义】本地音频的采样率，单位 Hz。
  uint32_t audioSampleRate;

  /// 【字段含义】本地音频的码率，即每秒钟新产生音频数据的多少，单位 Kbps。
  uint32_t audioBitrate;

  /// 【字段含义】视频流类型（高清大画面|低清小画面|辅流画面）。
  TCCCVideoStreamType streamType;

  /// 【字段含义】音频设备采集状态（用于检测音频外设的健康度）。
  ///  0：采集设备状态正常；1：检测到长时间静音；2：检测到破音；3：检测到声音异常间断。
  uint32_t audioCaptureState;

  TCCCLocalStatistics()
      : width(0),
        height(0),
        frameRate(0),
        videoBitrate(0),
        audioSampleRate(0),
        audioBitrate(0),
        streamType(TCCCVideoStreamTypeBig),
        audioCaptureState(0) {}
};

/**
 * 远端的音视频统计指标
 */
struct TCCCRemoteStatistics {
  /// 【字段含义】用户 ID
  char *userId;

  /// 【字段含义】音频流的总丢包率（％）。
  ///  audioPacketLoss 代表音频流历经`主播>云端>观众`这样一条完整的传输链路后，最终在观众端统计到的丢包率。
  ///  audioPacketLoss 越小越好，丢包率为0即表示该路音频流的所有数据均已经完整地到达了观众端。
  /// 如果出现了 downLoss == 0 但 audioPacketLoss != 0
  /// 的情况，说明该路音频流在“云端=>观众”这一段链路上没有出现丢包，但是在`主播>云端`这一段链路上出现了不可恢复的丢包。
  uint32_t audioPacketLoss;

  /// 【字段含义】该路视频流的总丢包率（％）。
  ///  videoPacketLoss 代表该路视频流历经`主播>云端>观众`这样一条完整的传输链路后，最终在观众端统计到的丢包率。
  ///  videoPacketLoss 越小越好，丢包率为0即表示该路视频流的所有数据均已经完整地到达了观众端。
  /// 如果出现了 downLoss == 0 但 videoPacketLoss != 0
  /// 的情况，说明该路视频流在`云端>观众`这一段链路上没有出现丢包，但是在`主播>云端`这一段链路上出现了不可恢复的丢包。
  uint32_t videoPacketLoss;

  /// 【字段含义】远端视频的宽度，单位 px。
  uint32_t width;

  /// 【字段含义】远端视频的高度，单位 px。
  uint32_t height;

  /// 【字段含义】远端视频的帧率，单位：FPS。
  uint32_t frameRate;

  /// 【字段含义】远端视频的码率，单位 Kbps。
  uint32_t videoBitrate;

  /// 【字段含义】本地音频的采样率，单位 Hz。
  uint32_t audioSampleRate;

  /// 【字段含义】本地音频的码率，单位 Kbps
  uint32_t audioBitrate;

  /// 【字段含义】播放延迟，单位 ms
  /// 为了避免网络抖动和网络包乱序导致的声音和画面卡顿，TCCC
  /// 会在播放端管理一个播放缓冲区，用于对接收到的网络数据包进行整理，该缓冲区的大小会根据当前的网络质量进行自适应调整，该缓冲区的大小折算成以毫秒为单位的时间长度，也就是
  ///  jitterBufferDelay。
  uint32_t jitterBufferDelay;

  /// 【字段含义】端到端延迟，单位 ms
  ///  point2PointDelay 代表 “主播=>云端=>观众”
  ///  的延迟，更准确地说，它代表了“采集=>编码=>网络传输=>接收=>缓冲=>解码=>播放” 全链路的延迟。 point2PointDelay
  ///  需要本地和远端的 SDK 均为 8.5 及以上的版本才生效，若远端用户为 8.5 以前的版本，此数值会一直为0，代表无意义。
  uint32_t point2PointDelay;

  /// 【字段含义】音频播放的累计卡顿时长，单位 ms
  uint32_t audioTotalBlockTime;

  /// 【字段含义】音频播放卡顿率，单位 (%)
  /// 音频播放卡顿率（audioBlockRate） = 音频播放的累计卡顿时长（audioTotalBlockTime） / 音频播放的总时长
  uint32_t audioBlockRate;

  /// 【字段含义】视频播放的累计卡顿时长，单位 ms
  uint32_t videoTotalBlockTime;

  /// 【字段含义】视频播放卡顿率，单位 (%) 视频播放卡顿率（videoBlockRate） =
  /// 视频播放的累计卡顿时长（videoTotalBlockTime） / 视频播放的总时长。
  uint32_t videoBlockRate;

  /// 【字段含义】该路音视频流的总丢包率（％）。已废弃，不推荐使用；建议使用 audioPacketLoss、videoPacketLoss 替代。
  uint32_t finalLoss;

  /// 【字段含义】视频流类型（高清大画面|低清小画面|辅流画面）。
  TCCCVideoStreamType streamType;

  TCCCRemoteStatistics()
      : userId(nullptr),
        audioPacketLoss(0),
        videoPacketLoss(0),
        width(0),
        height(0),
        frameRate(0),
        videoBitrate(0),
        audioSampleRate(0),
        audioBitrate(0),
        jitterBufferDelay(0),
        point2PointDelay(0),
        audioTotalBlockTime(0),
        audioBlockRate(0),
        videoTotalBlockTime(0),
        videoBlockRate(0),
        finalLoss(0),
        streamType(TCCCVideoStreamTypeBig) {}

  TCCCRemoteStatistics(const TCCCRemoteStatistics &temp) {
    int nLength = strlen(temp.userId);
    userId = new char[nLength + 1];
    memset(userId, 0, sizeof(userId));
    strcpy(userId, temp.userId);
    audioPacketLoss = temp.audioBitrate;
    videoPacketLoss = temp.videoPacketLoss;
    width = temp.width;
    height = temp.height;
    frameRate = temp.frameRate;
    videoBitrate = temp.videoBitrate;
    audioSampleRate = temp.audioSampleRate;
    audioBitrate = temp.audioBitrate;
    jitterBufferDelay = temp.jitterBufferDelay;
    point2PointDelay = temp.point2PointDelay;
    audioTotalBlockTime = temp.audioTotalBlockTime;
    audioBlockRate = temp.audioBlockRate;
    videoTotalBlockTime = temp.videoTotalBlockTime;
    videoBlockRate = temp.videoBlockRate;
    finalLoss = temp.finalLoss;
    streamType = temp.streamType;
  }
  ~TCCCRemoteStatistics() { delete[] userId; }
};

/**
 * 网络和性能的汇总统计指标
 */
struct TCCCStatistics {
  /// 【字段含义】当前应用的 CPU 使用率，单位 (%)，Android 8.0 以上不支持。
  uint32_t appCpu;

  /// 【字段含义】当前系统的 CPU 使用率，单位 (%)，Android 8.0 以上不支持。
  uint32_t systemCpu;

  /// 【字段含义】从 SDK 到云端的上行丢包率，单位 (%)
  /// 该数值越小越好，如果 upLoss 为 0%，则意味着上行链路的网络质量很好，上传到云端的数据包基本不发生丢失。
  /// 如果 upLoss 为 30%，则意味着 SDK 向云端发送的音视频数据包中，会有 30% 丢失在传输链路中。
  uint32_t upLoss;

  /// 【字段含义】从云端到 SDK 的下行丢包率，单位 (%)
  /// 该数值越小越好，如果 downLoss 为 0%，则意味着下行链路的网络质量很好，从云端接收的数据包基本不发生丢失。
  /// 如果 downLoss 为 30%，则意味着云端向 SDK 传输的音视频数据包中，会有 30% 丢失在传输链路中。
  uint32_t downLoss;

  /// 【字段含义】从 SDK 到云端的往返延时，单位 ms
  /// 该数值代表从 SDK 发送一个网络包到云端，再从云端回送一个网络包到 SDK 的总计耗时，也就是一个网络包经历
  /// “SDK=>云端=>SDK” 的总耗时。 该数值越小越好：如果 rtt < 50ms，意味着较低的音视频通话延迟；如果 rtt >
  ///  200ms，则意味着较高的音视频通话延迟。 需要特别解释的是，rtt 代表 “SDK=>云端=>SDK” 的总耗时，所不需要区分 upRtt 和
  ///  downRtt。
  uint32_t rtt;

  /// 【字段含义】从 SDK 到本地路由器的往返时延，单位 ms 该数值代表从 SDK
  /// 发送一个网络包到本地路由器网关，再从网关回送一个网络包到 SDK 的总计耗时，也就是一个网络包经历 【SDK>网关>SDK【
  /// 的总耗时。 该数值越小越好：如果 gatewayRtt < 50ms，意味着较低的音视频通话延迟；如果 gatewayRtt >
  ///  200ms，则意味着较高的音视频通话延迟。 当网络类型为蜂窝网时，该值无效。
  uint32_t gatewayRtt;

  /// 【字段含义】总发送字节数（包含信令数据和音视频数据），单位：字节数（Bytes）。
  uint32_t sentBytes;

  /// 【字段含义】总接收字节数（包含信令数据和音视频数据），单位：字节数（Bytes）。
  uint32_t receivedBytes;

  /// 【字段含义】本地的音视频统计信息
  /// 由于本地可能有三路音视频流（即高清大画面，低清小画面，以及辅流画面），因此本地的音视频统计信息是一个数组。
  TCCCLocalStatistics *localStatisticsArray;

  /// 【字段含义】数组 localStatisticsArray 的大小
  uint32_t localStatisticsArraySize;

  /// 【字段含义】远端的音视频统计信息
  /// 因为同时可能有多个远端用户，而且每个远端用户同时可能有多路音视频流（即高清大画面，低清小画面，以及辅流画面），因此远端的音视频统计信息是一个数组。
  TCCCRemoteStatistics *remoteStatisticsArray;

  /// 【字段含义】数组 remoteStatisticsArray 的大小。
  uint32_t remoteStatisticsArraySize;

  TCCCStatistics()
      : appCpu(0),
        systemCpu(0),
        upLoss(0),
        downLoss(0),
        rtt(0),
        gatewayRtt(0),
        sentBytes(0),
        receivedBytes(0),
        localStatisticsArray(nullptr),
        localStatisticsArraySize(0),
        remoteStatisticsArray(nullptr),
        remoteStatisticsArraySize(0) {}
};

}  // namespace tccc

#endif /* TCCCTypeDef_h */
       /// @}
