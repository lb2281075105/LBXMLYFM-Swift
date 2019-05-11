//
//  LBFMPlayCircleCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMPlayCircleCell: UICollectionViewCell {
    // 头像
    lazy var picView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    //昵称
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    //关注
    lazy var attentionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        return label
    }()
    //    // 言论
    lazy var desLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    // bgimageView
    lazy var bgImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cell_bg_commentline_355x86_")
        return imageView
    }()
    
    //加入按钮
    private lazy var joinBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("加入", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.backgroundColor = LBFMButtonColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    func setUpUI(){
        self.addSubview(self.picView)
        self.picView.image = UIImage(named: "news.png")
        self.picView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.text = "喜马拉雅好"
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.picView.snp.right).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.top.equalTo(self.picView)
        }
        self.addSubview(self.attentionLabel)
        self.attentionLabel.text = "成员 793   帖子 46"
        self.attentionLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(self.nameLabel)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(5)
        }
        
        self.addSubview(self.bgImageView)
        self.bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.picView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        self.bgImageView.addSubview(self.desLabel)
        self.desLabel.text = "四六级发送到"
        self.desLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.right.bottom.equalToSuperview().offset(-15)
        }
        
        self.addSubview(self.joinBtn)
        self.joinBtn.layer.masksToBounds = true
        self.joinBtn.layer.cornerRadius = 15
        self.joinBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.centerY.equalTo(self.picView)
        }
    }
    
    var communityInfo:LBFMPlayCommunityInfo?{
        didSet{
            guard let model = communityInfo else {return}
            self.picView.kf.setImage(with: URL(string: model.logoSmall!))
            self.nameLabel.text = model.name
            self.desLabel.text = model.introduce
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
