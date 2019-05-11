//
//  LBFMListenRecommendCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMListenRecommendCell: UITableViewCell {
    // 背景大图
    private var picView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3
        return imageView
    }()
    // 标题
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    // 副标题
    private var subLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
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
    
    // 订阅按钮
    private var subscibeBtn : UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setTitle("+订阅", for: UIControl.State.normal)
        btn.setTitleColor(LBFMButtonColor, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.init(red: 254/255.0, green: 232/255.0, blue: 227/255.0, alpha: 1)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    func setUpLayout(){
        
        self.addSubview(self.picView)
        self.picView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(70)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.picView)
            make.left.equalTo(self.picView.snp.right).offset(10)
            make.height.equalTo(20)
            make.right.equalToSuperview()
        }
        
        self.addSubview(self.subLabel)
        self.subLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.left.height.right.equalTo(self.titleLabel)
        }
        
        self.addSubview(self.numView)
        self.numView.snp.makeConstraints { (make) in
            make.left.equalTo(self.subLabel)
            make.bottom.equalTo(self.picView)
            make.width.height.equalTo(17)
        }
        
        self.addSubview(self.numLabel)
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
        
        self.addSubview(self.subscibeBtn)
        self.subscibeBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(60)
            make.height.equalTo(24)
            make.centerY.equalTo(tracksLabel)
        }
    }
    
    var albums:albumsModel? {
        didSet {
            guard let model = albums else {return}
            self.picView.kf.setImage(with: URL(string: model.coverMiddle!))
            self.titleLabel.text = model.title
            self.subLabel.text = model.recReason
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
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
