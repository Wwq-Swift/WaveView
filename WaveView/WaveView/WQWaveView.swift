//
//  WQWaveView.swift
//  WaveView
//
//  Created by 王伟奇 on 2019/1/6.
//  Copyright © 2019 王伟奇. All rights reserved.
//

import UIKit

class WQWaveView: UIView {
    
    /// 当前进度
    public var progress : CGFloat = 0 {
        didSet {
            if progress > 1.0 {
                return
            }
            creatAnimation()
        }
    }
    
    //水浪颜色,默认为浅蓝色
    public var waveColor : UIColor? {
        didSet {
            waveSinView.backgroundColor = waveColor
        }
    }
    
    //字体颜色,默认为白色
    public var textColor : UIColor? {
        didSet {
            percentL.textColor = textColor
        }
    }
    
    //字体大小,默认为系统默认大小
    public var textFont : UIFont? {
        didSet {
            percentL.font = textFont
        }
    }
    
    public func startLoadView() {
        setupView()
    }
    
    private var phase: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(waveSinView)
        waveSinView.layer.mask = waveSinLayer
        let minRadius = min(bounds.size.width, bounds.size.height)
        layer.cornerRadius = minRadius/2
        layer.masksToBounds = true
        addSubview(percentL)
        /// displayLink 作为定时器，
        let displayLink = CADisplayLink.init(target: self, selector: #selector(updateUI))
        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    @objc private func updateUI(){
        let scale = bounds.size.width / 200.0
        phase += 5.0*scale
        waveSinLayer.path = path().cgPath
    }
    
    /// 画波浪的path
    private func path() -> UIBezierPath{
        let path = UIBezierPath()
        let width = bounds.size.width
        let height = bounds.size.width
        var lastX = 0
        
        for x in 0...Int(width) {
            /// 主要来控制波浪的 弧度     波浪的速度
            let a = 2*Double.pi/Double(width)*Double(x)*0.8+Double(phase)*2*Double.pi/Double(width)
            /// 通过sin 的正选函数图来形成波浪。x 对应的Y 值
            let y = Double(height)*0.05*sin(a) //+ Double(height)*0.05
            if x == 0 {
                path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
            }
            else{
                path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
            }
            lastX = x
            
            if progress < 1.0 {
                percentL.center = CGPoint(x: bounds.size.width/2, y: waveSinLayer.position.y-bounds.size.height/2+CGFloat(y)/2)
            }
            else {
                percentL.center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2+CGFloat(y)/2)
            }
        }
        /// 头部点。和尾部点 往下延伸。  使整个底部为 蓝色 部分
        path.addLine(to: CGPoint(x: CGFloat(lastX), y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        return path
    }
    
    /// 开始动画  （改变 waveLayer 的position。 通过改变progress 从而改变 自己的位置。）
    private func creatAnimation()  {
        let position = CGPoint(x: waveSinLayer.position.x, y: (1.5-progress)*bounds.size.height)
        let fromPosition = waveSinLayer.position
        waveSinLayer.position = position
        let animation = CABasicAnimation.init(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: fromPosition)
        animation.toValue = NSValue(cgPoint: position)
        animation.duration = 0.25
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        waveSinLayer.add(animation, forKey:nil)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.percentL.center = CGPoint(x: self.bounds.size.width/2, y: self.waveSinLayer.position.y-self.bounds.size.height/2)
        }) { (finished) in
            self.percentL.text = String(format: "%.f%@", arguments: [self.progress*100,"%"])
        }
    }
    
    /// 波浪的layer 层
    private lazy var waveSinLayer: CAShapeLayer = {
        let waveSinLayer = CAShapeLayer()
        waveSinLayer.frame = CGRect(x: 0, y: bounds.size.height,
                                    width: bounds.size.width,
                                    height: bounds.size.height)
        waveSinLayer.backgroundColor = UIColor.clear.cgColor
        return waveSinLayer
    }()
    
    /// 显示 底部海水颜色的view
    private lazy var waveSinView: UIView = {
        let waveSinView = UIView()
        waveSinView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        waveSinView.backgroundColor = UIColor(red: 41/255.0, green: 240/255.0, blue: 253/255.0, alpha: 0.8)
        return waveSinView
    }()
    
    private lazy var percentL: UILabel = {
        let percentL = UILabel()
        percentL.textColor = .white
        percentL.backgroundColor = .clear
        percentL.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 30)
        percentL.textAlignment = .center
        percentL.center = CGPoint(x: bounds.size.width/2, y: bounds.size.height - 10)
        percentL.text = String(format: "%.f%@", arguments: [progress*100,"%"])
        return percentL
    }()
    
}
