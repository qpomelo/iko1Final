//
//  EditIconInfoViewController.swift
//  iko
//
//  Created by QPomelo on 30/11/2020.
//

import UIKit

class EditIconInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SearchAppDelegate {
    
    var sheetController: NewIconViewController?
    
    // - UI Components
    var titleLabel = UILabel()
    var iconPreview = QPButton()
    var nameContainer = UIView()
    var nameTitle = UILabel()
    var nameInput = UITextField()
    var appContainer = UIView()
    var appTitle = UILabel()
    var appSelectButton = QPButton()
    var appIcon = UIImageView()
    var appName = UILabel()
    var addToTaskButton = QPButton()
    var cancelButton = QPButton()
    var imagePicker: UIImagePickerController?
    var advancedModeButton = QPButton()
    
    // Delegate
    var cnaDelegate = CustomNaviAnimateDelagete()
    
    // - Data
    var pickedIconImage: UIImage?
    var pickedApp: AppInfo?
    var editAppIcon: AppInfo?
    var customedBundleId: String = ""
    var customedUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initComponents()
    }
    
    func askForDissmiss() -> Bool {
        if pickedIconImage == nil && pickedApp == nil && nameInput.text == "" && customedUrl == "" && customedBundleId == "" {
            return true
        } else {
            didCancelButtonPressed()
            return false
        }
    }
    
    func initComponents() {
        
        title = "新建替代图标"
        self.navigationController?.delegate = cnaDelegate
        
        view.addSubview(titleLabel)
        titleLabel.text = "新建替代图标"
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 14)
        titleLabel.textColor = UIColor(named: "NP Title Color")
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(6)
        }
        view.addSubview(advancedModeButton)
        advancedModeButton.setTitle("高级模式", for: .normal)
        advancedModeButton.tintColor = UIColor(named: "Theme Color")
        advancedModeButton.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 15)
        advancedModeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalTo(titleLabel)
        }
        advancedModeButton.addTarget(self, action: #selector(advancedModePressed), for: .touchUpInside)
        
        view.addSubview(iconPreview)
        iconPreview.layer.cornerRadius = 30
        iconPreview.layer.masksToBounds = true
        iconPreview.setImage(UIImage(named: "Empty Image Icon"), for: .normal)
        iconPreview.addTarget(self, action: #selector(didPickImageButtonPressed), for: .touchUpInside)
        iconPreview.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.size.equalTo(128)
        }
        
        view.addSubview(nameContainer)
        nameContainer.layer.cornerRadius = 10
        nameContainer.layer.masksToBounds = true
        nameContainer.backgroundColor = UIColor(named: "Button Background Color")
        nameContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(58)
            make.top.equalTo(iconPreview.snp.bottom).offset(40)
        }
        
        nameContainer.addSubview(nameTitle)
        nameTitle.text = "名称"
        nameTitle.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        nameTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.centerY.equalToSuperview()
        }
        
        nameContainer.addSubview(nameInput)
        nameInput.placeholder = "新的图标"
        nameInput.font = UIFont(name: "PingFangSC-Regular", size: 16)
        nameInput.snp.makeConstraints { make in
            make.left.equalTo(nameTitle.snp.right).offset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(250)
        }
        
        view.addSubview(appContainer)
        appContainer.layer.cornerRadius = 10
        appContainer.layer.masksToBounds = true
        appContainer.backgroundColor = UIColor(named: "Button Background Color")
        appContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(58)
            make.top.equalTo(nameContainer.snp.bottom).offset(3)
        }
        
        appContainer.addSubview(appTitle)
        appTitle.text = "应用"
        appTitle.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        appTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.centerY.equalToSuperview()
        }
        
        appContainer.addSubview(appSelectButton)
        appSelectButton.addTarget(self, action: #selector(didSelectAppButtonPressed), for: .touchUpInside)
        appSelectButton.snp.makeConstraints { make in
            make.left.equalTo(appTitle.snp.right).offset(8)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        appSelectButton.addSubview(appIcon)
        appIcon.image = UIImage(named: "Empty Image Icon")
        appIcon.layer.cornerRadius = 7.5
        appIcon.layer.masksToBounds = true
        appIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }
        
        appSelectButton.addSubview(appName)
        appName.text = "选择 app..."
        appName.font = UIFont(name: "PingFangSC-Regular", size: 15)
        appName.snp.makeConstraints { make in
            make.left.equalTo(appIcon.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        
        view.addSubview(cancelButton)
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.masksToBounds = true
        cancelButton.backgroundColor = UIColor(named: "Button Background Color")
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.tintColor = UIColor(named: "Subtitle Color")
        cancelButton.addTarget(self, action: #selector(didCancelButtonPressed), for: .touchUpInside)
        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(56)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        view.addSubview(addToTaskButton)
        addToTaskButton.layer.cornerRadius = 10
        addToTaskButton.layer.masksToBounds = true
        addToTaskButton.backgroundColor = UIColor(named: "Theme Color")
        addToTaskButton.setTitle("添加到队列", for: .normal)
        addToTaskButton.tintColor = .white
        addToTaskButton.addTarget(self, action: #selector(didAddToTaskButtonPressed), for: .touchUpInside)
        addToTaskButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(56)
            make.bottom.equalTo(cancelButton.snp.top).offset(-10)
        }
        
        loadData()
        
    }
    
    func loadData() {
        if let icon = editAppIcon {
            pickedIconImage = icon.editedAppIcon
            pickedApp = icon
            nameInput.text = icon.appName
            
            titleLabel.text = "编辑替代图标"
            addToTaskButton.setTitle("保存", for: .normal)
            Cache.loadImageAsync(icon.iconUrl) { (img) in
                if let image = img {
                    DispatchQueue.main.async {
                        self.appIcon.image = image
                        self.pickedIconImage = image
                        self.iconPreview.setImage(image, for: .normal)
                    }
                }
            }
            appName.text = icon.appOrignalName
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.pickedIconImage = image
            self.iconPreview.setImage(self.pickedIconImage, for: .normal)
            if image.isTransparent() {
                picker.dismiss(animated: true) {
                    let alert = UIAlertController(title: "警告", message: "你所选择的图片包含透明颜色，因 iOS 限制，透明颜色显示在主屏幕上时会显示为黑色", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好", style: .default))
                    self.present(alert, animated: true)
                }
                return
            }
        }
        picker.dismiss(animated: true)
    }
    
    @objc func didPickImageButtonPressed() {
        if customedUrl == "" && customedBundleId == "" && pickedApp == nil {
            didSelectAppButtonPressed()
            return
        }
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
        }
        // imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        self.navigationController?.show(imagePicker!, sender: self)
    }
    
    @objc func didSelectAppButtonPressed() {
        let searchViewController = SearchAppViewController()
        searchViewController.delegate = self
        searchViewController.sheetController = self.sheetController
        self.show(searchViewController, sender: self)
    }
    
    @objc func didAddToTaskButtonPressed() {
        
        if pickedIconImage == nil {
            let alert = UIAlertController(title: "请选择新的替代图标", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        if pickedApp == nil && (customedBundleId == "" && customedUrl == "") {
            let alert = UIAlertController(title: "请选择点击替代图标启动的应用程序(或者设置其对应的包名/URL)", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        if nameInput.text == "" {
            let alert = UIAlertController(title: "请输入替代图标的标签", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        pickedApp?.editedAppIcon = pickedIconImage
        pickedApp?.appName = nameInput.text!
        
        if customedUrl != "" {
            pickedApp?.urlScheme = customedUrl
        }
        if customedBundleId != "" {
            pickedApp?.bundleId = customedBundleId
        }
        
        if editAppIcon != nil {
            // 编辑
            var index = 0
            for task in IconTask.task {
                if task.bundleId == editAppIcon!.bundleId &&
                    task.editedAppIcon == editAppIcon!.editedAppIcon &&
                    task.appName == editAppIcon!.appName {
                    break
                }
                index += 1
            }
            IconTask.task[index] = pickedApp!
        } else {
            // 添加
            if pickedApp == nil {
                if customedUrl == "" { customedUrl = " " }
                if customedBundleId == "" { customedBundleId = " " }
                pickedApp = AppInfo(editedAppIcon: pickedIconImage, urlScheme: customedUrl, id: 0, iconUrl: " ", appName: nameInput.text ?? " ", appOrignalName: "Web Clip", developerName: "nil", bundleId: customedBundleId)
            }
            IconTask.task.append(pickedApp!)
        }
        
        NotificationCenter.default.post(Notification(name: Notification.Name("iko.updateTask")))
        
        self.dismiss(animated: true)
        
    }
    
    @objc func didCancelButtonPressed() {
        if pickedIconImage != nil || pickedApp != nil || nameInput.text != "" || customedUrl != "" || customedBundleId != "" {
            // 询问是否退出
            let alert = UIAlertController(title: "是否退出编辑器？", message: editAppIcon == nil ? "你还有尚未添加至队列的内容" : "将不会保存你的更改", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "退出", style: .destructive, handler: { _ in
                self.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "留下", style: .cancel))
            self.present(alert, animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    func searchApp(searched app: AppInfo) {
        pickedApp = app
        
        Cache.loadImageAsync(app.iconUrl) { (img) in
            if let image = img {
                DispatchQueue.main.async {
                    self.appIcon.image = image
                    if self.pickedIconImage == nil {
                        self.pickedIconImage = image
                        self.iconPreview.setImage(image, for: .normal)
                    }
                }
            }
        }
        appName.text = app.appName
        if nameInput.text == "" {
            nameInput.text = appName.text
        }
        
        
    }
    
    @objc func advancedModePressed(_ button: UIButton) {
        let vc = AdvancedModeViewController()
        vc.controller = self
        self.navigationController?.show(vc, sender: self)
    }
    
}


class CustomNaviAnimatedTransition: NSObject {
    var isPushed: Bool?
    
    // 通过 static let 创建单例
    static let shared = CustomNaviAnimatedTransition()
    // 构造函数，init前加private修饰,表示原始构造方法只能自己使用，外界不发调用
    private override init() { }
}

extension CustomNaviAnimatedTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        let containerView = transitionContext.containerView
        
        if isPushed == true {
            
            containerView.addSubview(toView)
            toView.frame.origin.x = toView.bounds.width
            
            UIView.animate(withDuration: 0.5, animations: {
                fromView.frame.origin.x = -fromView.frame.width
                toView.frame.origin.x = 0
            }, completion: { (finished) in
                if finished {
                    transitionContext.completeTransition(finished)
                }
            })
            
        } else {
            toView.frame.origin.x = -toView.frame.width
            
            containerView.insertSubview(toView, belowSubview: fromView)
            UIView.animate(withDuration: 0.5, animations: {
                fromView.frame.origin.x = fromView.frame.width
                toView.frame.origin.x = 0
            }, completion: { (finished) in
                if finished {
                    transitionContext.completeTransition(finished)
                }
            })
        }
    }
}


class CustomNaviAnimateDelagete: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationTransition = CustomNaviAnimatedTransition.shared
        animationTransition.isPushed = operation.rawValue == 1
        return animationTransition
    }
}
