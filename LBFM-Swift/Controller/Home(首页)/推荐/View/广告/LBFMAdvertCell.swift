//
//  LBFMAdvertCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/22.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMAdvertCell: UICollectionViewCell {
    // 图片
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 标题
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    // 子标题
    private var subLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    func setUpLayout(){
        self.addSubview(self.imageView)
        self.imageView.image = UIImage(named: "fj.jpg")
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.imageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-60)
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.text = "那些事"
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.imageView.snp.bottom)
            make.height.equalTo(30)
        }
        
        self.addSubview(self.subLabel)
        self.subLabel.text = "开年会发年终奖呀领导开年会发年终奖呀"
        self.subLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var adModel:LBFMRecommnedAdvertModel? {
        didSet {
            guard let model = adModel else {return}
            self.titleLabel.text = model.name
            self.subLabel.text = model.description
//            self.imageView.image = UIImage(named: "fj.jpg")
        }
    }
}
