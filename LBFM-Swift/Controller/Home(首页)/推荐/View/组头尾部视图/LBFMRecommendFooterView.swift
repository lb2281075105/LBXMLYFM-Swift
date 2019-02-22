//
//  LBFMRecommendFooterView.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/15.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMRecommendFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = LBFMDownColor

        self.setupFooterView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFooterView() {
        
    }
}
