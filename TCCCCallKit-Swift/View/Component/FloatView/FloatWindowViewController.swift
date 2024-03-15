//
//  FloatWindowViewController.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation

protocol FloatingWindowViewDelegate: NSObject {
    func tapGestureAction(tapGesture: UITapGestureRecognizer)
    func panGestureAction(panGesture: UIPanGestureRecognizer)
}

class FloatWindowViewController: UIViewController, FloatingWindowViewDelegate {
    
    weak var delegate: FloatingWindowViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFloatingWindowSignalView()
    }
    
    deinit {
        for view in view.subviews {
            view.removeFromSuperview()
        }
    }
    
    
    func addFloatingWindowSignalView() {
        let floatView = FloatingWindowSignalView(frame: CGRect.zero)
        view.addSubview(floatView)
        floatView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
        floatView.delegate = self
    }
    
    // MARK: FloatingWindowViewDelegate
    func tapGestureAction(tapGesture: UITapGestureRecognizer) {
        if self.delegate != nil && ((self.delegate?.responds(to: Selector(("tapGestureAction")))) != nil) {
            self.delegate?.tapGestureAction(tapGesture: tapGesture)
        }
    }
    
    func panGestureAction(panGesture: UIPanGestureRecognizer) {
        if self.delegate != nil && ((self.delegate?.responds(to: Selector(("panGestureAction")))) != nil) {
            self.delegate?.panGestureAction(panGesture: panGesture)
        }
    }
    
}
