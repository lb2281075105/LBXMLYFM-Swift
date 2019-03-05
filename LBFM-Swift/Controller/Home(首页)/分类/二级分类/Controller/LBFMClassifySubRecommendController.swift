//
//  LBFMClassifySubRecommendController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/5.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMClassifySubRecommendController: UIViewController {

    // - 上页面传过来请求接口必须的参数
    private var categoryId: Int = 0
    convenience init(categoryId:Int = 0) {
        self.init()
        self.categoryId = categoryId
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    

}
