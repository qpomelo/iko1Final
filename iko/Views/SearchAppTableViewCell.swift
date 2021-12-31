//
//  SearchAppTableViewCell.swift
//  iko
//
//  Created by QPomelo on 3/12/2020.
//

import UIKit

class SearchAppTableViewCell: UITableViewCell {

    // - Proptery
    var loaded = false
    
    // - UI
    var background = UIView()
    var appIcon = UIImageView()
    var textContainer = UIView()
    var appName = UILabel()
    var appDeveloperName = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func initComponents() {
        if loaded { return }
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(background)
        background.backgroundColor = UIColor(named: "Button Background Color")
        background.layer.cornerRadius = 10
        background.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-3)
            make.height.greaterThanOrEqualTo(78)
        }
        
        background.addSubview(appIcon)
        appIcon.image = UIImage(named: "Empty App")
        appIcon.layer.cornerRadius = 10
        appIcon.layer.masksToBounds = true
        appIcon.snp.makeConstraints { make in
            make.left.equalTo(22)
            make.centerY.equalToSuperview()
            make.size.equalTo(48)
        }
        
        background.addSubview(textContainer)
        textContainer.backgroundColor = .clear
        textContainer.snp.makeConstraints { make in
            make.left.equalTo(appIcon.snp.right).offset(18)
            make.centerY.equalTo(appIcon)
            make.right.equalToSuperview()
        }
        
        
        textContainer.addSubview(appName)
        appName.font = UIFont(name: "PingFangSC-Regular", size: 15)
        appName.text = "App"
        appName.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        textContainer.addSubview(appDeveloperName)
        appDeveloperName.font = UIFont(name: "PingFangSC-Medium", size: 15)
        appDeveloperName.text = "Developer"
        appDeveloperName.alpha = 0.5
        appDeveloperName.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(appName.snp.bottom)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        loaded = true
    }
    
    override func prepareForReuse() {
        appIcon.image = UIImage(named: "Empty App")
        appName.text = "App"
        appDeveloperName.text = "Developer"
    }
    
}
