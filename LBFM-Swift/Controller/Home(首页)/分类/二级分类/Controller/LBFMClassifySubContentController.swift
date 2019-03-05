//
//  LBFMClassifySubContentController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/5.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMClassifySubContentController: UIViewController {
    // - 上页面传过来请求接口必须的参数
    private var keywordId: Int = 0
    private var categoryId: Int = 0
    convenience init(keywordId: Int = 0, categoryId:Int = 0) {
        self.init()
        self.keywordId = keywordId
        self.categoryId = categoryId
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
