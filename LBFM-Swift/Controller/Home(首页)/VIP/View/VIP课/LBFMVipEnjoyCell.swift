//
//  LBFMVipEnjoyCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMVipEnjoyCell: UICollectionViewCell {
    // 图片
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 标题
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // 喜点
    private var couponLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    // 会员免费
    private var freeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor.init(red: 203/255.0, green: 148/255.0, blue: 95/255.0, alpha: 1)
        label.text = "会员免费"
        label.textColor = UIColor.white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpLayout(){
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-110)
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.imageView.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        self.addSubview(self.couponLabel)
        self.couponLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.freeLabel)
        self.freeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(55)
            make.top.equalTo(self.couponLabel.snp.bottom).offset(5)
            make.height.equalTo(18)
        }
    }
    var categoryContentsModel:LBFMCategoryContents? {
        didSet {
            guard let model = categoryContentsModel else {return}
            self.imageView.kf.setImage(with: URL(string: model.coverLarge!))
            self.titleLabel.text = model.title
            // self.couponLabel.text = model.displayDiscountedPrice
            let text = NSMutableAttributedString(string: "")
            text.append(NSAttributedString(string: " \(model.displayDiscountedPrice ?? "0") ",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]))
            
            self.couponLabel.attributedText = text
            
        }
    }
}
