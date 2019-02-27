//
//  LBFMRadioCategoriesCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/27.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMRadioCategoriesCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.width.equalToSuperview()
        }
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.equalTo(7.5)
            make.centerX.equalToSuperview()
        }
    }
    
    var dataSource: String? {
        didSet {
            guard let str = dataSource else { return }
            self.imageView.image = UIImage(named: " ")
            self.titleLabel.text = nil
            if (str.contains(".png")) {
                self.imageView.image = UIImage(named: str)
            }else {
                self.titleLabel.text = str
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
