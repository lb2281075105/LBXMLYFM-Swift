//
//  LBFMClassifySubRecommendController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/5.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMClassifySubRecommendController: UIViewController {
    // - 上页面传过来请求接口必须的参数
    private var categoryId: Int = 0
    convenience init(categoryId:Int = 0) {
        self.init()
        self.categoryId = categoryId
    }
    private let LBFMClassifySubHeaderViewID = "LBFMClassifySubHeaderView"
    private let LBFMClassifySubFooterViewID = "LBFMClassifySubFooterView"
    
    private let LBFMClassifySubHeaderCellID = "LBFMClassifySubHeaderCell"
    private let LBFMClassifySubHorizontalCellID = "LBFMClassifySubHorizontalCell"
    private let LBFMClassifySubVerticalCellID = "LBFMClassifySubVerticalCell"
    private let LBFMClassifySubModuleType20CellID = "LBFMClassifySubModuleType20Cell"
    private let LBFMClassifySubModuleType19CellID = "LBFMClassifySubModuleType19Cell"
    private let LBFMClassifySubModuleType17CellID = "LBFMClassifySubModuleType17Cell"
    private let LBFMClassifySubModuleType4CellID = "LBFMClassifySubModuleType4Cell"
    private let LBFMClassifySubModuleType16CellID = "LBFMClassifySubModuleType16Cell"
    private let LBFMClassifySubModuleType23CellID = "LBFMClassifySubModuleType23Cell"
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collection = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        // - 注册头视图和尾视图
        collection.register(LBFMClassifySubHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LBFMClassifySubHeaderViewID)
        collection.register(LBFMClassifySubFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LBFMClassifySubFooterViewID)
        
        // - 注册不同分区cell
        collection.register(LBFMClassifySubHeaderCell.self, forCellWithReuseIdentifier: LBFMClassifySubHeaderCellID)
        collection.register(LBFMClassifySubHorizontalCell.self, forCellWithReuseIdentifier: LBFMClassifySubHorizontalCellID)
        collection.register(LBFMClassifySubVerticalCell.self, forCellWithReuseIdentifier: LBFMClassifySubVerticalCellID)
        collection.register(LBFMClassifySubModuleType20Cell.self, forCellWithReuseIdentifier: LBFMClassifySubModuleType20CellID)
        collection.register(LBFMClassifySubModuleType19Cell.self, forCellWithReuseIdentifier: LBFMClassifySubModuleType19CellID)
        collection.register(LBFMClassifySubModuleType17Cell.self, forCellWithReuseIdentifier: LBFMClassifySubModuleType17CellID)
        collection.register(LBFMClassifySubModuleType4Cell.self, forCellWithReuseIdentifier: LBFMClassifySubModuleType4CellID)
        collection.register(LBFMClassifySubModuleType16Cell.self, forCellWithReuseIdentifier: LBFMClassifySubModuleType16CellID)
        collection.register(LBFMClassifySubModuleType23Cell.self, forCellWithReuseIdentifier: LBFMClassifySubModuleType23CellID)
        collection.uHead = URefreshHeader{ [weak self] in self?.loadRecommendData() }
        
        return collection
    }()
    
    
    lazy var viewModel: LBFMClassifySubRecommendViewModel = {
        return LBFMClassifySubRecommendViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        self.collectionView.uHead.beginRefreshing()
        loadRecommendData()
    }
    
    func loadRecommendData(){
        viewModel.categoryId = self.categoryId
        // 加载数据
        viewModel.updataBlock = { [unowned self] in
            self.collectionView.uHead.endRefreshing()
            // 更新列表数据
            self.collectionView.reloadData()
        }
        viewModel.refreshDataSource()
    }
}

extension LBFMClassifySubRecommendController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections(collectionView:collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsIn(section: section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardClass = viewModel.classifyCategoryContentsList?[indexPath.section].cardClass
        let moduleType = viewModel.classifyCategoryContentsList?[indexPath.section].moduleType
        if moduleType == 14 {
            let cell:LBFMClassifySubHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubHeaderCellID, for: indexPath) as! LBFMClassifySubHeaderCell
            cell.focusModel = viewModel.focus
            cell.classifyCategoryContentsListModel = viewModel.classifyCategoryContentsList?[indexPath.section]
            return cell
        }else if moduleType == 3 {
            if cardClass == "horizontal" {
                let cell:LBFMClassifySubHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubHorizontalCellID, for: indexPath) as! LBFMClassifySubHorizontalCell
                cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
                return cell
            }else {
                let cell:LBFMClassifySubVerticalCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubVerticalCellID, for: indexPath) as! LBFMClassifySubVerticalCell
                cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
                return cell
            }
        }else if moduleType == 5{
            if cardClass == "horizontal" {
                let cell:LBFMClassifySubHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubHorizontalCellID, for: indexPath) as! LBFMClassifySubHorizontalCell
                cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
                return cell
            }else {
                let cell:LBFMClassifySubVerticalCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubVerticalCellID, for: indexPath) as! LBFMClassifySubVerticalCell
                cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
                return cell
            }
        }else if moduleType == 20 {
            let cell:LBFMClassifySubModuleType20Cell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubModuleType20CellID, for: indexPath) as! LBFMClassifySubModuleType20Cell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 19 {
            let cell:LBFMClassifySubModuleType19Cell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubModuleType19CellID, for: indexPath) as! LBFMClassifySubModuleType19Cell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 17 {
            let cell:LBFMClassifySubModuleType17Cell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubModuleType17CellID, for: indexPath) as! LBFMClassifySubModuleType17Cell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 4 {
            let cell:LBFMClassifySubModuleType4Cell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubModuleType4CellID, for: indexPath) as! LBFMClassifySubModuleType4Cell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 16 {
            let cell:LBFMClassifySubModuleType16Cell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubModuleType16CellID, for: indexPath) as! LBFMClassifySubModuleType16Cell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 23{
            let cell:LBFMClassifySubModuleType23Cell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubModuleType23CellID, for: indexPath) as! LBFMClassifySubModuleType23Cell
            //            cell.classifyVerticalModel = self.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 18{
            let cell:LBFMClassifySubVerticalCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubVerticalCellID, for: indexPath) as! LBFMClassifySubVerticalCell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else {
            let cell:LBFMClassifySubVerticalCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubVerticalCellID, for: indexPath) as! LBFMClassifySubVerticalCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumId = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row].albumId ?? 0
        let vc = LBFMPlayDetailController(albumId:albumId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.insetForSectionAt(section: section)
    }
    
    // 最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumInteritemSpacingForSectionAt(section: section)
    }
    
    // 最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumLineSpacingForSectionAt(section: section)
    }
    
    // item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.referenceSizeForHeaderInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return viewModel.referenceSizeForFooterInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView : LBFMClassifySubHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LBFMClassifySubHeaderViewID, for: indexPath) as! LBFMClassifySubHeaderView
            headerView.classifyCategoryContents = viewModel.classifyCategoryContentsList?[indexPath.section]
            return headerView
        }else if kind == UICollectionView.elementKindSectionFooter {
            let footerView : LBFMClassifySubFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LBFMClassifySubFooterViewID, for: indexPath) as! LBFMClassifySubFooterView
            return footerView
        }
        return UICollectionReusableView()
    }
}
