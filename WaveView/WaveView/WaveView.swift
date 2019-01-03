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
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        path.lineWidth = 20
        path.stroke()
        let layerT = CAShapeLayer()
        layerT.path = path.cgPath
        layer.mask = layerT
    }
}
