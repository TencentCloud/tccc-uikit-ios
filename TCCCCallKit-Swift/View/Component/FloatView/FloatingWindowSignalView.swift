//
//  FloatingWindow.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation
import UIKit

class FloatingWindowSignalView: UIView {
    
    let viewModel = FloatingWindowViewModel()
    weak var delegate: FloatingWindowViewDelegate?
    
    let selfCallStatusObserver = Observer()
    let remoteUserObserver = Observer()
    let callTimeObserver = Observer()
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = TUICoreDefineConvert.getTUICallKitDynamicColor(colorKey: "callkit_float_window_bg_color",
                                                                                       defaultHex:  "#FFFFFF")
        containerView.layer.cornerRadius = 12.scaleWidth()
        containerView.layer.masksToBounds = true
        containerView.isUserInteractionEnabled = false
        return containerView
    }()
    
    let audioContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = TUICoreDefineConvert.getTUICallKitDynamicColor(colorKey: "callkit_float_window_bg_color",
                                                                                       defaultHex:  "#FFFFFF")
        return containerView
    }()
    
    let shadowView: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = TUICoreDefineConvert.getTUICallKitDynamicColor(colorKey: "callkit_float_window_bg_color",
                                                                                    defaultHex:  "#FFFFFF")
        shadowView.layer.shadowColor = UIColor.t_colorWithHexString(color: "353941").cgColor
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.cornerRadius = 12.scaleWidth()
        shadowView.layer.shadowRadius = 4.scaleWidth()
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        return shadowView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        if let image = TUICallKitCommon.getBundleImage(name: "icon_float_dialing") {
            imageView.image = image
        }
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    let audioDescribeLabel: UILabel = {
        let describeLabel = UILabel()
        describeLabel.font = UIFont.systemFont(ofSize: 12.0)
        describeLabel.textColor = UIColor.t_colorWithHexString(color: "#000000")
        describeLabel.textAlignment = .center
        describeLabel.isUserInteractionEnabled = false
        describeLabel.text = TUICallKitLocalize(key: "TUICallKit.FloatingWindow.waitAccept") ?? ""
        return describeLabel
    }()
    
    
    lazy var timerLabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.font = UIFont.systemFont(ofSize: 12.0)
        timerLabel.textColor = UIColor.t_colorWithHexString(color: "#000000")
        timerLabel.textAlignment = .center
        timerLabel.isUserInteractionEnabled = false
        timerLabel.text = viewModel.getCallTimeString()
        return timerLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerObserverState()
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel.selfCallStatus.removeObserver(selfCallStatusObserver)
        viewModel.selfCallStatus.removeObserver(callTimeObserver)
    }
    
    func constructViewHierarchy() {
        addSubview(shadowView)
        addSubview(containerView)
        containerView.addSubview(audioContainerView)
        audioContainerView.addSubview(imageView)
        audioContainerView.addSubview(audioDescribeLabel)
        audioContainerView.addSubview(timerLabel)
    }
    
    func activateConstraints() {
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.top.equalTo(8.scaleWidth())
        }
        audioContainerView.snp.makeConstraints { make in
            make.top.centerX.equalTo(containerView)
            make.width.height.equalTo(72.scaleWidth())
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(audioContainerView).offset(8.scaleWidth())
            make.centerX.equalTo(audioContainerView)
            make.width.height.equalTo(36.scaleWidth())
        }
        audioDescribeLabel.snp.makeConstraints { make in
            make.centerX.width.equalTo(audioContainerView)
            make.top.equalTo(imageView.snp.bottom).offset(4.scaleWidth())
            make.height.equalTo(20.scaleWidth())
        }
        timerLabel.snp.makeConstraints { make in
            make.centerX.width.equalTo(audioContainerView)
            make.top.equalTo(imageView.snp.bottom).offset(4.scaleWidth())
            make.height.equalTo(20.scaleWidth())
        }
    }
    
    func bindInteraction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(tapGesture: )))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(panGesture: )))
        self.addGestureRecognizer(tap)
        pan.require(toFail: tap)
        self.addGestureRecognizer(pan)
    }
    
    func clearSubview() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    // MARK: Action Event
    @objc func tapGestureAction(tapGesture: UITapGestureRecognizer) {
        if self.delegate != nil && ((self.delegate?.responds(to: Selector(("tapGestureAction")))) != nil) {
            self.delegate?.tapGestureAction(tapGesture: tapGesture)
        }
    }
    
    @objc func panGestureAction(panGesture: UIPanGestureRecognizer) {
        if self.delegate != nil && ((self.delegate?.responds(to: Selector(("panGestureAction")))) != nil) {
            self.delegate?.panGestureAction(panGesture: panGesture)
        }
    }
    
    // MARK: Register TUICallState Observer && Update UI
    func registerObserverState() {
        registerCallStatusObserver()
        registerCallTimeObserver()
    }
    
    func registerCallStatusObserver() {
        viewModel.selfCallStatus.addObserver(selfCallStatusObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.updateUI()
        })
    }
    
    func registerCallTimeObserver() {
        viewModel.callTime.addObserver(callTimeObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            DispatchCallKitMainAsyncSafe {
                self.timerLabel.text = self.viewModel.getCallTimeString()
            }
        })
    }
        
    // MARK: Update UI
    func updateUI() {
        cleanView()
        updateSingleAudioUI()
    }
    
    func updateSingleAudioUI() {
        containerView.backgroundColor = UIColor.t_colorWithHexString(color: "FFFFFF")
        
        if viewModel.selfCallStatus.value == .waiting {
            setSingleAudioWaitingUI()
        } else if viewModel.selfCallStatus.value == .accept {
            setSingleAudioAcceptUI()
        }
    }
    

    
    func setSingleAudioWaitingUI() {
        audioContainerView.isHidden = false
        imageView.isHidden = false
        audioDescribeLabel.isHidden = false
    }
    
    func setSingleAudioAcceptUI() {
        audioContainerView.isHidden = false
        imageView.isHidden = false
        timerLabel.isHidden = false
    }
    
    
    func cleanView() {
        audioContainerView.isHidden = true
        imageView.isHidden = true
        audioDescribeLabel.isHidden = true
        timerLabel.isHidden = true
    }
    
}
