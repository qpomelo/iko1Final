//
//  QPSheetViewController.swift
//  Pigeon
//
//  Created by QPomelo on 2020/7/29.
//  Copyright © 2020 QPomelo. All rights reserved.
//

import UIKit

class QPSheetViewController: UIViewController {
    
    var _sheetTitle: String = "Title"
    var sheetTitle: String {
        get { return _sheetTitle }
        set {
            _sheetTitle = newValue
            updateTitle()
        }
    }
    
    var maskView: UIButton!
    
    var sheetBackgroundBlur: UIVisualEffectView!
    var sheetDialog: UIView!
    var sheetDragHandle: UIView!
    var sheetTitleLabel: UILabel!
    var contentView: UIView!
    var closeButton: QPButton!
    
    var swipeDownOffset: CGFloat = 0
    var swipeDownStartY: CGFloat = 0
    var swipeDownGestureswipeDownGestureFeedbackGenerator: UIImpactFeedbackGenerator!
    var swipeDownNoticed: Bool = false
    
    var dragGesture: UIPanGestureRecognizer!
    
    var loaded: Bool = false
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        set {}
        get { return .overFullScreen }
    }
    
    override var modalTransitionStyle: UIModalTransitionStyle {
        get { return .crossDissolve }
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initComponents()
        self.initGesture()
    }
    
    override func viewDidLayoutSubviews() {
        self.updateCloseButton()
        updateTitle()
    }
    
    func initComponents() {
        
        maskView = UIButton()
        view.addSubview(maskView)
        maskView.backgroundColor = UIColor(named: "Sheet Dialog Mask Color")
        maskView.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        maskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        sheetBackgroundBlur = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.addSubview(sheetBackgroundBlur)
        sheetBackgroundBlur.layer.cornerRadius = 10
        sheetBackgroundBlur.layer.masksToBounds = true
        
        sheetDialog = UIView()
        view.addSubview(sheetDialog)
        sheetDialog.backgroundColor = UIColor(named: "Sheet Dialog Color")
        sheetDialog.layer.cornerRadius = 10
        sheetDialog.isUserInteractionEnabled = true
        sheetDialog.layer.masksToBounds = true
        
        sheetDragHandle = UIView()
        sheetDialog.addSubview(sheetDragHandle)
        sheetDragHandle.backgroundColor = UIColor(named: "Sheet Dialog Drag Background Color")
        sheetDragHandle.layer.cornerRadius = 2
        sheetDragHandle.layer.masksToBounds = true
        sheetDragHandle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(36)
            make.height.equalTo(4)
        }
        
        sheetTitleLabel = UILabel()
        sheetDialog.addSubview(sheetTitleLabel)
        sheetTitleLabel.font = UIFont(name: "PingFangSC-Medium", size: 14)
        sheetTitleLabel.textColor = UIColor(named: "NP Title Color")
        sheetTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(30)
        }
        
        closeButton = QPButton()
        sheetDialog.addSubview(closeButton)
        closeButton.setImage(UIImage(named: "Sheet Dialog Cancel Button"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.snp.makeConstraints { (make) in
            make.size.equalTo(28)
            make.top.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        contentView = UIView()
        sheetDialog.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(closeButton.snp.bottom).offset(10)
            make.bottom.equalTo(sheetDialog) // (sheetDialog.safeAreaLayoutGuide)
            make.height.greaterThanOrEqualTo(10)
        }
        
        updateSheetDialogConstraints()
        loaded = true
    }
    
    func initGesture() {
        swipeDownGestureswipeDownGestureFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragGesture(_:)))
        sheetDialog.addGestureRecognizer(dragGesture)
    }
    
    @objc func dragGesture(_ recognizer: UIPanGestureRecognizer) {
        let translatedPoint = recognizer.translation(in: sheetDialog)
        switch recognizer.state {
        case .began:
            swipeDownStartY = translatedPoint.y
        case .ended:
            swipeDownStartY = 0
            if swipeDownOffset >= sheetDialog.frame.height / 2 {
                if view.frame.width < 420 {
                    UIView.animate(withDuration: 0.5) {
                        self.sheetDialog.snp.updateConstraints { (make) in
                            make.bottom.equalToSuperview().offset(self.view.frame.height)
                        }
                        self.view.layoutIfNeeded()
                    }
                }
                if askForDismiss() {
                    self.dismiss(animated: true)
                } else {
                    swipeDownOffset = 0
                    if view.frame.width < 420 {
                        UIView.animate(withDuration: 0.5) {
                            self.sheetDialog.snp.updateConstraints { (make) in
                                make.bottom.equalToSuperview().offset(self.swipeDownOffset)
                            }
                            self.view.layoutIfNeeded()
                        }
                    }
                }
            } else {
                swipeDownOffset = 0
                if view.frame.width < 420 {
                    UIView.animate(withDuration: 0.5) {
                        self.sheetDialog.snp.updateConstraints { (make) in
                            make.bottom.equalToSuperview().offset(self.swipeDownOffset)
                        }
                        self.view.layoutIfNeeded()
                    }
                }
            }
            return
        default:
            break
        }
        
        if recognizer.state == .changed {
            swipeDownOffset = translatedPoint.y - swipeDownStartY
            if swipeDownOffset >= 0 {
                if view.frame.width < 420 {
                    sheetDialog.snp.updateConstraints { (make) in
                        make.bottom.equalToSuperview().offset(swipeDownOffset)
                    }
                }
            }
            
        }
        
        if !swipeDownNoticed && (swipeDownOffset >= (sheetDialog.frame.height / 2)) {
            // 震动一下告诉可以关闭了
            swipeDownNoticed = true
            swipeDownGestureswipeDownGestureFeedbackGenerator.impactOccurred()
        }
        
        if (swipeDownOffset < (sheetDialog.frame.height / 2)) {
            swipeDownNoticed = false
        }
    }
    
    @objc func closeButtonPressed() {
        if askForDismiss() {
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateSheetDialogConstraints()
        updateTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTitle()
    }
    
    func updateSheetDialogConstraints() {
        sheetBackgroundBlur.snp.removeConstraints()
        sheetDialog.snp.removeConstraints()
        if view.frame.width >= 420 {
            // iPad / Mac
            sheetDialog.snp.makeConstraints { (make) in
                let width = view.frame.width / 2
                make.width.equalTo(width < 420 ? 420 : width) // 670
                make.center.equalToSuperview()
            }
        } else {
            // iPhone
            sheetDialog.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
        
        sheetBackgroundBlur.snp.makeConstraints { (make) in
            make.edges.equalTo(sheetDialog)
        }
        
        
    }
    
    func updateTitle() {
        if let label = sheetTitleLabel {
            label.text = _sheetTitle
        }
        
        if loaded && closeButton.isHidden == true && sheetTitleLabel.text == "" {
            contentView.snp.removeConstraints()
            contentView.snp.makeConstraints { (make) in
                make.leading.equalTo(view.safeAreaLayoutGuide)
                make.trailing.equalTo(view.safeAreaLayoutGuide)
                make.top.equalTo(closeButton.snp.top)
                make.bottom.equalTo(sheetDialog.safeAreaLayoutGuide)
                make.height.greaterThanOrEqualTo(10)
            }
        }
    }
    
    func updateCloseButton() {
        sheetDragHandle.isHidden = view.frame.width >= 420
        closeButton.isHidden = !(view.frame.width >= 420)
    }
    
    func askForDismiss() -> Bool {
        return true
    }
    
}
