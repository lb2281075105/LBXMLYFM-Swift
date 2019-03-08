//
//  LBFMPlayDetailController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMPlayDetailController: UIViewController {

    // 外部传值请求接口如此那
    private var albumId: Int = 0
    
    convenience init(albumId: Int = 0) {
        self.init()
        self.albumId = albumId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
