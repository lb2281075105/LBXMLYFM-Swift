//
//  LBFMPlayDetailProgramCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMPlayDetailProgramCell: UITableViewCell {

    // 序号
    private lazy var numLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    // 标题
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    // 播放图标
    private lazy var playImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sound_playtimes_14x14_")
        return imageView
    }()
    // 播放数量
    private lazy var playCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    // 评论图标
    private lazy var commentImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sound_comments_9x8_")
        return imageView
    }()
    // 评论数量
    private lazy var commentNumLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    // 时长图标
    private lazy var timeImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "feed_later_duration_14x14_")
        return imageView
    }()
    // 时长
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    // 日期
    private lazy var dateLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    // 下载按钮
    private lazy var downloadBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "downloadAlbum_30x30_"), for: UIControl.State.normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    func setUpLayout(){
        self.addSubview(self.numLabel)
        self.numLabel.text = "2"
        self.numLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.text = "金瓶梅第三回"
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.numLabel.snp.right).offset(10)
            make.top.equalTo(10)
            make.width.equalTo(240)
            make.height.equalTo(40)
        }
        self.addSubview(self.playImage)
        self.playImage.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.bottom.equalTo(-15)
            make.width.height.equalTo(17)
        }
        self.addSubview(self.playCountLabel)
        self.playCountLabel.text = "175.4万"
        self.playCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.playImage.snp.right).offset(2)
            make.width.equalTo(50)
            make.height.equalTo(20)
            make.bottom.equalTo(-12)
        }
        self.addSubview(self.commentImage)
        self.commentImage.snp.makeConstraints { (make) in
            make.left.equalTo(self.playCountLabel.snp.right).offset(8)
            make.bottom.equalTo(self.playImage)
            make.width.height.equalTo(14)
        }
        self.addSubview(self.commentNumLabel)
        self.commentNumLabel.text = "350"
        self.commentNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.commentImage.snp.right).offset(2)
            make.width.height.bottom.equalTo(self.playCountLabel)
        }
        self.addSubview(self.timeImage)
        self.timeImage.snp.makeConstraints { (make) in
            make.left.equalTo(self.commentNumLabel.snp.right).offset(8)
            make.width.height.equalTo(self.commentImage)
            make.bottom.equalTo(self.playImage)
        }
        self.addSubview(self.timeLabel)
        self.timeLabel.text = "10:47"
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.timeImage.snp.right).offset(2)
            make.width.height.bottom.equalTo(self.playCountLabel)
        }
        
        self.addSubview(self.dateLabel)
        self.dateLabel.text = "2017-12"
        self.dateLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(80)
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(15)
        }
        
        self.addSubview(self.downloadBtn)
        self.downloadBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(30)
        }
    }
    
    var playDetailTracksList:LBFMPlayDetailTracksListModel?{
        didSet{
            guard let model = playDetailTracksList else {return}
            self.titleLabel.text = model.title
            self.commentNumLabel.text = "\(model.comments)"
            
            let time = getMMSSFromSS(duration: model.duration)
            self.timeLabel.text = time
            
            var tagString:String?
            if model.playtimes > 100000000 {
                tagString = String(format: "%.1f亿", Double(model.playtimes) / 100000000)
            } else if model.playtimes > 10000 {
                tagString = String(format: "%.1f万", Double(model.playtimes) / 10000)
            } else {
                tagString = "\(model.playtimes)"
            }
            self.playCountLabel.text = tagString
        }
    }
    
    var indexPath:IndexPath? {
        didSet {
            let num:Int = (indexPath?.row)!
            self.numLabel.text = "\(num)"
        }
    }
    
    func getMMSSFromSS(duration:Int)->(String){
        let str_minute = duration / 60
        let str_second = duration % 60
        let format_time = "\(str_minute):\(str_second)"
        return format_time
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
