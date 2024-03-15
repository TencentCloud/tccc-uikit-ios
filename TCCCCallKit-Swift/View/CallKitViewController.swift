//
//  CallKitViewController.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation
import UIKit
class CallKitViewController: UIViewController, SingleCallViewDelegate {
    
    var isStatusBarHidden = false
    
    deinit {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let callView: SingleCallView? = SingleCallView(frame: CGRect.zero)
        callView?.delegate = self
        view.addSubview(callView ?? UIView())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.isStatusBarHidden
    }
    
    // MARK: SingleCallViewDelegate
    func handleStatusBarHidden(isHidden: Bool) {
        self.isStatusBarHidden = isHidden
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
}

class CallKitNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
