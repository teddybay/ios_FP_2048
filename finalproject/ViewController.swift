//
//  ViewController.swift
//  finalproject
//
//  Created by 陳伯墉 on 2019/1/12.
//  Copyright © 2019年 00457006. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    @IBOutlet weak var GifView: UIImageView!
    @IBAction func startGameButtonTapped(_ sender : UIButton) {
        let game = NumberTileGameViewController(dimension: 4, threshold: 2048)
        self.present(game, animated: true, completion: nil)
    }
}
