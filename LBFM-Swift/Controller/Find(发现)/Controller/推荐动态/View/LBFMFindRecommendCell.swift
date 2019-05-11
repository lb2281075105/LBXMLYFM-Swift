//
//  LBFMFindRecommendCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/2.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMFindRecommendCell: UITableViewCell {
    private var findRecommendSteam:LBFMFindRStreamList?
    
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
    // 言论
    lazy var desLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    // 日期
    lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        return label
    }()
    // 赞
    lazy var zanLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        return label
    }()
    lazy var zanImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 评论
    lazy var commnetLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var commentImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(LBFMFindRecommendPicCell.self, forCellWithReuseIdentifier:"LBFMFindRecommendPicCell")
        
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    func setUpLayout(){
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
        self.nameLabel.text = "喜马拉雅好声音"
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.picView.snp.right).offset(8)
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.centerY.equalTo(self.picView)
        }
        
        self.addSubview(self.desLabel)
        self.desLabel.text = "啦啦啦啦啦啦啦啦四六级发送到了解放塑料袋就分手发熟练度家纺"
        self.desLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.picView)
            make.top.equalTo(self.picView.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(50)
        }
        
        self.addSubview(self.dateLabel)
        self.dateLabel.text = "一天前"
        self.dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.picView)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.commnetLabel)
        self.commnetLabel.text = "8494"
        self.commnetLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(20)
            make.width.equalTo(40)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        self.addSubview(self.commentImageView)
        self.commentImageView.image = UIImage(named: "评论")
        self.commentImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.commnetLabel.snp.left).offset(-5)
            make.centerY.equalTo(self.commnetLabel)
            make.width.height.equalTo(25)
        }
        
        self.addSubview(self.zanLabel)
        self.zanLabel.text = "20.4万"
        self.zanLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.commentImageView.snp.left).offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(20)
            make.centerY.equalTo(self.commentImageView)
        }
        
        self.addSubview(self.zanImageView)
        self.zanImageView.image = UIImage(named: "点赞")
        self.zanImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.zanLabel.snp.left).offset(-5)
            make.width.height.equalTo(20)
            make.centerY.equalTo(self.zanLabel)
        }
        
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.desLabel.snp.bottom).offset(5)
            make.height.equalTo((LBFMScreenWidth-30)/3+20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var streamModel:LBFMFindRStreamList? {
        didSet {
            guard let model = streamModel else {return}
            self.picView.kf.setImage(with: URL(string: model.avatar!))
            self.desLabel.text = model.content
            let textHeight:CGFloat = height(for: model)
            self.desLabel.snp.updateConstraints { (make) in
                make.height.equalTo(textHeight)
            }
            self.nameLabel.text = model.nickname
            self.zanLabel.text = "\(model.likesCount)"
            self.commnetLabel.text = "\(model.commentsCount)"
            
            self.dateLabel.text = updateTimeToCurrennTime(timeStamp: Double(CGFloat(model.issuedTs)))
            
            self.findRecommendSteam = model
            let picNum = self.findRecommendSteam?.picUrls?.count ?? 0
            var num:CGFloat = 0
            if picNum > 0 && picNum <= 3 {
                num = 1
            }else if picNum > 3 && picNum <= 6{
                num = 2
            }else if picNum > 6{
                num = 3
            }
            let OnePicHeight = CGFloat((LBFMScreenWidth - 30) / 3)
            let picHeight = num * OnePicHeight
            self.collectionView.snp.updateConstraints { (make) in
                make.height.equalTo(picHeight+20)
            }
            self.collectionView.reloadData()
        }
    }
    // 计算文字的高度
    func height(for commentModel: LBFMFindRStreamList?) -> CGFloat {
        var height: CGFloat = 30
        guard let model = commentModel else { return height }
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.text = model.content
        height += label.sizeThatFits(CGSize(width: LBFMScreenWidth - 30, height: CGFloat.infinity)).height
        return height
    }
    
    // - 根据后台时间戳返回几分钟前，几小时前，几天前
    func updateTimeToCurrennTime(timeStamp: Double) -> String {
        //获取当前的时间戳
        let currentTime = Date().timeIntervalSince1970
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta:TimeInterval = TimeInterval(timeStamp / 1000)
        //时间差
        let reduceTime : TimeInterval = currentTime - timeSta
        //时间差小于60秒
        if reduceTime < 60 {
            return "刚刚"
        }
        //时间差大于一分钟小于60分钟内
        let mins = Int(reduceTime / 60)
        if mins < 60 {
            return "\(mins)分钟前"
        }
        //时间差大于一小时小于24小时内
        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            return "\(hours)小时前"
        }
        //时间差大于一天小于30天内
        let days = Int(reduceTime / 3600 / 24)
        if days < 30 {
            return "\(days)天前"
        }
        //不满足上述条件---或者是未来日期-----直接返回日期
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dfmatter = DateFormatter()
        //yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
        return dfmatter.string(from: date as Date)
    }
}

extension LBFMFindRecommendCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.findRecommendSteam?.picUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LBFMFindRecommendPicCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LBFMFindRecommendPicCell", for: indexPath) as! LBFMFindRecommendPicCell
        cell.picModel = self.findRecommendSteam?.picUrls?[indexPath.row]
        return cell
    }
    
    // 每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    // 最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (LBFMScreenWidth - 30) / 3, height:(LBFMScreenWidth - 30) / 3)
    }
    
}
