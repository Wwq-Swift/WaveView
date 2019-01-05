//
//  ViewController.swift
//  WaveView
//
//  Created by 王伟奇 on 2019/1/3.
//  Copyright © 2019 王伟奇. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    let v = WaveView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

    let v = WQWaveView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        v.center = view.center
        view.addSubview(v)
//        v.progress = 0.5
        
        var count = 0
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            count += 1
            if count >= 100 {
                count = 0
            } else {
                self.v.progress = CGFloat(count) / 100
            }
        }
        v.startLoadView()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

