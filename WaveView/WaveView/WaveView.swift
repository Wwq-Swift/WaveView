//
//  WaveView.swift
//  WaveView
//
//  Created by 王伟奇 on 2019/1/3.
//  Copyright © 2019 王伟奇. All rights reserved.
//

import UIKit
/// 水波纹的视图
class WaveView: UIView {
    
    // 当前波浪上升高度Y
    var currentWavePointY: CGFloat = 0.0
    // 波纹振幅     默认:0
    var waveAmplitude: CGFloat = 0
    // 波纹周期     默认:1.29 * M_PI
    var waveCycle: CGFloat = 0
    var waveSpeed: CGFloat = 0.2/CGFloat.pi// 波纹速度     默认:0.2/M_PI
    var waveGrowth: CGFloat = 1.00// 波纹上升速度  默认:1.00
    
    var waveDisplaylink: CADisplayLink?
    var firstWaveLayer: CAShapeLayer?//里层
    var secondWaveLayer: CAShapeLayer?//外层
    var gradientLayer: CAGradientLayer?// 绘制渐变1
    var sGradientLayer: CAGradientLayer?// 绘制渐变2
    var textLayer: CATextLayer?
    
    var waterWaveWidth: CGFloat = 160.0// 宽度
    var offsetX: CGFloat = 0.0// 波浪x位移
    var kExtraHeight: CGFloat = 0.0     // 保证水波波峰不被裁剪，增加部分额外的高度
    var variable: CGFloat = 0.2/CGFloat.pi// 可变参数 更加真实 模拟波纹
    var increase: Bool = false// 增减变化
    
    /// 波浪的layer
    var waveSinLayer: CAShapeLayer!
    
    var phrase: CGFloat = 0
    
    var waveView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.blue
        
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.yellow
        buildWaveShapeLayer()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        waveView.frame = bounds
        addSubview(waveView)
        let displayLink = CADisplayLink(target: self, selector: #selector(updateUI))
        displayLink.add(to: RunLoop.current, forMode: .common)
    }
    
    /// 更新UI
    @objc private func updateUI() {
        //不断的去变化self.phase,达到初像不段变化的目的/
        let scale = self.bounds.size.width / 200.0
//        phase += 5.0*scale
        phrase += 0.05
        //然后把path添加给当前的layer/
        waveSinLayer.path = updatePath().cgPath
    }
    
    private func updatePath() -> UIBezierPath {
        let path = UIBezierPath()
        let width = bounds.width
//        let height = bounds.width
//        var lastX = 0
        
        for x in 0...Int(width) {
            /// 这里可以控制 整个 郑玄图的左右偏移量
            let offSetX = 0.05*CGFloat(x) + phrase
            let y = 20*sin(offSetX) - 20
            
            /// 0 是开始划线的起点，  后面是h划线的描述点
            if x == 0 {
                path.move(to: CGPoint(x: CGFloat(x), y: y))
            } else {
                path.addLine(to: CGPoint(x: CGFloat(x), y: y))
            }
        }
        
//        path.addLine(to: CGPoint(x: 0, y: ))
        
        return path
    }
    
    private func buildWaveShapeLayer() {
        let waveLayer = CAShapeLayer()
        let scale = bounds.size.width / 200
        waveLayer.frame = CGRect(x: 0, y: bounds.size.height-10*scale, width: bounds.size.width, height: bounds.size.height)
        waveLayer.backgroundColor = UIColor.clear.cgColor
        waveSinLayer = waveLayer
//        layer.addSublayer(waveSinLayer)
        waveView.layer.mask = waveSinLayer
    }
    
    private func createAnimation() {
        let position = CGPoint(x: waveSinLayer.position.x, y: 20)//(1.5-self.progress)*self.bounds.size.height)
        let fromPosition = waveSinLayer.position
        waveSinLayer.position = position
        
    }
    
    func startWave() {
        if firstWaveLayer == nil {
            firstWaveLayer = CAShapeLayer()
        }
    }
    
    
    /// build 一层波纹
    func buildFirstWaveLayerPath() {
        /// 获取绘制图片上下文
         UIGraphicsBeginImageContext(CGSize(width: bounds.width, height: bounds.width))
        let path = UIBezierPath()
        
        /// 用于记录对应x 对应的y 值
        var y = currentWavePointY
        path.move(to: CGPoint(x: 0, y: currentWavePointY + waveAmplitude))
        for x in 0..<Int(waterWaveWidth) {
            /// 波浪公式， 采用 sin 的函数
            y = currentWavePointY + waveAmplitude * (sin(waveCycle * CGFloat(x) + offsetX) + 1.0)
            path.move(to: CGPoint(x: CGFloat(x), y: y))
        }
        path.addLine(to: CGPoint(x: waterWaveWidth, y: frame.height))
        path.close()
        
        firstWaveLayer?.path = path.cgPath
        UIGraphicsEndImageContext()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 40)
        UIColor.red.setStroke()
        
        path.lineWidth = 1
        path.stroke()
        let layerT = CAShapeLayer()
        layerT.path = path.cgPath
        layer.mask = layerT
    }
}
