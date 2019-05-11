//
//  LBFMPlayDetailProgramController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import LTScrollView

class LBFMPlayDetailProgramController: UIViewController, LTTableViewProtocal{
    private var playDetailTracks:LBFMPlayDetailTracksModel?
    
    private let LBFMPlayDetailProgramCellID = "LBFMPlayDetailProgramCell"
    private lazy var tableView: UITableView = {
        let tableView = tableViewConfig(CGRect(x: 0, y:0, width:LBFMScreenWidth, height: LBFMScreenHeight), self, self, nil)
        tableView.register(LBFMPlayDetailProgramCell.self, forCellReuseIdentifier: LBFMPlayDetailProgramCellID)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        glt_scrollView = tableView
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    var playDetailTracksModel:LBFMPlayDetailTracksModel?{
        didSet{
            guard let model = playDetailTracksModel else {return}
            self.playDetailTracks = model
            self.tableView.reloadData()
        }
    }
}

extension LBFMPlayDetailProgramController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playDetailTracks?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LBFMPlayDetailProgramCell = tableView.dequeueReusableCell(withIdentifier: LBFMPlayDetailProgramCellID, for: indexPath) as! LBFMPlayDetailProgramCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.playDetailTracksList = self.playDetailTracks?.list?[indexPath.row]
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumId = self.playDetailTracks?.list?[indexPath.row].albumId ?? 0
        let trackUid = self.playDetailTracks?.list?[indexPath.row].trackId ?? 0
        let uid = self.playDetailTracks?.list?[indexPath.row].uid ?? 0
        let vc = LBFMNavigationController.init(rootViewController: LBFMPlayController(albumId:albumId, trackUid:trackUid, uid:uid))
        self.present(vc, animated: true, completion: nil)
    }
}


