//
//  LBFMHomeRadiosCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/27.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMHomeRadiosCell: UICollectionViewCell {
    // 图片
    private var imageView: UIImageView = {
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    // 数量子标题
    private var numLabel : UILabel = {
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
    
    // 播放按钮
    private var playBtn : UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    func setUpUI(){
        self.addSubview(self.imageView)
        self.imageView.image = UIImage(named: "pic1.jpeg")
        self.imageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(80)
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(10)
            make.right.equalToSuperview()
            make.top.equalTo(self.imageView)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.subLabel)
        self.subLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
        }
        
        self.addSubview(self.numView)
        self.numView.snp.makeConstraints { (make) in
            make.left.equalTo(self.subLabel)
            make.bottom.equalToSuperview().offset(-17)
            make.width.height.equalTo(17)
        }
        
        self.addSubview(self.numLabel)
        self.numLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.numView.snp.right).offset(5)
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        self.addSubview(self.playBtn)
        self.playBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
    }
    
    var localRadioModel : LBFMLocalRadiosModel? {
        didSet {
            guard let model = localRadioModel else { return }
            self.imageView.kf.setImage(with: URL(string: model.coverLarge!))
            self.titleLabel.text = model.name
            let programName = model.programName ?? ""
            self.subLabel.text = String(format: "正在直播:%@",programName)
            var numString:String?
            if model.playCount > 100000000 {
                numString = String(format: "%.1f亿", Double(model.playCount) / 100000000)
            } else if model.playCount > 10000 {
                numString = String(format: "%.1f万", Double(model.playCount) / 10000)
            } else {
                numString = "\(model.playCount)"
            }
            self.numLabel.text = numString
        }
    }
    
    var topRadioModel : LBFMTopRadiosModel? {
        didSet {
            guard let model = topRadioModel else { return }
            self.imageView.kf.setImage(with: URL(string: model.coverLarge!))
            self.titleLabel.text = model.name
            let programName = model.programName ?? ""
            self.subLabel.text = String(format: "正在直播:%@",programName)
            var numString:String?
            if model.playCount > 100000000 {
                numString = String(format: "%.1f亿", Double(model.playCount) / 100000000)
            } else if model.playCount > 10000 {
                numString = String(format: "%.1f万", Double(model.playCount) / 10000)
            } else {
                numString = "\(model.playCount)"
            }
            self.numLabel.text = numString
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
