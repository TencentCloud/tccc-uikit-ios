本文将介绍如何用最短的时间完成 TCCCCallKit 组件的接入，您将在十分钟内完成如下几个关键步骤，并最终得到一个包含完备 UI 界面的电话外呼、接听功能。

## 环境准备
- Xcode 9.0+。 
- iOS 9.0 以上的 iPhone 或者 iPad 真机。
- 项目已配置有效的开发者签名。

## 前提条件
- 您已 [注册腾讯云](https://cloud.tencent.com/document/product/378/17985) 账号，并完成 [实名认证](https://cloud.tencent.com/document/product/378/3629) 。
- 您已 [开通云联络中心](https://cloud.tencent.com/document/product/679/48028#.E6.AD.A5.E9.AA.A41.EF.BC.9A.E5.87.86.E5.A4.87.E5.B7.A5.E4.BD.9C) 服务，并创建了 [云联络中心实例](https://cloud.tencent.com/document/product/679/48028#.E6.AD.A5.E9.AA.A42.EF.BC.9A.E5.88.9B.E5.BB.BA.E4.BA.91.E5.91.BC.E5.8F.AB.E4.B8.AD.E5.BF.83.E5.AE.9E.E4.BE.8B) 。
- 您已购买了号码，[查看购买指南](https://cloud.tencent.com/document/product/679/73526)。并且完成了对应的[IVR配置](https://cloud.tencent.com/document/product/679/73549)

[](id:step1)
## 步骤一：CocoaPods 集成
1. 安装 CocoaPods。安装 CocoaPods。

   在终端窗口中输入如下命令（需要提前在 Mac 中安装 Ruby 环境）：

```
sudo gem install cocoapods
```

2. 创建 Podfile 文件。

   进入项目所在路径输入以下命令行，之后项目路径下会出现一个 Podfile 文件。

```
pod init
```

[](id:step2)
## 步骤二：下载并导入组件

在 [Github](https://github.com/TencentCloud/tccc-uikit-ios) 中克隆/下载代码，然后拷贝该库目录下的 **TCCCCallKit-Swift** 、** TCCCCallKit-Swift.podspec ** **Frameworks** 子目录到您当前工程中的 app 同一级目录中，如下图：

![](https://tccc.qcloud.com/assets/doc/Agent/ios_image/iosSDK_pod.png)


[](id:step3)
## 步骤三：完成工程配置

1. 在您的 **Podfile** 文件中添加以下依赖。路径修改为 **TCCCCallKit-Swift** 文件夹相对您工程Podfile文件的路径。

```
pod 'TCCCCallKit-Swift', :path => "../", :subspecs => ["TCCC"]
```

2. 授权麦克风权限

   使用音频功能，需要授权麦克风的使用权限。在 App 的 Info.plist 中添加以下两项，分别对应麦克风弹出授权对话框时的提示信息。

```xml
<key>NSMicrophoneUsageDescription</key>
<string>App需要访问您的麦克风权限，开启后通话才会有声音</string>
```

![](https://tccc.qcloud.com/assets/doc/Agent/ios_image/ios_privacy.png)

3. 如需 App 进入后台仍然运行相关功能，可在 XCode 中选中当前工程项目，并在 Capabilities 下将设置项  Background Modes 设定为 ON，并勾选 Audio，AirPlay and Picture in Picture ，如下图所示：

![](https://tccc.qcloud.com/assets/doc/Agent/ios_image/ios_aduio.png)

4. 执行以下命令，安装组件。

```
pod install
```

[](id:step4)
## 步骤四：登录 TCCC
   
在您的项目中添加如下代码，它的作用是通过调用 TCCCCallKit 中的相关接口完成 TCCCCallKit 组件的登录。这个步骤异常关键，因为只有在登录成功后才能正常使用 TCCCCallKit 的各项功能，故请您耐心检查相关参数是否配置正确：


``` Swift
import TCCCCallKit_Swift
// 登录
TCCCCallKit.createInstance().login(
   userId: "denny@qq.com",    // 请替换为您的 UserID，通常是一个邮箱地址
   sdkAppId: 1400000001,      // 请替换为步骤一取到的 SDKAppID
   token: "xxxxxxxxxxx",      // 您可以在你的后台计算一个 token 并填在这个位置
   succ: {
      // login success
   },fail: { errorCode, errorMsg in
      // login failed
   })

// 退出登录
TCCCCallKit.createInstance().logout {
   // 退出登录成功
} fail: { code, msg in
   // 退出登录失败
}
```

## 步骤五：拨打电话

通过调用 TCCCCallKit 的 call 函数并指定需要拨打的电话号码，就可以发起外呼。

``` Swift
import TCCCCallKit_Swift
// 发起外呼
TCCCCallKit.createInstance().call(
   to: "13430689561",            // 需要呼叫的电话号码,
   displayNumber: "134*****561", // 在通话条中会替代号码显示,填写为null或者为空字符串将显示电话号码
   remark: nil,                  // 号码备注，在通话记录中将会保存显示该备注
   succ: {
      // login success
   },
   fail: { errorCode, errorMsg in
      // login failed
   })
```

## 步骤六：接听来电

收到来电请求后，TCCCCallKit 组件会自动唤起来电提醒的接听界面，不过因为 iOS 系统权限的原因，分为如下几种情况：

- 您的 App 在前台时，当收到邀请时会自动弹出呼叫界面并播放来电铃音。
- 您的 App 在后台，TCCCCallKit 会播放来电铃音，提示用户接听或挂断。
- 您的 App 进程已经被销毁或者冻结了，可以通过开通手机接听来处理接听来电。

    ![](https://tccc.qcloud.com/assets/doc/Agent/ios_image/callInByPhone.png)


## 步骤七：更多特性

### 一、悬浮窗功能

如果您的业务需要开启悬浮窗功能，您可以在 TCCCCallKit 组件初始化时调用以下接口开启该功能：

``` Swift
import TCCCCallKit_Swift
TCCCCallKit.createInstance().enableFloatWindow(enable: true)
```

### 二、通话状态监听

如果您的业务需要 **监听通话的状态**，例如通话开始、结束，以及通话过程中的网络质量等等（详见[CallStatusListener]()），可以监听以下事件：

``` Swift
import TCCCCallKit_Swift
// 监听通话的状态
TCCCCallKit.createInstance().setCallStatusListener(callStatusListener: self)
```

### 三、其他功能说明

- 如果您的业务需要 **用户状态监听**，可以监听以下事件：

``` Swift
import TCCCCallKit_Swift
// 用户状态监听
TCCCCallKit.createInstance().setUserStatusListener(userStatusListener: self)
```

- 实时判断坐席是否登录

``` Swift
import TCCCCallKit_Swift
// 实时判断坐席是否登录
TCCCCallKit.createInstance().isUserLogin {
   // 已登录
} fail: { _, _ in
   // 未登录，或者被T了
}
```

- 默认自带 简体中文、英语 语言包，作为界面展示语言。组件内部语言会跟随系统语言,无需额外步骤。如需要实时动态修改语言可参考

``` Swift
import TCCCCallKit_Swift
// 英文
TUIGlobalization.setPreferredLanguage("en")
// 中文（简体）
TUIGlobalization.setPreferredLanguage("zh-Hans")
```

### 四、自定义铃音

如果您需要自定义来电铃音，可以通过如下接口进行设置：

``` Swift
import TCCCCallKit_Swift
// 自定义铃音
TCCCCallKit.createInstance().setCallingBell(filePath: "xxx")
```


## 交流与反馈
   
   如果您在使用过程中，有什么建议或者意见，可以在这里反馈。点此进入 [TCCC 社群](https://zhiliao.qq.com/)，享有专业工程师的支持，解决您的难题。
