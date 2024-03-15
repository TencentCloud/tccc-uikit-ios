//
//  SingleCallView.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import SnapKit

protocol SingleCallViewDelegate: AnyObject {
    func handleStatusBarHidden(isHidden: Bool)
}

class SingleCallView: UIView {
    
    weak var delegate: SingleCallViewDelegate?
    
    let viewModel = SingleCallViewModel()
    let selfCallStatusObserver = Observer()
    let isShowFullScreenObserver = Observer()
    private var isViewReady: Bool = false
    
    let userInfoView = {
        return CallUserInfoView(frame: CGRect.zero)
    }()
    
    let callStatusTipView = {
        return CallStatusTipView(frame: CGRect.zero)
    }()
    
    let backgroundView = {
        return BackgroundView(frame: CGRect.zero)
    }()
    
    let audioFunctionView = {
        return AudioCallerWaitingAndAcceptedView(frame: CGRect.zero)
    }()
    
    let inviteeWaitFunctionView = {
        return AudioCalleeWaitingView(frame: CGRect.zero)
    }()
    
    
    let timerView = {
        return TimerView(frame: CGRect.zero)
    }()
    
    let floatingWindowBtn = {
        return FloatingWindowButton(frame: CGRect.zero)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let screenSize = UIScreen.main.bounds.size
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        // F2F2F2  // 白色
        // 303132  // 灰色
        backgroundColor = UIColor.t_colorWithHexString(color: "#F2F2F2")
        
        createView()
        registerObserveState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel.selfCallStatus.removeObserver(selfCallStatusObserver)
        viewModel.isShowFullScreen.removeObserver(isShowFullScreenObserver)
        
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    // MARK: UI Specification Processing
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if isViewReady { return }
        constructViewHierarchy()
        activateConstraints()
        isViewReady = true
    }
    
    func constructViewHierarchy() {
        addSubview(backgroundView)
        addSubview(userInfoView)
        addSubview(callStatusTipView)
        addSubview(audioFunctionView)
        addSubview(inviteeWaitFunctionView)
        addSubview(floatingWindowBtn)
        addSubview(timerView)
    }
    
    func activateConstraints() {
        let baseControlHeight = 60.scaleWidth() + 5.scaleHeight() + 20
        let functionViewBottomOffset = -Bottom_SafeHeight - 10.scaleHeight()
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        floatingWindowBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusBar_Height + 5)
            make.leading.equalToSuperview().offset(12.scaleWidth())
            make.size.equalTo(kFloatWindowButtonSize)
        }
        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(floatingWindowBtn.snp.bottom).offset(30)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
        }
        callStatusTipView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(70)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(20)
        }
        timerView.snp.makeConstraints { make in
            make.bottom.equalTo(audioFunctionView.snp.top).offset(-50)
            make.centerX.equalTo(self)
            make.width.equalTo(100)
        }
        audioFunctionView.snp.makeConstraints({ make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(functionViewBottomOffset)
            make.height.equalTo(baseControlHeight)
            make.width.equalTo(self.snp.width)
        })
        inviteeWaitFunctionView.snp.makeConstraints({ make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(functionViewBottomOffset)
            make.height.equalTo(baseControlHeight)
            make.width.equalTo(self.snp.width)
        })
    }
    
    // MARK: View Create & Manage
    func createView() {
        cleanView()
        handleFloatingWindowBtn()
        
        if viewModel.selfCallStatus.value == .waiting {
            createWaitingView()
        } else if viewModel.selfCallStatus.value == .accept {
            createAcceptView()
        }
    }
    
    func handleFloatingWindowBtn() {
        if viewModel.enableFloatWindow {
            floatingWindowBtn.isHidden = viewModel.isShowFullScreen.value
        } else {
            floatingWindowBtn.isHidden = true
        }
    }
    
    func createWaitingView() {
        createAudioWaitingView()
    }
    
    func createAudioWaitingView() {
        userInfoView.isHidden = false
        callStatusTipView.isHidden = false
        if viewModel.selfCallRole.value == .call {
            audioFunctionView.isHidden = false
        } else {
            inviteeWaitFunctionView.isHidden = false
        }
    }
    
    
    func createAcceptView() {
        createAudioAcceptView()
        createCallStatusTipView()
    }
    
    func createCallStatusTipView() {
        if viewModel.selfCallRole.value == .call {
            callStatusTipView.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.callStatusTipView.isHidden = true
            }
        }
    }
    
    func createAudioAcceptView() {
        userInfoView.isHidden = false
        timerView.isHidden = false
        audioFunctionView.isHidden = false
    }
    
    
    func cleanView() {
        timerView.isHidden = true
        callStatusTipView.isHidden = true
        userInfoView.isHidden = true
        audioFunctionView.isHidden = true
        inviteeWaitFunctionView.isHidden = true
    }
    
    // MARK: Register TUICallState Observer && Update UI
    func registerObserveState() {
        callStatusChanged()
        isShowFullScreenChanged()
    }
    
    func callStatusChanged() {
        viewModel.selfCallStatus.addObserver(selfCallStatusObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.createView()
        })
    }
    
    
    func isShowFullScreenChanged() {
        viewModel.isShowFullScreen.addObserver(isShowFullScreenObserver) { [weak self] newValue, _  in
            guard let self = self else { return }
            self.timerView.isHidden = newValue
            self.delegate?.handleStatusBarHidden(isHidden: newValue)
            
            if self.viewModel.enableFloatWindow {
                self.floatingWindowBtn.isHidden = newValue
            }
        }
    }
}
