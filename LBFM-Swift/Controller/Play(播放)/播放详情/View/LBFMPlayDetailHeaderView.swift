//
//  LBFMPlayDetailHeaderView.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMPlayDetailHeaderView: UIView {
    // 图片
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 毛玻璃背景
    private lazy var blurImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 标题
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    // 昵称图片
    private lazy var nickView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 昵称
    private lazy var nickLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    // 分类
    private lazy var categoryBtn:UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        return button
    }()
    // date
    private lazy var dateLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    // subscibe
    private lazy var subscibeBtn:UIButton = {
        let button = UIButton()
        button.backgroundColor = LBFMButtonColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("＋订阅", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        return button
    }()
    
    // 播放数量
    private var numLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        return label
    }()
    
    // 播放数量图片
    private var numView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "playWhite")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    func setUpUI(){
        self.blurImageView = UIImageView.init(frame:  CGRect(x:0 , y:0 , width: LBFMScreenWidth, height: self.frame.height - 80))
        self.blurImageView.image = UIImage(named: "1")
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light)) as UIVisualEffectView
        visualEffectView.frame = self.blurImageView.bounds
        //添加毛玻璃效果层
        self.blurImageView.addSubview(visualEffectView)
        self.insertSubview(self.blurImageView, belowSubview: self)
        
        self.addSubview(self.imageView)
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 5
        self.imageView.image = UIImage(named: "1")
        self.imageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(64+10)
            make.bottom.equalTo(-20)
            make.width.equalTo(120)
        }
        self.imageView.addSubview(self.numView)
        self.numView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.width.height.equalTo(18)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        self.imageView.addSubview(self.numLabel)
        self.numLabel.text = "171.9万"
        self.numLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.numView.snp.right).offset(5)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(20)
        }
        
        self.blurImageView.addSubview(self.titleLabel)
        self.titleLabel.text = "金瓶梅"
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(10)
            make.right.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        self.blurImageView.addSubview(self.nickView)
        self.nickView.image = UIImage(named: "album_ic_zhubo_14x14_")
        self.nickView.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.width.height.equalTo(25)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        self.blurImageView.addSubview(self.nickLabel)
        self.nickLabel.text = "爱心爵箩筐"
        self.nickLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nickView.snp.right).offset(5)
            make.right.equalToSuperview()
            make.height.equalTo(25)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        self.addSubview(self.categoryBtn)
        self.categoryBtn.setTitle("有声书 >", for: UIControl.State.normal)
        self.categoryBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(10)
            make.top.equalTo(self.blurImageView.snp.bottom).offset(5)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        self.addSubview(self.dateLabel)
        self.dateLabel.text = "2018-08-20更新"
        self.dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.categoryBtn)
            make.top.equalTo(self.categoryBtn.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
        self.addSubview(self.subscibeBtn)
        self.subscibeBtn.layer.masksToBounds = true
        self.subscibeBtn.layer.cornerRadius = 17
        self.subscibeBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(70)
            make.height.equalTo(34)
        }
        
    }
    
    var playDetailAlbumModel:LBFMPlayDetailAlbumModel? {
        didSet{
            guard let model = playDetailAlbumModel else {return}
            self.blurImageView.kf.setImage(with: URL(string: model.coverLarge!))
            self.imageView.kf.setImage(with: URL(string: model.coverLarge!))
            self.titleLabel.text = model.title
            self.nickLabel.text = model.nickname
            let categoryName:String = model.categoryName!
            self.categoryBtn.setTitle("\(categoryName)>", for: UIControl.State.normal)
            // updatedAt
            var tagString:String?
            if model.playTimes > 100000000 {
                tagString = String(format: "%.1f亿", Double(model.playTimes) / 100000000)
            } else if model.playTimes > 10000 {
                tagString = String(format: "%.1f万", Double(model.playTimes) / 10000)
            } else {
                tagString = "\(model.playTimes)"
            }
            self.numLabel.text = tagString
            self.dateLabel.text = updateTimeToCurrennTime(timeStamp: Double(model.updatedAt))
        }
    }
    
    // - 根据后台时间戳返回几分钟前，几小时前，几天前
    func updateTimeToCurrennTime(timeStamp: Double) -> String {
        // 时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta:TimeInterval = TimeInterval(timeStamp / 1000)
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dfmatter = DateFormatter()
        // yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat="yyyy-MM-dd更新"
        return dfmatter.string(from: date as Date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
