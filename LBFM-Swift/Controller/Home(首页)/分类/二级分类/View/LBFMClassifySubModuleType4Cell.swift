//
//  LBFMClassifySubModuleType4Cell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMClassifySubModuleType4Cell: UICollectionViewCell {
    // 图片
    private var picView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 标题
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    // 子标题
    private var subLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        return label
    }()
    
    // 声音数量
    private var listenView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "listen")
        return imageView
    }()
    
    // 声音数
    private var listenLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout(){
        self.addSubview(self.picView)
        self.picView.image = UIImage(named: "pic1.jpeg")
        self.picView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(80)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.picView.snp.right).offset(10)
            make.right.equalToSuperview()
            make.top.equalTo(self.picView)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.subLabel)
        self.subLabel.text = "说服力的积分乐山大佛大"
        self.subLabel.snp.makeConstraints { (make) in
            make.right.height.equalTo(self.titleLabel)
            make.left.equalTo(self.picView.snp.right).offset(10)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
        }
        
        self.addSubview(self.listenView)
        self.listenView.snp.makeConstraints { (make) in
            make.left.equalTo(self.subLabel)
            make.bottom.equalToSuperview().offset(-25)
            make.width.height.equalTo(17)
        }
        
        self.addSubview(self.listenLabel)
        self.listenLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.listenView.snp.right).offset(5)
            make.bottom.equalTo(self.listenView)
            make.width.equalTo(60)
        }
    }
    
    var classifyVerticalModel: LBFMClassifyVerticalModel? {
        didSet {
            guard let model = classifyVerticalModel else {return}
            self.picView.kf.setImage(with: URL(string: model.coverPathSmall!))
            self.titleLabel.text = model.title
            self.subLabel.text = model.subtitle
            self.listenLabel.text = model.footnote
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
