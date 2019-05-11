//
//  LBFMPlayCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import StreamingKit

class LBFMPlayCell: UICollectionViewCell {
    var playUrl:String?
    var timer: Timer?
    var displayLink: CADisplayLink?
    // 是否是第一次播放
    private var isFirstPlay:Bool = true
    // 音频播放器
    private lazy var audioPlayer:STKAudioPlayer={
        let audioPlayer = STKAudioPlayer()
        
        return audioPlayer
    }()
    // 标题
    private var titleLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    // 图片
    private var imageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 弹幕按钮
    private lazy var barrageBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "NPProDMOff_24x24_"), for: UIControl.State.normal)
        return button
    }()
    // 播放机器按钮
    private lazy var machineBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "npXPlay_30x30_"), for: UIControl.State.normal)
        return button
    }()
    // 设置按钮
    private lazy var setBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "NPProSet_25x24_"), for: UIControl.State.normal)
        return button
    }()
    // 进度条
    private lazy var slider:UISlider = {
        let slider = UISlider(frame: CGRect.zero)
        slider.setThumbImage(UIImage(named: "playProcessDot_n_7x16_"), for: .normal)
        slider.maximumTrackTintColor = UIColor.lightGray
        slider.minimumTrackTintColor = LBFMButtonColor
        // 滑块滑动停止后才触发ValueChanged事件
        //        slider.isContinuous = false
        
        slider.addTarget(self, action: #selector(LBFMPlayCell.change(slider:)), for: UIControl.Event.valueChanged)
        
        slider.addTarget(self, action: #selector(LBFMPlayCell.sliderDragUp(sender:)), for: UIControl.Event.touchUpInside)
        return slider
    }()
    // 当前时间
    private lazy var currentTime:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = LBFMButtonColor
        return label
    }()
    // 总时间
    private lazy var totalTime:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = LBFMButtonColor
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    // 播放暂停按钮
    private lazy var playBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "toolbar_play_n_p_78x78_"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(playBtn(button:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    // 上一曲按钮
    private lazy var prevBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "toolbar_prev_n_p_24x24_"), for: UIControl.State.normal)
        return button
    }()
    
    // 下一曲按钮
    private lazy var nextBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "toolbar_next_n_p_24x24_"), for: UIControl.State.normal)
        return button
    }()
    // 消息列表按钮
    private lazy var msgBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "playpage_icon_list_24x24_"), for: UIControl.State.normal)
        return button
    }()
    // 定时按钮
    private lazy var timingBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "playpage_icon_timing_24x24_"), for: UIControl.State.normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    
    func setUpUI(){
        // 标题
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        // 图片
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
            make.height.equalTo(LBFMScreenHeight * 0.7 - 260)
        }
        // 弹幕按钮
        self.addSubview(self.barrageBtn)
        self.barrageBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(self.imageView.snp.bottom).offset(20)
            make.height.width.equalTo(30)
        }
        // 设置按钮
        self.addSubview(self.setBtn)
        self.setBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(self.imageView.snp.bottom).offset(20)
            make.height.width.equalTo(30)
        }
        // 播放机器按钮
        self.addSubview(self.machineBtn)
        self.machineBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.setBtn.snp.left).offset(-20)
            make.top.equalTo(self.imageView.snp.bottom).offset(20)
            make.height.width.equalTo(30)
        }
        // 进度条
        self.addSubview(self.slider)
        self.slider.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-90)
        }
        // 当前时间
        self.addSubview(self.currentTime)
        self.currentTime.text = "00:00"
        self.currentTime.snp.makeConstraints { (make) in
            make.left.equalTo(self.slider)
            make.top.equalTo(self.slider.snp.bottom).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        // 总时间
        self.addSubview(self.totalTime)
        self.totalTime.text = "21:33"
        self.totalTime.snp.makeConstraints { (make) in
            make.right.equalTo(self.slider)
            make.top.equalTo(self.slider.snp.bottom).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        // 播放暂停按钮
        self.addSubview(self.playBtn)
        self.playBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.height.width.equalTo(60)
            make.centerX.equalToSuperview()
        }
        // 上一曲按钮
        self.addSubview(self.prevBtn)
        self.prevBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.playBtn.snp.left).offset(-30)
            make.height.width.equalTo(25)
            make.centerY.equalTo(self.playBtn)
        }
        // 下一曲按钮
        self.addSubview(self.nextBtn)
        self.nextBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.playBtn.snp.right).offset(30)
            make.height.width.equalTo(25)
            make.centerY.equalTo(self.playBtn)
        }
        // 消息列表按钮
        self.addSubview(self.msgBtn)
        self.msgBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalToSuperview().offset(-20)
            make.height.width.equalTo(40)
        }
        // 定时按钮
        self.addSubview(self.timingBtn)
        self.timingBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalToSuperview().offset(-20)
            make.height.width.equalTo(40)
        }
    }
    
    var playTrackInfo:LBFMPlayTrackInfo?{
        didSet{
            guard let model = playTrackInfo else {return}
            self.titleLabel.text = model.title
            self.imageView.kf.setImage(with: URL(string: model.coverLarge!))
            self.totalTime.text = getMMSSFromSS(duration: model.duration)
            self.playUrl = model.playUrl64
        }
    }
    
    func getMMSSFromSS(duration:Int)->(String){
        var min = duration / 60
        let sec = duration % 60
        var hour : Int = 0
        if min >= 60 {
            hour = min / 60
            min = min % 60
            if hour > 0 {
                return String(format: "%02d:%02d:%02d", hour, min, sec)
            }
        }
        return String(format: "%02d:%02d", min, sec)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func playBtn(button:UIButton){
        button.isSelected = !button.isSelected
        if button.isSelected {
            button.setImage(UIImage(named: "toolbar_pause_n_p_78x78_"), for: UIControl.State.normal)
            if isFirstPlay {
                self.audioPlayer.play(URL(string: self.playUrl!)!)
                starTimer()
                isFirstPlay = false
            }else {
                starTimer()
                self.audioPlayer.resume()
            }
        }else{
            button.setImage(UIImage(named: "toolbar_play_n_p_78x78_"), for: UIControl.State.normal)
            removeTimer()
            self.audioPlayer.pause()
        }
        
    }
    
    func starTimer() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateCurrentLabel))
//        displayLink?.add(to: RunLoop.current, forMode: .RunLoop.Mode.common)
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    func removeTimer() {
        displayLink?.invalidate()
        displayLink = nil
    }
}

extension LBFMPlayCell{
    @objc func setUpTimesView() {
        let currentTime:Int = Int(self.audioPlayer.progress)
        self.currentTime.text = getMMSSFromSS(duration: currentTime)
        let progress = Float(self.audioPlayer.progress / self.audioPlayer.duration)
        slider.value = progress
    }
    @objc func updateCurrentLabel() {
        let currentTime:Int = Int(self.audioPlayer.progress)
        self.currentTime.text = getMMSSFromSS(duration: currentTime)
        let progress = Float(self.audioPlayer.progress / self.audioPlayer.duration)
        slider.value = progress
    }
    @objc func change(slider:UISlider) {
        print("slider.value = %d",slider.value)
        audioPlayer.seek(toTime: Double(slider.value * Float(self.audioPlayer.duration)))
    }
    
    @objc func sliderDragUp(sender: UISlider) {
        print("value:(sender.value)")
    }
}
