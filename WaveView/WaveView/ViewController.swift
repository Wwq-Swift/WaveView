//
//  ViewController.swift
//  WaveView
//
//  Created by 王伟奇 on 2019/1/3.
//  Copyright © 2019 王伟奇. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let v = WaveView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

    override func viewDidLoad() {
        super.viewDidLoad()
        v.center = view.center
        view.addSubview(v)
        // Do any additional setup after loading the view, typically from a nib.
    }


}

