//
//  LBFMClassifySubHorizontalCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/7.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMClassifySubHorizontalCell: UICollectionViewCell {
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
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 布局
        setUpLayout()
    }
    
    func setUpLayout(){
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.imageView.snp.bottom)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.subLabel)
        self.subLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
    }
    
    var classifyVerticalModel: LBFMClassifyVerticalModel? {
        didSet {
            guard let model = classifyVerticalModel else {return}
            self.imageView.kf.setImage(with: URL(string: model.coverMiddle!))
            self.titleLabel.text = model.title
            self.subLabel.text = model.intro
        }
    }
    
    var classifyModuleType20Model:LBFMClassifyModuleType20List? {
        didSet {
            guard let model = classifyModuleType20Model else {return}
            self.imageView.kf.setImage(with: URL(string: model.albumCoverUrl290!))
            self.titleLabel.text = model.title
            self.subLabel.text = model.intro
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
