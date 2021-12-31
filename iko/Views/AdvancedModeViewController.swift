//
//  AdvancedModeViewController.swift
//  iko
//
//  Created by QPomelo on 14/12/2020.
//

import UIKit

class AdvancedModeViewController: UIViewController {
    
    // - UI Components
    var backButton = QPButton()
    var titleLabel = UILabel()
    var proUserWarn = UILabel()
    var bundleIdContainer = UIView()
    var bundleIdTitle = UILabel()
    var bundleIdInput = UITextField()
    var urlContainer = UIView()
    var urlTitle = UILabel()
    var urlInput = UITextField()
    
    // - Delegate
    var controller: EditIconInfoViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "高级模式"
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        backButton.setImage(UIImage(named: "Back Button"), for: .normal)
        backButton.addTarget(self, action: #selector(didBackButtonPressed), for: .touchUpInside)
        titleLabel.text = "高级模式"
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 14)
        titleLabel.textColor = UIColor(named: "NP Title Color")
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalTo(titleLabel)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(16)
            make.top.equalToSuperview().offset(6)
        }
        
        
        view.addSubview(proUserWarn)
        proUserWarn.text = "如果您不清楚该页面的作用，请勿更改"
        proUserWarn.textColor = UIColor(named: "Delete Color")
        proUserWarn.font = UIFont(name: "PingFangSC-Medium", size: 15)
        proUserWarn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(backButton.snp.bottom).offset(12)
        }
        
        view.addSubview(bundleIdContainer)
        bundleIdContainer.layer.cornerRadius = 10
        bundleIdContainer.layer.masksToBounds = true
        bundleIdContainer.backgroundColor = UIColor(named: "Button Background Color")
        bundleIdContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(58)
            make.top.equalTo(proUserWarn.snp.bottom).offset(10)
        }
        
        bundleIdContainer.addSubview(bundleIdTitle)
        bundleIdTitle.text = "包名"
        bundleIdTitle.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        bundleIdTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.centerY.equalToSuperview()
        }
        
        bundleIdContainer.addSubview(bundleIdInput)
        bundleIdInput.placeholder = "com.example.app"
        bundleIdInput.font = UIFont(name: "PingFangSC-Regular", size: 16)
        bundleIdInput.snp.makeConstraints { make in
            make.left.equalTo(bundleIdTitle.snp.right).offset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(250)
        }
        
        view.addSubview(urlContainer)
        urlContainer.layer.cornerRadius = 10
        urlContainer.layer.masksToBounds = true
        urlContainer.backgroundColor = UIColor(named: "Button Background Color")
        urlContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(58)
            make.top.equalTo(bundleIdContainer.snp.bottom).offset(5)
        }
        
        urlContainer.addSubview(urlTitle)
        urlTitle.text = "URL"
        urlTitle.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        urlTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.centerY.equalToSuperview()
        }
        
        urlContainer.addSubview(urlInput)
        urlInput.placeholder = "example://"
        urlInput.font = UIFont(name: "PingFangSC-Regular", size: 16)
        urlInput.snp.makeConstraints { make in
            make.left.equalTo(urlTitle.snp.right).offset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(250)
        }
    }
    
    @objc func didBackButtonPressed() {
        controller?.customedUrl = urlInput.text ?? ""
        controller?.customedBundleId = bundleIdInput.text ?? ""
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
