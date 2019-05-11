//
//  LBFMPlayContentIntroCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMPlayContentIntroCell: UITableViewCell {
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "内容简介"
        return label
    }()
    // 内容详情
    private lazy var subLabel:LBFMCustomLabel = {
        let label = LBFMCustomLabel()
        label.numberOfLines = 0
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }

    func setUpUI(){
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        self.addSubview(self.subLabel)
        self.subLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.bottom.right.equalToSuperview().offset(-15)
        }
    }
    
    var playDetailAlbumModel:LBFMPlayDetailAlbumModel? {
        didSet{
            guard let model = playDetailAlbumModel else {return}
            self.subLabel.text = model.shortIntro
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
