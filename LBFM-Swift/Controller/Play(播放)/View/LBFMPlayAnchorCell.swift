//
//  LBFMPlayAnchorCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMPlayAnchorCell: UICollectionViewCell {
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
    // 言论
    lazy var desLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    // bgimageView
    lazy var bgImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search_hint_histrack_bg_297x33_")
        return imageView
    }()
    
    // 赞助按钮
    private lazy var sponsorBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "sponsorBtn_41x30_"), for: UIControl.State.normal)
        //        button.addTarget(self, action: #selector(playBtn(button:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    func setUpUI(){
        self.addSubview(self.picView)
        self.picView.image = UIImage(named: "news.png")
        self.picView.layer.masksToBounds = true
        self.picView.layer.cornerRadius = 20
        self.picView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.text = "喜马拉雅"
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.picView.snp.right).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.top.equalTo(self.picView)
        }
        self.addSubview(self.attentionLabel)
        self.attentionLabel.text = "已被5.5万人关注"
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
            make.right.bottom.equalToSuperview().offset(-10)
        }
        
        self.addSubview(self.sponsorBtn)
        self.sponsorBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(41)
            make.height.equalTo(30)
            make.centerY.equalTo(self.picView)
        }
    }
    
    var userInfo:LBFMPlayUserInfo?{
        didSet{
            guard let model = userInfo else {return}
            self.picView.kf.setImage(with: URL(string: model.smallLogo!))
            self.nameLabel.text = model.nickname
            self.desLabel.text = model.skilledTopic
            var tagString:String?
            if model.followers > 100000000 {
                tagString = String(format: "%.1f亿", Double(model.followers) / 100000000)
            } else if model.followers > 10000 {
                tagString = String(format: "%.1f万", Double(model.followers) / 10000)
            } else {
                tagString = "\(model.followers)"
            }
            self.attentionLabel.text = "已被\(tagString ?? "")人关注"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
