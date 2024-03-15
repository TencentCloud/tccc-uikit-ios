#pragma once
#include <stdint.h>
#include "TCCCTypeDef.h"

#ifdef _WIN32
#  if !defined(__cplusplus)
#    define TCCCSDK_API_C extern __declspec(dllexport)
#  else
#    define TCCCSDK_API_C extern "C" __declspec(dllexport)
#  endif
#  define TCCCSDK_CALL
#else
#  define TCCCSDK_API_C extern "C"
#  define TCCCSDK_CALL __cdecl
#endif

extern "C" {
// 通用回调
typedef void (*TCCCSDK_CALL TCCC_OnErrorHandler)(int err_code, const char* err_msg, void* extra_info);
typedef void (*TCCCSDK_CALL TCCC_OnWarningHandler)(int warning_code, const char* warning_msg, void* extra_info);
typedef void (*TCCCSDK_CALL TCCC_OnNewSessionHandler)(const char* sessionId, int sessionDirection, const char* toUserId,
                                                      const char* fromUserId, const char* customHeaderJson);
typedef void (*TCCCSDK_CALL TCCC_OnEndedHandler)(int reason, const char* reasonMessage, const char* sessionId);
typedef void (*TCCCSDK_CALL TCCC_OnAcceptedHandler)(const char* sessionId);
typedef void (*TCCCSDK_CALL TCCC_OnAudioVolumeHandler)(const char* userId, uint32_t volume);
// remoteUserId 为null的时候，remoteQuality是没有意义的
typedef void (*TCCCSDK_CALL TCCC_OnNetworkQualityHandler)(const char* localUserId, int localQuality,
                                                          const char* remoteUserId, int remoteQuality,
                                                          uint32_t remoteQualityCount);
typedef void (*TCCCSDK_CALL TCCC_OnStatisticsHandler)(const tccc::TCCCStatistics& statistics);

typedef void (*TCCCSDK_CALL TCCC_OnConnectionLost)(int serverType);
typedef void (*TCCCSDK_CALL TCCC_OnTryToReconnect)(int serverType);
typedef void (*TCCCSDK_CALL TCCC_OnConnectionRecovery)(int serverType);

// 登录&呼叫相关的回调
typedef void (*TCCCSDK_CALL TCCC_OnLoginHandler)(int err_code, const char* err_msg, const char* userId,
                                                 const char* userAor, const char* otherInfo);
typedef void (*TCCCSDK_CALL TCCC_OnLogoutHandler)(int err_code, const char* err_msg);
typedef void (*TCCCSDK_CALL TCCC_OnStartCallHandler)(int err_code, const char* err_msg);
typedef void (*TCCCSDK_CALL TCCC_OnAnswerHandler)(int err_code, const char* err_msg);
typedef void (*TCCCSDK_CALL TCCC_OnCheckLoginHandler)(int err_code, const char* err_msg);
typedef void (*TCCCSDK_CALL TCCC_OnSendDTMFHandler)(int err_code, const char* err_msg);
}

// 参数只有Android需要，其他可以直接用null
TCCCSDK_API_C void* TCCC_GetTCCCInstance(void* context);
TCCCSDK_API_C void TCCC_DestroyTCCCInstance();

TCCCSDK_API_C void TCCC_AddCallback(TCCC_OnErrorHandler onError, TCCC_OnWarningHandler onWarning,
                                    TCCC_OnNewSessionHandler onNewSession, TCCC_OnEndedHandler onEnded,
                                    TCCC_OnAcceptedHandler onAccepted, TCCC_OnAudioVolumeHandler onAudioVolume,
                                    TCCC_OnNetworkQualityHandler onNetworkQuality,
                                    TCCC_OnStatisticsHandler onStatistics, TCCC_OnConnectionLost onConnectionLost,
                                    TCCC_OnTryToReconnect onTryToReconnect,
                                    TCCC_OnConnectionRecovery onConnectionRecovery);
TCCCSDK_API_C void TCCC_RemoveCallback();

TCCCSDK_API_C void TCCC_Login(const char* userId, const char* password, uint32_t sdkAppId, int loginType,
                              TCCC_OnLoginHandler callback);
TCCCSDK_API_C void TCCC_Logout(TCCC_OnLogoutHandler callback);

TCCCSDK_API_C void TCCC_CheckLogin(TCCC_OnCheckLoginHandler callback);
TCCCSDK_API_C void TCCC_ResetSip(bool isNeedCallReLogin);

TCCCSDK_API_C void TCCC_Call(const tccc::TCCCStartCallParams& param, TCCC_OnStartCallHandler callback);
TCCCSDK_API_C void TCCC_Terminate();
TCCCSDK_API_C void TCCC_Answer(TCCC_OnAnswerHandler callback);
TCCCSDK_API_C void TCCC_SendDTMF(const char digit, TCCC_OnSendDTMFHandler callback);
TCCCSDK_API_C void TCCC_Mute();
TCCCSDK_API_C void TCCC_Unmute();
TCCCSDK_API_C const char* TCCC_GetSDKVersion();
TCCCSDK_API_C void TCCC_CallExperimentalAPI(const char* commandType, const char* jsonStr);
TCCCSDK_API_C void TCCC_StartPlayMusic(const char* path, int loopCount);
TCCCSDK_API_C void TCCC_StopPlayMusic();
TCCCSDK_API_C void TCCC_SetLogLevel(int level);
TCCCSDK_API_C void TCCC_SetConsoleEnabled(bool enabled);
TCCCSDK_API_C void TCCC_EnableAudioVolumeEvaluation(uint32_t interval, bool enable_vad);
TCCCSDK_API_C void TCCC_SetLogDirectory(const char* path);
// 设备
TCCCSDK_API_C void TCCC_GetDeviceManager();
TCCCSDK_API_C void TDEVICE_SetAudioCaptureVolume(int volume);
TCCCSDK_API_C int TDEVICE_GetAudioCaptureVolume();
TCCCSDK_API_C void TDEVICE_SetAudioPlayoutVolume(int volume);
TCCCSDK_API_C int TDEVICE_GetAudioPlayoutVolume();

TCCCSDK_API_C void TDEVICE_SetAudioRoute(int route);

// for test ,callback的message返回token
TCCCSDK_API_C void TCCC_GenTestTokenByUser(const char* secretId, const char* secretKey, const char* userId,
                                           uint32_t sdkAppId, TCCC_OnLogoutHandler callback);
// 仅仅移动端
#if __ANDROID__ || (__APPLE__ && TARGET_OS_IOS)
#endif
// 仅仅pc端
#if (__APPLE__ && TARGET_OS_MAC && !TARGET_OS_IPHONE) || _WIN32
#endif
