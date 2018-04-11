//
//  ViewController.swift
//  SNPNetwork
//
//  Created by arashzjahangiri@gmail.com on 04/08/2018.
//  Copyright (c) 2018 arashzjahangiri@gmail.com. All rights reserved.
//

import UIKit
import SNPNetwork

struct test: Codable {
    let str: String?
}
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SNPNetwork.request(url: "") { (model: test?, error: SNPError?) in
            print(model?.str! ?? "")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

