//
//  LBFMOneKeyListenLTCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMOneKeyListenLTCell: UITableViewCell {
    // 竖线
    var lineView:UIView = {
        let view = UIView()
        view.backgroundColor = LBFMButtonColor
        view.isHidden = true
        return view
    }()
    // 名字
    var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    func setUpLayout(){
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(4)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(30)
            make.left.equalTo(self.lineView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    var channelClassInfo: ChannelClassInfoModel? {
        didSet {
            guard let model = channelClassInfo else {return}
            self.titleLabel.text = model.className
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
