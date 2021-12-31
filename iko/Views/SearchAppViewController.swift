//
//  SearchAppViewController.swift
//  iko
//
//  Created by QPomelo on 30/11/2020.
//

import UIKit
import Alamofire
import SwiftyRequest
import SwiftyJSON

class SearchAppViewController: UIViewController, UITextFieldDelegate {
    
    var sheetController: NewIconViewController?
    
    public static var checkedNetworkPermission: Bool = false
    
    // - UI Components
    var backButton = QPButton()
    var titleLabel = UILabel()
    var searchContainer = UIView()
    var searchIcon = UIImageView()
    var searchInput = UITextField()
    var searchQueringData = UIActivityIndicatorView()
    var searchButton = QPButton()
    var tableView = UITableView()
    var resultTip = UILabel()
    
    // - Data
    var appList = [AppInfo]()
    
    // - Delegate
    var delegate: SearchAppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initComponents()
    }
    
    func initComponents() {
        
        title = "在 App Store 中搜索应用"
        
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        backButton.setImage(UIImage(named: "Back Button"), for: .normal)
        backButton.addTarget(self, action: #selector(didBackButtonPressed), for: .touchUpInside)
        titleLabel.text = "在 App Store 中搜索应用"
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
        
        
        
        view.addSubview(searchContainer)
        searchContainer.layer.cornerRadius = 10
        searchContainer.backgroundColor = UIColor(named: "Button Background Color")
        searchContainer.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(backButton.snp.bottom).offset(16)
            make.height.equalTo(48)
        }
        
        searchContainer.addSubview(searchIcon)
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = UIColor(named: "Subtitle Color")
        searchIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        searchContainer.addSubview(searchInput)
        searchInput.placeholder = "应用名称"
        searchInput.font = UIFont(name: "PingFangSC-Regular", size: 15)
        searchInput.keyboardType = .webSearch
        searchInput.delegate = self
        searchInput.snp.makeConstraints { make in
            make.left.equalTo(searchIcon.snp.right).offset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(250)
        }
        
        searchContainer.addSubview(searchQueringData)
        searchQueringData.stopAnimating()
        searchQueringData.isHidden = true
        searchQueringData.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-22)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(searchButton)
        searchButton.setTitle("搜索", for: .normal)
        searchButton.tintColor = UIColor(named: "Button Text Color")
        searchButton.backgroundColor = UIColor(named: "Button Background Color")
        searchButton.layer.cornerRadius = 10
        searchButton.layer.masksToBounds = true
        searchButton.addTarget(self, action: #selector(didSearchButtonPressed), for: .touchUpInside)
        searchButton.snp.makeConstraints { make in
            make.left.equalTo(searchContainer.snp.right).offset(10)
            make.centerY.equalTo(searchContainer)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(48)
            make.width.greaterThanOrEqualTo(60)
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(SearchAppTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(searchContainer.snp.bottom).offset(10)
        }
        
        view.addSubview(resultTip)
        resultTip.text = "请输入应用名称后点按 “搜索” 开始搜索"
        resultTip.font = UIFont(name: "PingFangSC-Medium", size: 16)
        resultTip.alpha = 0.5
        resultTip.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchInput.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchQueringData.isHidden = false
        searchQueringData.startAnimating()
        
        if searchInput.text == "" {
            // Alert
            let alert = UIAlertController(title: "请输入所需搜索的应用名称", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .default))
            self.present(alert, animated: true)
            // Stop Animating
            searchQueringData.isHidden = true
            searchQueringData.stopAnimating()
            // Return
            return false
        }
        
        loadAppList()
        return false
    }
    
    func loadAppList() {
        let countryCode = Locale.current.regionCode?.lowercased() ?? "us"
        AF.request("https://itunes.apple.com/search?media=software&entity=software%2CiPadSoftware&term=\(searchInput.text?.urlEncoded() ?? "App")&country=\(countryCode)&limit=20", method: .get).responseString {
            response in
            // Clear current list
            self.appList = []
            self.tableView.reloadData()
            // Stop Animating
            DispatchQueue.main.async {
                self.searchQueringData.isHidden = true
                self.searchQueringData.stopAnimating()
            }
            // Check success
            if let error = response.error {
                // Solve Error
                let alert = UIAlertController(title: "搜索出错", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好", style: .default))
                self.present(alert, animated: true)
            } else if let jsonString = String(data: response.data ?? Data(), encoding: .utf8) {
                // Get App List
                let json = JSON(parseJSON: jsonString)
                if let appArray = json["results"].array {
                    for app in appArray {
                        // Icon
                        var iconUrl = ""
                        if let _iconUrl = app["artworkUrl512"].string {
                            iconUrl = _iconUrl
                        } else if let _iconUrl = app["artworkUrl100"].string {
                            iconUrl = _iconUrl
                        } else if let _iconUrl = app["artworkUrl60"].string {
                            iconUrl = _iconUrl
                        }
                        // Name
                        var name = ""
                        if let _name = app["trackName"].string {
                            name = _name
                        }
                        // Developer Name
                        var developerName = ""
                        if let _developerName = app["sellerName"].string {
                            developerName = _developerName
                        }
                        // Bundle Id
                        var bundleId = ""
                        if let _bundleId = app["bundleId"].string {
                            bundleId = _bundleId
                        }
                        // Id
                        var id: Int64 = 0
                        if let _id = app["trackId"].int64 {
                            id = _id
                        }
                        // Url (local)
                        let url: String? = KeyValue.load(fileName: "KnownIssueAppSchemeFix")[bundleId]
                        
                        let app = AppInfo(urlScheme: url, id: id, iconUrl: iconUrl, appName: name, appOrignalName: name, developerName: developerName, bundleId: bundleId)
                        self.appList.append(app)
                    }
                    if appArray.count == 0 {
                        let alert = UIAlertController(title: "未搜索到应用", message: "请更换关键词试试？\n\n提示: App Store 搜索地区与你设备的地区设置相同", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "好", style: .default))
                        self.present(alert, animated: true)
                    }
                } else {
                    let alert = UIAlertController(title: "未搜索到应用", message: "请更换关键词试试？\n\n提示：在 App Store 搜索应用时选择的地区与你设备的地区设置相同", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好", style: .default))
                    self.present(alert, animated: true)
                }
                self.tableView.reloadData()
            }
        }
    }
    
}

extension SearchAppViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if appList.count != 0 {
            resultTip.isHidden = true
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SearchAppTableViewCell else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No Data"
            return cell
        }
        cell.initComponents()
        
        let app = appList[indexPath.row]
        cell.appName.text = app.appName
        cell.appDeveloperName.text = app.developerName
        Cache.loadImageAsync(app.iconUrl) { (img) in
            if let image = img {
                DispatchQueue.main.async {
                    cell.appIcon.image = image
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = appList[indexPath.row]
        delegate?.searchApp(searched: app)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didBackButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didSearchButtonPressed() {
        _ = textFieldShouldReturn(searchInput)
    }
    
}

protocol SearchAppDelegate {
    
    func searchApp(searched app: AppInfo)
    
}
