//
//  TCCCCode.h
//  tccc-workstation-sdk
//
//  Created by gavinwjwang on 2022/7/19.
//

#ifndef TCCCCode_h
#define TCCCCode_h
namespace tccc {
/////////////////////////////////////////////////////////////////////////////////
//
//                     错误码
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 错误类型
 */
enum TCCCError {
  /////////////////////////////////////////////////////////////////////////////////
  //
  //       基础错误码
  //
  /////////////////////////////////////////////////////////////////////////////////
  /// 无错误。成功
  ERR_SIP_SUCCESS = 200,

  /// 无错误。成功
  ERR_NONE = 0,

  /// Http 请求失败，请检查网络连接情况
  ERR_HTTP_REQUEST_FAILURE = -10001,

  /// token登录票据不正确或者已过期
  ERR_HTTP_TOKEN_ERROR = -10002,

  /// 获取坐席配置失败。请联系我们
  ERR_HTTP_GETSIPINFO_ERROR = -10003,

  /// 正在通话中，禁止重置网络操作&发起外呼
  ERR_NETWORK_CANNOT_RESET = -10004,

  /// 你已经退出登录了，请重新登陆
  ERR_HAD_LOGGEDOUT = -10005,

  /// 你调用该接口超过频率的限制，或者是上次调用还没完成又调用了该接口
  ERR_HAD_OVERLIMIT = -10006,

  /// 注销失败
  ERR_UNRIGIST_FAILURE = 20001,

  /// 接听失败，通常是trtc进房失败了
  ERR_ANSWER_FAILURE = 20002,

  /// URI 格式错误。
  ERR_SIPURI_WRONGFORMAT = 20003,

  /// 发送DTMF失败
  ERR_SEND_DTMF_FAILURE = 20004,

  /////////////////////////////////////////////////////////////////////////////////
  //       SIP相关错误码
  /////////////////////////////////////////////////////////////////////////////////

  /// Bad Request 错误请求。通常是坐席没有登录就发起了请求
  ERR_SIP_BAD_REQUEST = 400,

  /// Unauthorized。未授权（用户名密码不对情况）
  ERR_SIP_UNAUTHORIZED = 401,

  /// Payment Required 付费要求，通常是坐席许可满了
  ERR_SIP_PAYMENTREQUIRED = 402,

  /// Forbidden 禁止。密码错误，或者是被踢了
  ERR_SIP_FORBIDDEN = 403,

  /// Not Found 未发现
  ERR_SIP_NOTFOUND = 404,

  /// Method Not Allowed 方法不允许
  ERR_SIP_NOTALLOWED = 405,

  /// Not Acceptable 不可接受
  ERR_SIP_NOTACCEPTABLE = 406,

  /// Proxy Authentication Required  代理需要认证
  ERR_SIP_AUTHENTICATION_REQUIRED = 407,

  /// Request Timeout。请求超时（网络超时）
  ERR_SIP_REQUESTTIMEOUT = 408,

  /// Gone 离开
  ERR_SIP_GONE = 410,

  /// Precondition Failed
  ERR_SIP_PRECONDITION_FAILED = 412,

  /// Request Entity Too Large
  ERR_SIP_TOO_LARGE = 413,

  /// Request-URI Too Long。 请求URL太长（用户ID太长）
  ERR_SIP_URI_TOO_LONG = 414,

  /// Unsupported Media Type
  ERR_SIP_UNSUPPORTED_MEDIA = 415,

  /// Unsupported URI Scheme
  ERR_SIP_UNSUPPORTED_SCHEME = 416,

  /// Bad Extension
  ERR_SIP_BAD_EXTENSION = 420,

  /// Extension Required
  ERR_SIP_EXTENSION_REQUIRED = 421,

  /// Session Interval Too Small
  ERR_SIP_SESSION_TOO_SMALL = 422,

  /// Interval Too Brief
  ERR_SIP_TOO_BRIEF = 423,

  /// Flow failed
  ERR_SIP_FLOW_FAILED = 430,

  // /// First Hop Lacks Outbound Support
  // ERR_SIP_439 = 439,

  /// Temporarily Unavailable
  ERR_SIP_TEMPORARILY_UNAVAILABLE = 480,

  /// Call/Transaction Does Not Exist
  ERR_SIP_NOT_EXIST = 481,

  /// Loop Detected
  ERR_SIP_LOOP_DETECTED = 482,

  /// Too Many Hops
  ERR_SIP_TOO_MANY_HOPS = 483,

  /// Address Incomplete
  ERR_SIP_ADDRESS_INCOMPLETE = 484,

  /// Ambiguous
  ERR_SIP_AMBIGUOUS = 485,

  /// Busy Here
  ERR_SIP_BUSY_HERE = 486,

  /// Request Terminated。请求终止（网络异常，网络中断场景下）
  ERR_SIP_REQUEST_TERMINATED = 487,

  /// Not Acceptable Here
  ERR_SIP_NOT_ACCEPTABLE_HERE = 488,

  // ///"Event Package Not Supported
  // ERR_SIP_489 = 489,

  /// Request Pending
  ERR_SIP_REQUEST_PENDING = 491,

  /// Undecipherable
  ERR_SIP_UNDECIPHERABLE = 493,

  /// Server Internal Error
  ERR_SIP_SERVER_ERROR = 500,

  /// Not Implemented
  ERR_SIP_NOT_IMPLEMENTED = 501,

  /// Bad Gateway
  ERR_SIP_BAD_GATEWAY = 502,

  /// Service Unavailable 服务不可用
  ERR_SIP_SERVICE_UNAVAILABLE = 503,

  /// Server Time-out服务超时
  ERR_SIP_SERVER_TIMEOUT = 504,

  /// Version Not Supported
  ERR_SIP_VERSION_NOT_SUPPORTED = 505,

  /// Message Too Large
  ERR_SIP_MESSAGE_TOO_LARGE = 513,

  /// Busy Everywhere
  ERR_SIP_BUSY_EVERYWHERE = 600,

  /// Decline
  ERR_SIP_DECLINE = 603,

  /// Does Not Exist Anywhere
  ERR_SIP_NOT_EXIST_ANYWHERE = 604,

  /// Not Acceptable
  ERR_SIP_NOT_ACCEPTABLE = 606,

  /////////////////////////////////////////////////////////////////////////////////
  //       音频相关错误码
  /////////////////////////////////////////////////////////////////////////////////

  /// 打开麦克风失败，例如在 Windows 或 Mac
  /// 设备，麦克风的配置程序（驱动程序）异常，禁用后重新启用设备，或者重启机器，或者更新配置程序
  ERR_MIC_START_FAIL = -1302,

  /// 麦克风设备未授权，通常在移动设备出现，可能是权限被用户拒绝了
  ERR_MIC_NOT_AUTHORIZED = -1317,

  /// 麦克风设置参数失败
  ERR_MIC_SET_PARAM_FAIL = -1318,

  /// 麦克风正在被占用中，例如移动设备正在通话时，打开麦克风会失败
  ERR_MIC_OCCUPY = -1319,

  /// 停止麦克风失败
  ERR_MIC_STOP_FAIL = -1320,

  /// 打开扬声器失败，例如在 Windows 或 Mac
  /// 设备，扬声器的配置程序（驱动程序）异常，禁用后重新启用设备，或者重启机器，或者更新配置程序
  ERR_SPEAKER_START_FAIL = -1321,

  /// 扬声器设置参数失败
  ERR_SPEAKER_SET_PARAM_FAIL = -1322,

  /// 停止扬声器失败
  ERR_SPEAKER_STOP_FAIL = -1323,

  /// 开启系统声音录制失败，例如音频驱动插件不可用
  ERR_AUDIO_PLUGIN_START_FAIL = -1330,

  /// 安装音频驱动插件未授权
  ERR_AUDIO_PLUGIN_INSTALL_NOT_AUTHORIZED = -1331,

  /// 安装音频驱动插件失败
  ERR_AUDIO_PLUGIN_INSTALL_FAILED = -1332,

  /// 安装虚拟声卡插件成功，但首次安装后功能暂时不可用，此为 Mac 系统限制，请在收到此错误码后提示用户重启当前 APP
  ERR_AUDIO_PLUGIN_INSTALLED_BUT_NEED_RESTART = -1333,

  /// 音频帧编码失败，例如传入自定义音频数据，SDK 无法处理
  ERR_AUDIO_ENCODE_FAIL = -1304,

  /// 不支持的音频采样率
  ERR_UNSUPPORTED_SAMPLERATE = -1306,

  /////////////////////////////////////////////////////////////////////////////////
  //       网络相关错误码
  /////////////////////////////////////////////////////////////////////////////////

  /// 进入房间失败，请查看 onError 中的 -3301 对应的 msg 提示确认失败原因
  ERR_RTC_ENTER_ROOM_FAILED = -3301,

  /// 请求 IP 和 sig 超时，请检查网络是否正常，或网络防火墙是否放行 UDP。
  /// 可尝试访问下列 IP：162.14.22.165:8000 162.14.6.105:8000 和域名：default-query.trtc.tencent-cloud.com:8000
  ERR_RTC_REQUEST_IP_TIMEOUT = -3307,

  /// 请求进房超时，请检查是否断网或者是否开启vpn，您也可以切换4G进行测试确认
  ERR_RTC_CONNECT_SERVER_TIMEOUT = -3308,

  /// 进房参数为空，请检查： enterRoom:appScene: 接口调用是否传入有效的 param
  ERR_RTC_ROOM_PARAM_NULL = -3316,

  /// 进房参数 sdkAppId 错误，请检查 TRTCParams.sdkAppId 是否为空
  ERR_RTC_INVALID_SDK_APPID = -3317,

  /// 进房参数 roomId 错误，请检查 TRTCParams.roomId 或 TRTCParams.strRoomId 是否为空，注意 roomId 和 strRoomId 不可混用
  ERR_RTC_INVALID_ROOM_ID = -3318,

  /// 进房参数 userId 不正确，请检查 TRTCParams.userId 是否为空
  ERR_RTC_INVALID_USER_ID = -3319,

  /// 进房参数 userSig 不正确，请检查 TRTCParams.userSig 是否为空
  ERR_RTC_INVALID_USER_SIG = -3320,

  /// 进房请求被拒绝，请检查是否连续调用 enterRoom 进入相同 Id 的房间
  ERR_RTC_ENTER_ROOM_REFUSED = -3340,

};

/////////////////////////////////////////////////////////////////////////////////
//
//                     警告码
//
//> 不需要特别关注，但您可以根据其中某些感兴趣的警告码，对当前用户进行相应的提示
//
/////////////////////////////////////////////////////////////////////////////////
/**
 * 警告类型
 */
enum TCCCCWarning {
  /////////////////////////////////////////////////////////////////////////////////
  //
  //       基础警告码
  //
  /////////////////////////////////////////////////////////////////////////////////

  /// 未开启通知栏设置
  WARNING_NOT_ENABLE_NOTIFICATIONS = -10001,

  /// 启动 Service 失败
  WARNING_RUN_SERVICE_FAILURE = -10002,

  /////////////////////////////////////////////////////////////////////////////////
  //       通用相关警告码
  /////////////////////////////////////////////////////////////////////////////////
  /// 上一通会话还没结束，新的会话进来了
  WARNING_LAST_CALL_NO_OVER = 90001,

  /////////////////////////////////////////////////////////////////////////////////
  //       音频相关警告码
  /////////////////////////////////////////////////////////////////////////////////

  /// 没有检测到可用的麦克风设备
  WARNING_MICROPHONE_DEVICE_EMPTY = 1201,

  /// 没有检测到可用的扬声器设备
  WARNING_SPEAKER_DEVICE_EMPTY = 1202,

  /// 用户未授权当前应用使用麦克风
  WARNING_MICROPHONE_NOT_AUTHORIZED = 1203,

  /// 音频采集设备不可用（例如被占用或者PC判定无效设备）
  WARNING_MICROPHONE_DEVICE_ABNORMAL = 1204,

  /// 音频播放设备不可用（例如被占用或者PC判定无效设备）
  WARNING_SPEAKER_DEVICE_ABNORMAL = 1205,

  /// 当前音频帧解码失败
  WARNING_AUDIO_FRAME_DECODE_FAIL = 2102,

  /// 音频录制写入文件失败
  WARNING_AUDIO_RECORDING_WRITE_FAIL = 7001,

  /// 录制音频时监测到啸叫
  WARNING_MICROPHONE_HOWLING_DETECTED = 7002,
};
}  // namespace tccc
#endif /* TCCCCode_h */
