//
//  LBHotAudiobookCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/22.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBHotAudiobookCell: UICollectionViewCell {
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
    
    // 是否完结
    private var paidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(red: 248, green: 210, blue: 74, alpha: 1)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    // 子标题
    private var subLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        return label
    }()
    
    // 播放数量
    private var numLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    // 集数
    private var tracksLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    // 播放数量图片
    private var numView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "playcount.png")
        return imageView
    }()
    
    // 集数图片
    private var tracksView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "track.png")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置布局
        setUpLayout()
    }
    
    func setUpLayout(){
        self.addSubview(self.picView)
        self.picView.image = UIImage(named: "pic1.jpeg")
        self.picView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(80)
        }
        
        self.addSubview(self.paidLabel)
        self.paidLabel.text = "完结"
        self.paidLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.picView.snp.right).offset(10)
            make.top.equalTo(self.picView).offset(2)
            make.height.equalTo(16)
            make.width.equalTo(30)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.paidLabel.snp.right).offset(10)
            make.right.equalToSuperview()
            make.top.equalTo(self.picView)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.subLabel)
        self.subLabel.text = "说服力的积分乐"
        self.subLabel.snp.makeConstraints { (make) in
            make.right.height.equalTo(self.titleLabel)
            make.left.equalTo(self.picView.snp.right).offset(10)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
        }
        
        self.addSubview(self.numView)
        self.numView.snp.makeConstraints { (make) in
            make.left.equalTo(self.subLabel)
            make.bottom.equalToSuperview().offset(-25)
            make.width.height.equalTo(17)
        }
        
        self.addSubview(self.numLabel)
        self.numLabel.text = "> 2.5亿 1284集"
        self.numLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.numView.snp.right).offset(5)
            make.bottom.equalTo(self.numView)
            make.width.equalTo(60)
        }
        
        self.addSubview(self.tracksView)
        self.tracksView.snp.makeConstraints { (make) in
            make.left.equalTo(self.numLabel.snp.right).offset(5)
            make.bottom.equalTo(self.numLabel)
            make.width.height.equalTo(20)
        }
        
        self.addSubview(self.tracksLabel)
        self.tracksLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.tracksView.snp.right).offset(5)
            make.bottom.equalTo(self.tracksView)
            make.width.equalTo(80)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var recommendData:LBFMRecommendListModel? {
        didSet{
            guard let model = recommendData else { return }
            if (model.pic != nil) {
                self.picView.kf.setImage(with: URL(string: model.pic!))
            }
            if (model.coverPath != nil) {
                self.picView.kf.setImage(with: URL(string: model.coverPath!))
            }
            self.titleLabel.text = model.title
            self.subLabel.text = model.subtitle
            if model.isPaid {
                self.paidLabel.isHidden = true
                self.paidLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(0)
                }
                self.titleLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(self.paidLabel.snp.right)
                }
            }
            self.tracksLabel.text = "\(model.tracksCount)集"
            var tagString:String?
            if model.playsCount > 100000000 {
                tagString = String(format: "%.1f亿", Double(model.playsCount) / 100000000)
            } else if model.playsCount > 10000 {
                tagString = String(format: "%.1f万", Double(model.playsCount) / 10000)
            } else {
                tagString = "\(model.playsCount)"
            }
            self.numLabel.text = tagString
        }
    }
    
    var guessYouLikeModel:LBFMGuessYouLikeModel? {
        didSet{
            guard let model = guessYouLikeModel else { return }
            self.titleLabel.text = model.title
            self.picView.kf.setImage(with: URL(string: model.coverMiddle!))
            self.subLabel.text = model.recReason
            if model.isPaid {
                self.paidLabel.isHidden = true
                self.paidLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(0)
                }
                self.titleLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(self.paidLabel.snp.right)
                }
            }
            self.tracksLabel.text = "\(model.tracks)集"
            var tagString:String?
            if model.playsCounts > 100000000 {
                tagString = String(format: "%.1f亿", Double(model.playsCounts) / 100000000)
            } else if model.playsCounts > 10000 {
                tagString = String(format: "%.1f万", Double(model.playsCounts) / 10000)
            } else {
                tagString = "\(model.playsCounts)"
            }
            self.numLabel.text = tagString
        }
    }
}
