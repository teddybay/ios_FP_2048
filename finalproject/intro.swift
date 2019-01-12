//
//  intro.swift
//  finalproject
//
//  Created by 陳伯墉 on 2019/1/13.
//  Copyright © 2019年 00457006. All rights reserved.
//

import UIKit

class intro: UIViewController {
    
    @IBOutlet weak var giff: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giff.loadGif(name: "2048")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
