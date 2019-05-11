//
//  LBFMRadioSquareResultsCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/27.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
/// 添加cell点击代理方法
protocol LBFMRadioSquareResultsCellDelegate:NSObjectProtocol {
    func radioSquareResultsCellItemClick(url:String,title:String)
}

class LBFMRadioSquareResultsCell: UICollectionViewCell {
    weak var delegate : LBFMRadioSquareResultsCellDelegate?
    
    private var radioSquareResults:[LBFMRadioSquareResultsModel]?
    // 懒加载九宫格分类按钮
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width:LBFMScreenWidth/5, height:self.frame.size.height)
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(LBFMRadioSquareCell.self, forCellWithReuseIdentifier:"LBFMRadioSquareCell")
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.left.right.height.width.equalToSuperview()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var radioSquareResultsModel : [LBFMRadioSquareResultsModel]? {
        didSet {
            guard let model = radioSquareResultsModel else {return}
            self.radioSquareResults = model
            self.collectionView.reloadData()
        }
    }
}

extension LBFMRadioSquareResultsCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.radioSquareResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LBFMRadioSquareCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LBFMRadioSquareCell", for: indexPath) as! LBFMRadioSquareCell
        cell.backgroundColor = UIColor.white
        cell.radioSquareModel = self.radioSquareResults?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uriString:String = (self.radioSquareResults?[indexPath.row].uri)!
        let title :String = (self.radioSquareResults?[indexPath.row].title)!
        let url = getUrlAPI(url: uriString)
        delegate?.radioSquareResultsCellItemClick(url: url,title:title)
    }
    
    func getUrlAPI(url:String) -> String {
        // 判断是否有参数
        if !url.contains("?") {
            return ""
        }
        var params = [String: Any]()
        // 截取参数
        let split = url.split(separator: "?")
        let string = split[1]
        // 判断参数是单个参数还是多个参数
        if string.contains("&") {
            // 多个参数，分割参数
            let urlComponents = string.split(separator: "&")
            // 遍历参数
            for keyValuePair in urlComponents {
                // 生成Key/Value
                let pairComponents = keyValuePair.split(separator: "=")
                let key:String = String(pairComponents[0])
                let value:String = String(pairComponents[1])
                
                params[key] = value
            }
        } else {
            // 单个参数
            let pairComponents = string.split(separator: "=")
            // 判断是否有值
            if pairComponents.count == 1 {
                return "nil"
            }
            
            let key:String = String(pairComponents[0])
            let value:String = String(pairComponents[1])
            params[key] = value as AnyObject
        }
        guard let api = params["api"] else{return ""}
        return api as! String
    }
}
