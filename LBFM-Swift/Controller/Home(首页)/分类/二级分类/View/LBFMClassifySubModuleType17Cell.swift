//
//  LBFMClassifySubModuleType17Cell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMClassifySubModuleType17Cell: UICollectionViewCell {
    private var imageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
    }
    var classifyVerticalModel: LBFMClassifyVerticalModel? {
        didSet {
            guard let model = classifyVerticalModel else {return}
            self.imageView.kf.setImage(with: URL(string: model.coverPath!))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
