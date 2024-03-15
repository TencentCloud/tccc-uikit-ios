

/**
 * Module:   TCCC 坐席信息管理类
 * Function: 设置坐席状态、上线、下线等接口
 */
/// @defgroup IAgentInfoManager_cplusplus TCCC 坐席信息管理类
/// TCCC 坐席信息管理类
/// @{

#ifndef IAgentInfoManager_h
#  define IAgentInfoManager_h

#  include "ITCCCCallback.h"
#  include "TCCCTypeDef.h"

namespace tccc {

class IAgentInfoManager {
 public:
  IAgentInfoManager(){};
  virtual ~IAgentInfoManager(){};
  /**
   * 1.1 上线
   *
   * @param callback 成功与否回调
   */
  virtual void online(ITXCallback* callback) = 0;
  /**
   * 1.2 下线
   *
   * @param callback 成功与否回调
   */
  virtual void offline(ITXCallback* callback) = 0;

  /**
   * 1.3 更新坐席状态
   *
   * @param callback 成功与否回调
   */
  virtual void updateStatus(AgentStatus status, ITXCallback* callback) = 0;
};

}  // namespace tccc

#endif /* IAgentInfoManager_h */

/// @}
