//
//  TabbarItemModel.swift
//  LBFM-Swift
//
//  Created by 李腾芳 on 2019/5/24.
//  Copyright © 2019 刘博. All rights reserved.
//

import ESTabBarController_swift
import UIKit

struct TabbarItemModel {
    enum ItemStyle {
        case system
        case custom

        var view: ESTabBarItemContentView {
            switch self {
            case .system:
                return LBFMIrregularityBasicContentView()
            default:
                return LBFMIrregularityContentView()
            }
        }
    }

    let viewContorler: UIViewController
    let style: ItemStyle
    let normalImage: String
    let seclectImage: String
    let title: String
    let itemTitle: String?

    func configure(_ tag: Int) {
        viewContorler.tabBarItem = ESTabBarItem(style.view, title: itemTitle, image: UIImage(named: normalImage), selectedImage: UIImage(named: seclectImage), tag: tag)
        viewContorler.title = title
    }
}
