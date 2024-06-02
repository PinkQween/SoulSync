////
////  ReactNative.swift
////  SoulSync
////
////  Created by Hanna Skairipa on 5/31/24.
////
//
//import UIKit
//import React
//
//class ReactNativeViewController: UIViewController {
//    var moduleName: String?
//
//    init(moduleName: String) {
//        self.moduleName = moduleName
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        guard let moduleName = moduleName else {
//            fatalError("Module name must be set")
//        }
//
//        let jsCodeLocation = URL(string: "http://localhost:8081/index.bundle?platform=ios")
//
//        let rootView = RCTRootView(
//            bundleURL: jsCodeLocation,
//            moduleName: moduleName,
//            initialProperties: nil,
//            launchOptions: nil
//        )
//
//        self.view = rootView
//    }
//}
