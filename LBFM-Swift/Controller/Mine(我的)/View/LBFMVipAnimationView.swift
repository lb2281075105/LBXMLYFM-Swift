//
//  LBFMVipAnimationView.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/1.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
/// 上下浮动vip领取view
class LBFMVipAnimationView: UIView {
    // 图片
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "vip")
        return imageView
    }()
    
    // 标题
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "VIP会员"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    // 介绍
    private lazy var desLabel:UILabel = {
        let label = UILabel()
        label.text = "免费领取7天会员"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    // 箭头
    private lazy var arrowsLabel:UILabel = {
        let label = UILabel()
        label.text = ">"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(r: 212, g: 212, b: 212)
        setUpLayout()
    }
    
    func setUpLayout(){
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(5)
            make.width.height.equalTo(30)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(5)
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.centerY.equalTo(self.imageView)
        }
        
        self.addSubview(self.desLabel)
        self.desLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.top.equalTo(self.imageView.snp.bottom).offset(5)
            make.width.equalTo(180)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.arrowsLabel)
        self.arrowsLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.height.equalTo(20)
            make.top.equalTo(20)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
