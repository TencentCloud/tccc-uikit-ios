//
//  ViewController.swift
//  TCCCCallKitApp
//
//  Created by gavinwjwang on 2024/1/15.
//

import UIKit
import SnapKit
import TXAppBasic
import TCCCCallKit_Swift

class ViewController: UIViewController {
    var token: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initTcccNlogin()
    }
    
    lazy var logoContentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var tencentCloudImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tencent_cloud"))
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = UIColor(hex: "333333") ?? .black
        label.text = CallKitAppLocalize("AppMainTitle")
        label.numberOfLines = 0
        return label
    }()
    
    lazy var phoneNumberContentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = UIColor.white
        textField.font = UIFont(name: "PingFangSC-Regular", size: 20)
        textField.textColor = UIColor(hex: "333333")
        textField.attributedPlaceholder = NSAttributedString(string: CallKitAppLocalize("AppCallToPlaceholder"))
        textField.delegate = self
        textField.keyboardType = .phonePad
        return textField
    }()
    
    weak var currentTextField: UITextField?
    lazy var callActionBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle(CallKitAppLocalize("AppCallBtnText"), for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.setBackgroundImage(UIColor(hex: "006EFF")?.trans2Image(), for: .normal)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 20)
        btn.layer.shadowColor = UIColor(hex: "006EFF")?.cgColor ?? UIColor.blue.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 6)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    func initUI() {
        view.addSubview(logoContentView)
        logoContentView.addSubview(tencentCloudImage)
        logoContentView.addSubview(titleLabel)
        logoContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        tencentCloudImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(tencentCloudImage.snp.centerY)
            make.leading.equalTo(tencentCloudImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        
        view.addSubview(phoneNumberContentView)
        phoneNumberContentView.addSubview(phoneNumberTextField)
        view.addSubview(callActionBtn)
        phoneNumberContentView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        phoneNumberTextField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        callActionBtn.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(52)
        }
        
        callActionBtn.addTarget(self, action: #selector(callBtnClick), for: .touchUpInside)
    }
    
    func initTcccNlogin() {
        TCCCCallKit.createInstance().enableFloatWindow(enable: true)
        TCCCCallKit.createInstance().setUserStatusListener(userStatusListener: self)
        TCCCCallKit.createInstance().setCallStatusListener(callStatusListener: self)
        GenerateTestUserToken.genTestUserToken(USERID) { msg, code in
            self.token = msg
            if (!msg.isEmpty) {
                TCCCCallKit.createInstance().login(userId: USERID,sdkAppId: 1400255946,token: self.token, succ: {
                    TUITool.makeToast(CallKitAppLocalize("AppLoginSuccess"), duration: 4)
                },fail: { errorCode, errorMsg in
                    let loginErrorMsg = String(format: CallKitAppLocalize("AppLoginError"), errorMsg ?? "")
                    TUITool.makeToastError(Int(errorCode), msg:loginErrorMsg)
                })
            } else {
                let genTokenErrorMsg = String(format: CallKitAppLocalize("AppGetTokenError"), msg)
                TUITool.makeToastError(-9999, msg:genTokenErrorMsg)
            }
        }
    }
    
    @objc func callBtnClick() {
        if let current = currentTextField {
            current.resignFirstResponder()
        }
        guard let phone = phoneNumberTextField.text else {
            return
        }
        if phone.isEmpty {
            TUITool.makeToastError(-999, msg: CallKitAppLocalize("AppCallToPlaceholder"))
            return
        }
        TCCCCallKit.createInstance().call(to: phone,displayNumber: DisplayUtils().maskTelephoneNumber(phone),remark: nil)  {
            print("call success")
        } fail: { code, message in
            let errorMsg = String(format: "call error,message=", message ?? "")
            print(errorMsg)
        }
    }
    
    func exampleCode() {
        TUIGlobalization.setPreferredLanguage("en")
        // 中文（简体）
        TUIGlobalization.setPreferredLanguage("zh-Hans")
        
        // 开启悬浮窗功能
        TCCCCallKit.createInstance().enableFloatWindow(enable: true)
        
        // 监听通话的状态
        TCCCCallKit.createInstance().setCallStatusListener(callStatusListener: self)
        
        // 用户状态监听
        TCCCCallKit.createInstance().setUserStatusListener(userStatusListener: self)
        
        // 实时判断坐席是否登录
        TCCCCallKit.createInstance().isUserLogin {
            // 已登录
        } fail: { _, _ in
            // 未登录，或者被T了
        }

        // 自定义铃音
        TCCCCallKit.createInstance().setCallingBell(filePath: "")
        
        // 退出登录
        TCCCCallKit.createInstance().logout {
            // 退出登录成功
        } fail: { code, msg in
            // 退出登录失败
        }
        
    }
}


extension ViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let last = currentTextField {
            last.resignFirstResponder()
        }
        currentTextField = textField
        textField.becomeFirstResponder()
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        currentTextField = nil
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension ViewController: TUIUserStatusListener {
    func onKickedOffline() {
        //
    }
}

extension ViewController: TUICallStatusListener {
    func onNewSession(info: TCCCCallKit_Swift.TUISessionInfo) {
        //
    }
    
    func onEnded(reason: TCCCCallKit_Swift.TUIEndedReason, reasonMessage: String, sessionId: String) {
        //
    }
    
    func onAccepted(sessionId: String) {
        //
    }
    
    func onNetworkQuality(localQuality: TCCCCallKit_Swift.TUIQualityInfo, remoteQuality: TCCCCallKit_Swift.TUIQualityInfo) {
        //
    }
}
