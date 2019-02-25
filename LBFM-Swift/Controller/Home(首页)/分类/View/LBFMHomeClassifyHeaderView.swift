//
//  LBFMHomeClassifyHeaderView.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMHomeClassifyHeaderView: UICollectionReusableView {
    lazy var view : UIView = {
        let view = UIView()
        view.backgroundColor = LBFMButtonColor
        return view
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = LBFMDownColor
        self.addSubview(self.view)
        self.view.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
            make.width.equalTo(4)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.right).offset(10)
            make.right.equalTo(-10)
            make.top.bottom.equalToSuperview()
        }
    }
    
    var titleString: String? {
        didSet{
            guard let str = titleString else { return }
            self.titleLabel.text = str
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
