//
//  CallUserInfoView.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation

class CallUserInfoView: UIView {
    
    let viewModel = UserInfoViewModel()
    let remoteUserObserver = Observer()
    let networkQualityObserver = Observer()
    
    let userNameLabel: UILabel = {
        let userNameLabel = UILabel(frame: CGRect.zero)
        userNameLabel.textColor = UIColor.t_colorWithHexString(color: "#000000")
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        userNameLabel.backgroundColor = UIColor.clear
        userNameLabel.textAlignment = .center
        return userNameLabel
    }()
    
    let networkTipsStatusLabel: UILabel = {
        let networkTipsStatusLabel = UILabel(frame: CGRect.zero)
        networkTipsStatusLabel.textColor = UIColor.t_colorWithHexString(color: "#000000")
        networkTipsStatusLabel.font = UIFont.systemFont(ofSize: 14.0)
        networkTipsStatusLabel.backgroundColor = UIColor.clear
        networkTipsStatusLabel.textAlignment = .center
        return networkTipsStatusLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUserName()
        setNetworkQualityTips()
        registerObserveState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel.remoteUser.removeObserver(remoteUserObserver)
        viewModel.networkQuality.removeObserver(networkQualityObserver)
    }
    
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
        addSubview(userNameLabel)
        addSubview(networkTipsStatusLabel)
    }
    
    func activateConstraints() {
        self.userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(30)
        }
        self.networkTipsStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(20)
        }
    }
    
    // MARK: Register TUICallState Observer && Update UI
    func registerObserveState() {
        viewModel.remoteUser.addObserver(remoteUserObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.setUserName()
        })
        viewModel.networkQuality.addObserver(networkQualityObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.setNetworkQualityTips()
        })
    }
    
    // MARK: Update UI
    func setUserName() {
        let remoteUser = viewModel.remoteUser.value
        userNameLabel.text = User.getUserDisplayName(user: remoteUser)
        networkTipsStatusLabel.text = viewModel.networkQuality.value
    }
    
    func setNetworkQualityTips() {
        let tips = viewModel.networkQuality.value
        networkTipsStatusLabel.text = tips
    }
}
