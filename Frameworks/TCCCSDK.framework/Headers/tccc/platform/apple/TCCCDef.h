#import <Foundation/Foundation.h>

/**
 * 1.1 登录模式
 */
typedef NS_ENUM(NSInteger, TXLoginType) {
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
@interface TXLoginParams : NSObject

/// 【字段含义】应用标识（必填），腾讯云基于 sdkAppId 完成计费统计。暂时无作用可不填写
/// 【推荐取值】在 [联络中心控制台](https://console.cloud.tencent.com/cccc/) 创建应用后可以在账号信息页面中得到该 ID。
@property(nonatomic, assign) UInt32 sdkAppId;

/// 【字段含义】用户标识（必填），当前用户的 userId，相当于用户名，使用 UTF-8 编码。
/// 【推荐取值】格式 <scheme> : <user> @<host>。如
///  sip:3013@1400xxxx.tccc.qcloud.com，其中3013为分机号，1400xxxx为你的tccc应用ID
@property(nonatomic, copy, nonnull) NSString *userId;

/// sip 密码。在登录模式为Sip、NoDomainModel必填
@property(nonatomic, copy, nonnull) NSString *token;

/// 登录票据，在登录模式为Agent必填。更多详情请参见[创建 SDK 登录
/// Token](https://cloud.tencent.com/document/product/679/49227)
@property(nonatomic, copy, nonnull) NSString *password;

/// 【字段含义】登录模式，默认是Sip模式。Sip模式下需要userId和password，坐席模式需要userId和token
@property(nonatomic, assign) TXLoginType type;

@end

/**
 * 1.2 登录返回值
 */
@interface TXLoginInfo : NSObject
/// 【字段含义】用户标识（必填），当前用户的 userId，相当于用户名，使用 UTF-8 编码。
/// 【推荐取值】如果一个用户在您的帐号系统中的 ID 为“mike”，则 userId 即可设置为“mike”。
@property(nonatomic, copy, nonnull) NSString *userId;

/// 用户Aor。格式 user@host[:port]
@property(nonatomic, copy, nonnull) NSString *userAor;

/// 其他信息，用来定位问题。
@property(nonatomic, copy, nonnull) NSString *otherInfo;

@end

/**
 * 1.3 呼叫类型
 */
typedef NS_ENUM(NSInteger, TXCallType) {
  /// Voip
  Voip = 0,
  /// 视频
  Video = 1,
};

/**
 * 1.4 拨打参数
 */
@interface TXStartCallParams : NSObject

/// 【字段含义】被叫号码（必填），可以是电话号码，如手机号为1343xxxx
@property(nonatomic, copy, nonnull) NSString *to;

/// 【字段含义】号码备注，在通话条中会替代号码显示（可选）
@property(nonatomic, copy, nonnull) NSString *remark;

/// 【字段含义】户自定义数据（可选），传入后可通过 [电话 CDR
/// 事件](https://cloud.tencent.com/document/product/679/67257) 推送返回
///  参考 https://cloud.tencent.com/document/product/679/67257
@property(nonatomic, copy, nonnull) NSString *uui;

/// 【字段含义】指定技能组内绑定的外呼号码（可选）
@property(nonatomic, copy, nonnull) NSString *skillGroupId;

/// 【字段含义】指定外呼号码（可选），。暂时不支持
@property(nonatomic, copy, nonnull) NSString *callerPhoneNumber;

/// 【字段含义】号码加密类型（可选）。目前仅支持'reflect'或者是'base64'，在开启 号码映射
/// 时强制使用真实号码。暂时不支持
@property(nonatomic, copy, nonnull) NSString *phoneEncodeType;

/// 【字段含义】指定号码 ID 列表（可选）。暂时不支持
@property(nonatomic, strong) NSArray<NSString *> *_Nullable servingNumberGroupIds;

/// 【字段含义】呼叫类型（可选），默认是语音
@property(nonatomic, assign) TXCallType type;

@end

/**
 * 1.5 Tccc 会话方向
 */
typedef NS_ENUM(NSInteger, TXSessionDirection) {
  /// 呼入
  CallIn = 0,
  /// 呼出
  CallOut = 1,
};

/**
 * 1.6 Tccc 会话信息
 */
@interface TXSessionInfo : NSObject
/// 【字段含义】会话ID。
@property(nonatomic, copy, nonnull) NSString *sessionID;

/// 【字段含义】被叫（必填），可以是电话号码，使用 UTF-8 编码。
@property(nonatomic, copy, nonnull) NSString *toUserID;

// 【字段含义】被叫。格式 <user>@<host>:[:port]
@property(nonatomic, copy, nonnull) NSString *toAor;

/// 【字段含义】主叫，可以是电话号码，使用 UTF-8 编码。
@property(nonatomic, copy, nonnull) NSString *fromUserID;

/// 【字段含义】主叫Aor , 格式 <user>@<host>:[:port]
@property(nonatomic, copy, nonnull) NSString *fromAor;

/// 获取所有自定义字段和值
@property(nonatomic, copy, nonnull) NSString *customHeaderJson;

/// 获取会话方向
@property(nonatomic, assign) TXSessionDirection sessionDirection;

@end

/**
 * 1.7 Tccc 转接会话参数
 */
@interface TXTransferParams : NSObject

@property(nonatomic, copy, nonnull) NSString *sessionId;

@end

/// 坐席状态
typedef NS_ENUM(NSInteger, TXAgentStatus) {
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
typedef NS_ENUM(NSInteger, TXQuality) {

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
@interface TXQualityInfo : NSObject
/// 用户 ID
@property(nonatomic, copy, nonnull) NSString *userId;

/// 网络质量
@property(nonatomic, assign) TXQuality quality;

@end

/**
 * 5.7 测速参数
 *
 * 您可以在用户进入房间前通过 {@link startSpeedTest} 接口测试网速（注意：请不要在通话中调用）。
 */
@interface TXSpeedTestParams : NSObject
/// 应用标识，请参考 {@link TCCCSpeedTestParams} 中的相关说明。
@property(nonatomic, assign) UInt32 sdkAppId;

/// 用户标识，请参考 {@link TCCCSpeedTestParams} 中的相关说明。
@property(nonatomic, copy, nonnull) NSString *userId;

// 用户签名，请参考 {@link TCCCSpeedTestParams} 中的相关说明。
@property(nonatomic, copy, nonnull) NSString *userSig;

/// 预期的上行带宽（kbps，取值范围： 10 ～ 5000，为 0 时不测试）。
@property(nonatomic, assign) UInt32 expectedUpBandwidth;

/// 预期的下行带宽（kbps，取值范围： 10 ～ 5000，为 0 时不测试）。
@property(nonatomic, assign) UInt32 expectedDownBandwidth;

@end

/**
 * 5.8 网络测速结果
 *
 * 您可以在用户进入房间前通过 {@link startSpeedTest:} 接口进行测速（注意：请不要在通话中调用）。
 */
@interface TCCCSpeedTestResult : NSObject
/// 测试是否成功。
@property(nonatomic, assign) BOOL success;

/// 带宽测试错误信息。
@property(nonatomic, copy, nonnull) NSString *errMsg;

/// 服务器 IP 地址。
@property(nonatomic, copy, nonnull) NSString *ip;

/// 内部通过评估算法测算出的网络质量，更多信息请参见 {@link TCCCQuality}。
@property(nonatomic, assign) TXQuality quality;

/// 上行丢包率，取值范围是 [0 - 1.0]，例如 0.3 表示每向服务器发送 10 个数据包可能会在中途丢失 3 个。
@property(nonatomic, assign) float upLostRate;

/// 下行丢包率，取值范围是 [0 - 1.0]，例如 0.2 表示每从服务器收取 10 个数据包可能会在中途丢失 2 个。
@property(nonatomic, assign) float downLostRate;

/// 延迟（毫秒），指当前设备到 RTC 服务器的一次网络往返时间，该值越小越好，正常数值范围是10ms - 100ms。
@property(nonatomic, assign) UInt32 rtt;

/// 上行带宽（kbps，-1：无效值）。
@property(nonatomic, assign) UInt32 availableUpBandwidth;

/// 下行带宽（kbps，-1：无效值）。
@property(nonatomic, assign) UInt32 availableDownBandwidth;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                    音频相关枚举值定义
//
/////////////////////////////////////////////////////////////////////////////////
/**
 * 6.1 音量大小信息
 */
@interface TXVolumeInfo : NSObject
/// 说话者的 userId, 如果 userId 为空则代表是当前用户自己。
@property(nonatomic, copy, nonnull) NSString *userId;
/// 说话者的音量大小, 取值范围[0 - 100]。
@property(nonatomic, assign) UInt32 volume;
@end

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
typedef NS_ENUM(NSInteger, TXLogLevel) {
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
 * 4.2 视频流类型
 *
 * TCCC 内部有三种不同的视频流，分别是：
 *  - 高清大画面：一般用来传输摄像头的视频数据。
 *  - 低清小画面：小画面和大画面的内容相互，但是分辨率和码率都比大画面低，因此清晰度也更低。
 *  -
 * 辅流画面：一般用于屏幕分享，同一时间在同一个房间中只允许一个用户发布辅流视频，其他用户必须要等该用户关闭之后才能发布自己的辅流。
 * @note 不支持单独开启低清小画面，小画面必须依附于大画面而存在，SDK 会自动设定低清小画面的分辨率和码率。
 */
typedef NS_ENUM(NSInteger, TXVideoStreamType) {

  /// 高清大画面，一般用来传输摄像头的视频数据。
  TCCCVideoStreamTypeBig = 0,

  /// 低清小画面：小画面和大画面的内容相互，但是分辨率和码率都比大画面低，因此清晰度也更低。
  TCCCVideoStreamTypeSmall = 1,

  /// 辅流画面：一般用于屏幕分享，同一时间在同一个房间中只允许一个用户发布辅流视频，其他用户必须要等该用户关闭之后才能发布自己的辅流。
  TCCCVideoStreamTypeSub = 2,

};

/**
 * 4.3 结束原因
 */
typedef NS_ENUM(NSInteger, TXEndedReason) {
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
  Rejected, // Only as UAS, UAC has distinct onFailure callback
  /// 被转接而结束
  Referred //! slg! - This is really Redirected - not sure why it is called Referred.  Only gets used when we send a
           //! redirect (ie: 302).
};

/**
 * 4.4后台服务类型
 */
typedef NS_ENUM(NSInteger, TXServerType) {
  /// TCCC的服务
  TCCCServer = 0,
  /// 实时通话的RTC服务
  TRTCServer = 1,
};

/////////////////////////////////////////////////////////////////////////////////
//
//                    网络和性能的汇总统计指标
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 本地的音视频统计指标
 */
@interface TXLocalStatistics : NSObject

/// 【字段含义】本地视频的宽度，单位 px。
@property(nonatomic, assign) UInt32 width;

/// 【字段含义】本地视频的高度，单位 px。
@property(nonatomic, assign) UInt32 height;

/// 【字段含义】本地视频的帧率，即每秒钟会有多少视频帧，单位：FPS。
@property(nonatomic, assign) UInt32 frameRate;

/// 【字段含义】本地视频的码率，即每秒钟新产生视频数据的多少，单位 Kbps。
@property(nonatomic, assign) UInt32 videoBitrate;

/// 【字段含义】本地音频的采样率，单位 Hz。
@property(nonatomic, assign) UInt32 audioSampleRate;

/// 【字段含义】本地音频的码率，即每秒钟新产生音频数据的多少，单位 Kbps。
@property(nonatomic, assign) UInt32 audioBitrate;

/// 【字段含义】视频流类型（高清大画面|低清小画面|辅流画面）。
@property(nonatomic, assign) TXVideoStreamType streamType;

/// 【字段含义】音频设备采集状态（用于检测音频外设的健康度）。
///  0：采集设备状态正常；1：检测到长时间静音；2：检测到破音；3：检测到声音异常间断。
@property(nonatomic, assign) UInt32 audioCaptureState;

@end

/**
 * 远端的音视频统计指标
 */
@interface TXRemoteStatistics : NSObject
/// 【字段含义】用户 ID
@property(nonatomic, copy, nonnull) NSString *userId;

/// 【字段含义】音频流的总丢包率（％）。
///  audioPacketLoss 代表音频流历经`主播>云端>观众`这样一条完整的传输链路后，最终在观众端统计到的丢包率。
///  audioPacketLoss 越小越好，丢包率为0即表示该路音频流的所有数据均已经完整地到达了观众端。
/// 如果出现了 downLoss == 0 但 audioPacketLoss != 0
/// 的情况，说明该路音频流在“云端=>观众”这一段链路上没有出现丢包，但是在`主播>云端`这一段链路上出现了不可恢复的丢包。
@property(nonatomic, assign) UInt32 audioPacketLoss;

/// 【字段含义】该路视频流的总丢包率（％）。
///  videoPacketLoss 代表该路视频流历经`主播>云端>观众`这样一条完整的传输链路后，最终在观众端统计到的丢包率。
///  videoPacketLoss 越小越好，丢包率为0即表示该路视频流的所有数据均已经完整地到达了观众端。
/// 如果出现了 downLoss == 0 但 videoPacketLoss != 0
/// 的情况，说明该路视频流在`云端>观众`这一段链路上没有出现丢包，但是在`主播>云端`这一段链路上出现了不可恢复的丢包。
@property(nonatomic, assign) UInt32 videoPacketLoss;

/// 【字段含义】远端视频的宽度，单位 px。
@property(nonatomic, assign) UInt32 width;

/// 【字段含义】远端视频的高度，单位 px。
@property(nonatomic, assign) UInt32 height;

/// 【字段含义】远端视频的帧率，单位：FPS。
@property(nonatomic, assign) UInt32 frameRate;

/// 【字段含义】远端视频的码率，单位 Kbps。
@property(nonatomic, assign) UInt32 videoBitrate;

/// 【字段含义】本地音频的采样率，单位 Hz。
@property(nonatomic, assign) UInt32 audioSampleRate;

/// 【字段含义】本地音频的码率，单位 Kbps
@property(nonatomic, assign) UInt32 audioBitrate;

/// 【字段含义】播放延迟，单位 ms
/// 为了避免网络抖动和网络包乱序导致的声音和画面卡顿，TCCC
/// 会在播放端管理一个播放缓冲区，用于对接收到的网络数据包进行整理，该缓冲区的大小会根据当前的网络质量进行自适应调整，该缓冲区的大小折算成以毫秒为单位的时间长度，也就是
///  jitterBufferDelay。
@property(nonatomic, assign) UInt32 jitterBufferDelay;

/// 【字段含义】端到端延迟，单位 ms
///  point2PointDelay 代表 “主播=>云端=>观众”
///  的延迟，更准确地说，它代表了“采集=>编码=>网络传输=>接收=>缓冲=>解码=>播放” 全链路的延迟。 point2PointDelay
///  需要本地和远端的 SDK 均为 8.5 及以上的版本才生效，若远端用户为 8.5 以前的版本，此数值会一直为0，代表无意义。
@property(nonatomic, assign) UInt32 point2PointDelay;

/// 【字段含义】音频播放的累计卡顿时长，单位 ms
@property(nonatomic, assign) UInt32 audioTotalBlockTime;

/// 【字段含义】音频播放卡顿率，单位 (%)
/// 音频播放卡顿率（audioBlockRate） = 音频播放的累计卡顿时长（audioTotalBlockTime） / 音频播放的总时长
@property(nonatomic, assign) UInt32 audioBlockRate;

/// 【字段含义】视频播放的累计卡顿时长，单位 ms
@property(nonatomic, assign) UInt32 videoTotalBlockTime;

/// 【字段含义】视频播放卡顿率，单位 (%) 视频播放卡顿率（videoBlockRate） =
/// 视频播放的累计卡顿时长（videoTotalBlockTime） / 视频播放的总时长。
@property(nonatomic, assign) UInt32 videoBlockRate;

/// 【字段含义】该路音视频流的总丢包率（％）。已废弃，不推荐使用；建议使用 audioPacketLoss、videoPacketLoss 替代。
@property(nonatomic, assign) UInt32 finalLoss;

/// 【字段含义】视频流类型（高清大画面|低清小画面|辅流画面）。
@property(nonatomic, assign) TXVideoStreamType streamType;

@end

/**
 * 网络和性能的汇总统计指标
 */
@interface TXStatistics : NSObject
/// 【字段含义】当前应用的 CPU 使用率，单位 (%)，Android 8.0 以上不支持。
@property(nonatomic, assign) UInt32 appCpu;

/// 【字段含义】当前系统的 CPU 使用率，单位 (%)，Android 8.0 以上不支持。
@property(nonatomic, assign) UInt32 systemCpu;

/// 【字段含义】从 SDK 到云端的上行丢包率，单位 (%)
/// 该数值越小越好，如果 upLoss 为 0%，则意味着上行链路的网络质量很好，上传到云端的数据包基本不发生丢失。
/// 如果 upLoss 为 30%，则意味着 SDK 向云端发送的音视频数据包中，会有 30% 丢失在传输链路中。
@property(nonatomic, assign) UInt32 upLoss;

/// 【字段含义】从云端到 SDK 的下行丢包率，单位 (%)
/// 该数值越小越好，如果 downLoss 为 0%，则意味着下行链路的网络质量很好，从云端接收的数据包基本不发生丢失。
/// 如果 downLoss 为 30%，则意味着云端向 SDK 传输的音视频数据包中，会有 30% 丢失在传输链路中。
@property(nonatomic, assign) UInt32 downLoss;

/// 【字段含义】从 SDK 到云端的往返延时，单位 ms
/// 该数值代表从 SDK 发送一个网络包到云端，再从云端回送一个网络包到 SDK 的总计耗时，也就是一个网络包经历
/// “SDK=>云端=>SDK” 的总耗时。 该数值越小越好：如果 rtt < 50ms，意味着较低的音视频通话延迟；如果 rtt >
///  200ms，则意味着较高的音视频通话延迟。 需要特别解释的是，rtt 代表 “SDK=>云端=>SDK” 的总耗时，所不需要区分 upRtt 和
///  downRtt。
@property(nonatomic, assign) UInt32 rtt;

/// 【字段含义】从 SDK 到本地路由器的往返时延，单位 ms 该数值代表从 SDK
/// 发送一个网络包到本地路由器网关，再从网关回送一个网络包到 SDK 的总计耗时，也就是一个网络包经历 【SDK>网关>SDK【
/// 的总耗时。 该数值越小越好：如果 gatewayRtt < 50ms，意味着较低的音视频通话延迟；如果 gatewayRtt >
///  200ms，则意味着较高的音视频通话延迟。 当网络类型为蜂窝网时，该值无效。
@property(nonatomic, assign) UInt32 gatewayRtt;

/// 【字段含义】总发送字节数（包含信令数据和音视频数据），单位：字节数（Bytes）。
@property(nonatomic, assign) UInt32 sentBytes;

/// 【字段含义】总接收字节数（包含信令数据和音视频数据），单位：字节数（Bytes）。
@property(nonatomic, assign) UInt32 receivedBytes;

/// 【字段含义】本地的音视频统计信息
/// 由于本地可能有三路音视频流（即高清大画面，低清小画面，以及辅流画面），因此本地的音视频统计信息是一个数组。
@property(nonatomic, strong) NSArray<TXLocalStatistics *> *_Nullable localStatisticsArray;

/// 【字段含义】远端的音视频统计信息
/// 因为同时可能有多个远端用户，而且每个远端用户同时可能有多路音视频流（即高清大画面，低清小画面，以及辅流画面），因此远端的音视频统计信息是一个数组。
@property(nonatomic, strong) NSArray<TXRemoteStatistics *> *_Nullable remoteStatisticsArray;

@end
