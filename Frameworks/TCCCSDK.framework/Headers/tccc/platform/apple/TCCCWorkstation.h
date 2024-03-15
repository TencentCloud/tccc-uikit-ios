#import "TCCCDef.h"
#import "TCCCDelegate.h"
#import "TCCCDeviceManager.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCCCWorkstation : NSObject

/// 成功通用回调
typedef void (^TXSucc)(void);
typedef void (^TXLoginSucc)(TXLoginInfo *info);

/// 失败通用回调
typedef void (^TXFail)(int code, NSString *desc);

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
+ (instancetype)sharedInstance;

/**
 * 1.2 销毁 TCCCWorkstation 实例（单例模式）
 */
+ (void)destroySharedIntance;

/**
 * 1.3 设置 TCCC 事件回调
 *
 * 您可以通过 {@link ITCCCCallback} 获得来自 SDK 的各类事件通知（比如：错误码，警告码，音视频状态参数等）。
 *
 * @param callback 回调
 */
- (void)addTcccListener:(id<TCCCDelegate>)listener;

/**
 * 1.4 移除 TCCC 事件回调
 *
 * @param callback 回调
 */
- (void)removeTCCCListener:(id<TCCCDelegate>)listener;

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
- (void)login:(TXLoginParams *)param succ:(TXLoginSucc)succ fail:(TXFail)fail;

/*
 * 检查登录状态。
 *
 * @param callback 是否已登录回调
 */
- (void)checkLogin:(TXSucc)succ fail:(TXFail)fail;

/**
 * 2.2 退出 TCCC 联络中心
 *
 * @param callback 退出成功与否回调
 */
- (void)logout:(TXSucc)succ fail:(TXFail)fail;

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
- (void)call:(TXStartCallParams *)param succ:(TXSucc)succ fail:(TXFail)fail;

/**
 * 3.2 结束会话
 *
 */
- (void)terminate;

/**
 * 3.3 接听
 *
 * @param answerCallback 接听成功与否回调
 */
- (void)answer:(TXSucc)succ fail:(TXFail)fail;

/**
 * 3.8 发送 DTMF（双音多频信号）
 *
 * @param digits DTMF参数是一个字符串，可以包含字符 0-9、*、#。
 *
 * @param callback 发送 DTMF成功与否回调，调用一次就会播放一次按键声音
 * @note
 *  该方法仅仅在通话建立后才生效。需要注意的是前后按键需要保证一定的间隔，否则会出现可能出现对端无法感知的问题。
 */
- (void)sendDTMF:(char)digit succ:(TXSucc)succ fail:(TXFail)fail;

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
- (void)mute;

/**
 * 4.2 取消静音
 */
- (void)unmute;

/**
 * 4.7 启用音量大小提示。
 *
 * 开启此功能后，SDK 会在 {@link ITCCCCallback} 中的 {@link onVoiceVolume} 回调中反馈远端音频的音量大小。
 * @note 如需打开此功能，请在 接听或者发起呼叫 之前调用才可以生效。
 * @param interval 设置 onVoiceVolume 回调的触发间隔，单位为ms，最小间隔为100ms，如果小于等于 0
 * @param enable_vad  true：打开本地人声检测 ；false：关闭本地人声检测。默认是FALSE
 则会关闭回调，建议设置为300ms；
 */
- (void)enableAudioVolumeEvaluation:(UInt32)interval enable_vad:(Boolean)enable_vad;

/**
 * 4.8 开始播放音乐
 *
 * @param path 音乐路径。
 * @param loopCount 音乐循环播放的次数。取值范围为0 - 任意正整数，默认值：1。1
 * 表示播放音乐一次,以此类推。0表示无限循环，手动停止
 */
- (void)startPlayMusic:(NSString *)path loopCount:(NSInteger)loopCount;

/**
 * 4.9 停止播放音乐
 */
- (void)stopPlayMusic;

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
- (TCCCDeviceManager *)getDeviceManager;

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
+ (NSString *)getSDKVersion;

/**
 * 12.2 调用实验性接口
 *
 * @param commandType 类型
 * @param jsonStr 参数
 */
- (void)callExperimentalAPI:(NSString *)commandType jsonStr:(NSString *)jsonStr;

/**
 * 12.3 设置 Log 输出级别，该方法必须在login前调用才生效
 *
 * @param level 参见 {@link TCCCLogLevel}，默认值：{@link TCCCLogLevelInfo}
 */
- (void)setLogLevel:(TXLogLevel)level;

/**
 * 12.4 启用/禁用控制台日志打印
 *
 * @param enabled 指定是否启用，默认:禁止状态
 */
- (void)setConsoleEnabled:(BOOL)enabled;

/**
 * 12.5 设置日志文件夹,登录前调用才有效
 *
 * @param logPath 日志文件夹路径
 */
- (void)setLogDirectory:(NSString *)logPath;

/**
 * 12.6 启用/禁用timer功能。
 *
 * timer功能启用后。如果在预定的时间内没有收到响应，就会触发超时事件，这可能会导致终止会话操作。
 *
 * 注意该功能仅支持在 login 前调用才有效
 *
 * @param isEnable 是否开启timer，默认：开启状态。
 */
- (void)setEnableTimer:(BOOL)isEnable;

// 只能在内部使用。
- (void)genTestTokenByUser:(NSString *)secretId secretKey:(NSString *)secretKey userId:(NSString *)userId sdkAppId:(UInt32)sdkAppId succ:(TXSucc)succ fail:(TXFail)fail;

/// @}

@end

NS_ASSUME_NONNULL_END
