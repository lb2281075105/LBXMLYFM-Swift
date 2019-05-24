//
//  AppDelegate.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/1/31.
//  Copyright © 2019 刘博. All rights reserved.
//

import ESTabBarController_swift
import SwiftMessages
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 1.加载tabbar样式
        let tabbar = setupTabBarStyle(delegate: self)
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = tabbar
        window?.makeKeyAndVisible()

        return true
    }
}

// MARK: UITabBarControllerDelegate

extension AppDelegate: UITabBarControllerDelegate {
    /// 1.加载tabbar样式
    ///
    /// - Parameter delegate: 代理
    /// - Returns: ESTabBarController
    func setupTabBarStyle(delegate: UITabBarControllerDelegate?) -> ESTabBarController {
        let tabBarController = ESTabBarController()
        tabBarController.delegate = delegate
        tabBarController.title = "Irregularity"
        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        tabBarController.shouldHijackHandler = { $2 == 2 ? true : false }
        tabBarController.didHijackHandler = {
            [weak tabBarController] _, _, _ in

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let warning = MessageView.viewFromNib(layout: .cardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()

                let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
                warning.configureContent(title: "Warning", body: "暂时没有此功能", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
                //                let vc = FMPlayController()
                //                tabBarController?.present(vc, animated: true, completion: nil)
            }
        }

        let tabarItemsModel = [
            TabbarItemModel(viewContorler: LBFMHomeController(), style: .system, normalImage: "home", seclectImage: "home_1", title: "首页", itemTitle: "首页"),
            TabbarItemModel(viewContorler: LBFMListenController(), style: .system, normalImage: "find", seclectImage: "find_1", title: "我听", itemTitle: "我听"),
            TabbarItemModel(viewContorler: LBFMPlayController(), style: .custom, normalImage: "tab_play", seclectImage: "tab_play", title: "播放", itemTitle: nil),
            TabbarItemModel(viewContorler: LBFMFindController(), style: .system, normalImage: "favor", seclectImage: "favor_1", title: "发现", itemTitle: "发现"),
            TabbarItemModel(viewContorler: LBFMMineController(), style: .system, normalImage: "me", seclectImage: "me_1", title: "我的", itemTitle: "我的"),
        ]

        for (index, model) in tabarItemsModel.enumerated() {
            model.configure(index)
        }

        tabBarController.viewControllers = tabarItemsModel.map { LBFMNavigationController(rootViewController: $0.viewContorler) }

        return tabBarController
    }
}
