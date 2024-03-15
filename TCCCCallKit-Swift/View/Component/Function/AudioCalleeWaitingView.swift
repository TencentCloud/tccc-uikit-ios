//
//  AudioCalleeWaitingView.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation

class AudioCalleeWaitingView: UIView {
    
    let viewModel = AudioCalleeWaitingViewModel()
    
    lazy var acceptBtn: BaseControlButton = {
        weak var weakSelf = self
        let acceptBtn = BaseControlButton.create(frame: CGRect.zero,
                                                 title: TUICallKitLocalize(key: "TUICallKit.answer") ?? "",
                                                 imageSize: kBtnSmallSize) { sender in
            weakSelf?.acceptTouchEvent(sender: sender)
        }
        if let image = TUICallKitCommon.getBundleImage(name: "icon_dialing") {
            acceptBtn.updateImage(image: image)
        }
        acceptBtn.updateTitleColor(titleColor: UIColor.t_colorWithHexString(color: "#000000"))
        return acceptBtn
    }()
    
    lazy var rejectBtn: BaseControlButton = {
        weak var weakSelf = self
        let rejectBtn = BaseControlButton.create(frame: CGRect.zero,
                                                 title: TUICallKitLocalize(key: "TUICallKit.decline") ?? "",
                                                 imageSize: kBtnSmallSize) { sender in
            weakSelf?.rejectTouchEvent(sender: sender)
        }
        if let image = TUICallKitCommon.getBundleImage(name: "icon_hangup") {
            rejectBtn.updateImage(image: image)
        }
        rejectBtn.updateTitleColor(titleColor: UIColor.t_colorWithHexString(color: "#000000"))
        return rejectBtn
    }()
    
    // MARK: UI Specification Processing
    private var isViewReady: Bool = false
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if isViewReady { return }
        constructViewHierarchy()
        activateConstraints()
        isViewReady = true
    }
    
    func constructViewHierarchy() {
        addSubview(rejectBtn)
        addSubview(acceptBtn)
    }
    
    func activateConstraints() {
        rejectBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self).offset(TUICoreDefineConvert.getIsRTL() ? 80.scaleWidth() : -80.scaleWidth())
            make.bottom.equalTo(self)
            make.size.equalTo(kControlBtnSize)
        }
        acceptBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self).offset(TUICoreDefineConvert.getIsRTL() ? -80.scaleWidth() : 80.scaleWidth())
            make.bottom.equalTo(self)
            make.size.equalTo(kControlBtnSize)
        }
    }
    
    // MARK: Event Action
    func rejectTouchEvent(sender: UIButton) {
        viewModel.reject()
    }
    
    func acceptTouchEvent(sender: UIButton) {
        viewModel.accept()
    }
    
}
