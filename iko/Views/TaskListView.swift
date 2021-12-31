//
//  TaskListView.swift
//  iko
//
//  Created by QPomelo on 19/11/2020.
//

import SwiftUI

struct TaskListView: View {
    
    @State var editedIconCount: Int = 0
    @State var taskIcons: [AppInfo] = []
    
    @State var controller: UIViewController?
    
    let pub = NotificationCenter.default
        .publisher(for: NSNotification.Name("iko.updateTask"))
    
    var body: some View {
        ZStack {
            // Background
            Rectangle().foregroundColor(Color("Background Color")).edgesIgnoringSafeArea(.all)
            // Title
            VStack(alignment: .center, spacing: 0) {
                Text("任务队列")
                    .font(Font.custom("PingFangSC-Medium", size: 17))
                    .foregroundColor(Color("Title Color"))
                Text("已经创建了 \(editedIconCount) 个替代图标")
                    .font(Font.custom("PingFangSC-Medium", size: 17))
                    .foregroundColor(Color("Subtitle Color"))
                // List
                ScrollView {
                    LazyVStack {
                        ForEach(taskIcons, id: \.id) { app in
                            ZStack {
                                Button(action: {
                                    let vc = NewIconViewController()
                                    vc.editAppIcon = app
                                    controller?.present(vc, animated: true)
                                }) {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(Color("Button Background Color"))
                                            .cornerRadius(10)
                                            .padding([.leading, .trailing], 20)
                                            .frame(height: 78)
                                        HStack(spacing: 0) {
                                            Rectangle().foregroundColor(.clear).frame(width: 22)
                                            Image(uiImage: app.editedAppIcon!)
                                                .resizable()
                                                .cornerRadius(10)
                                                .frame(width: 48, height: 48)
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text(app.appName)
                                                    .foregroundColor(Color("Main Color"))
                                                    .lineLimit(1)
                                                    .font(Font.custom("PingFangSC-Regular", size: 16))
                                                Text(app.appOrignalName)
                                                    .foregroundColor(Color("Main Color"))
                                                    .lineLimit(1)
                                                    .font(Font.custom("PingFangSC-Medium", size: 16))
                                                    .opacity(0.5)
                                            }.padding(.leading, 18)
                                            .padding(.trailing, 10)
                                            Spacer()
                                            Rectangle().frame(width: 50).foregroundColor(.clear)
                                        }
                                        .padding(.leading, 22)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                // Delete Button
                                HStack(spacing: 0) {
                                    Spacer()
                                    VStack(alignment: .center) {
                                        Spacer()
                                        Button(action: {
                                            let alert = UIAlertController(title: "你是否要删除 “\(app.appOrignalName)” 的替代图标？", message: nil, preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { _ in
                                                var index = 0
                                                for taskApp in IconTask.task {
                                                    if taskApp.id == app.id {
                                                        IconTask.task.remove(at: index)
                                                    }
                                                    index += 1
                                                }
                                                self.recivedTaskUpdatedNotification()
                                            }))
                                            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
                                            self.controller?.present(alert, animated: true)
                                        }) {
                                            ZStack {
                                                Rectangle().foregroundColor(Color("Delete Color")).mask(Circle())
                                                Image(systemName: "xmark")
                                                    .foregroundColor(.white)
                                                    .imageScale(.small)
                                            }.frame(width: 26, height: 26)
                                            
                                            
                                        }.frame(width: 40)
                                        .padding(.trailing, 40)
                                        Spacer()
                                    }
                                    
                                }
                            }
                        }
                    }
                }.padding(.top, 16)
                // Spacer()
            }.padding(.top, 10)
            
            // Tip
            if self.editedIconCount <= 3 {
                VStack(spacing: 0) {
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "barometer")
                            .imageScale(.small)
                        Text(": 继续添加图标, ")
                        Image(systemName: "arrow.down")
                            .imageScale(.small)
                        Text(": 安装图标")
                    }.font(Font.custom("PingFangSC-Medium", size: 14))
                    .foregroundColor(Color("Title Color"))
                }.padding(.bottom, 120)
            }
        }.onAppear(perform: onAppear)
        .onReceive(pub) { (output) in
            self.recivedTaskUpdatedNotification()
        }
    }
    
    func onAppear() {
        recivedTaskUpdatedNotification()
    }
    
    func recivedTaskUpdatedNotification() {
        taskIcons = []
        taskIcons = IconTask.task
        editedIconCount = taskIcons.count
    }
    
    
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}

struct RemoteImage: View {
    private enum LoadState {
        case loading, success, failure
    }
    
    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading
        
        init(url: String) {
            guard let parsedURL = URL(string: url) else {
                fatalError("Invalid URL: \(url)")
            }
            
            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }
    
    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image
    
    var body: some View {
        selectImage()
            .resizable()
    }
    
    init(url: String, loading: Image = Image("Empty App"), failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
    }
    
    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}
