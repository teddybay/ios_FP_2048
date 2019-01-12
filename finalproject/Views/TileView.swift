//
//  TileView.swift
//  finalproject
//
//  Created by 陳伯墉 on 2019/1/12.
//  Copyright © 2019年 00457006. All rights reserved.
//

import UIKit

/// 一個塊塊的view
class TileView : UIView {
    //塊塊中的值
    var value : Int = 0 {
        didSet {
            backgroundColor = delegate.tileColor(value)
            numberLabel.textColor = delegate.numberColor(value)
            numberLabel.text = "\(value)"
        }
    }
    
    //提供顏色選擇
    unowned let delegate : AppearanceProviderProtocol
    //一個數字塊塊就是一個label
    let numberLabel : UILabel
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(position: CGPoint, width: CGFloat, value: Int, radius: CGFloat, delegate d: AppearanceProviderProtocol) {
        delegate = d
        numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: width))
        numberLabel.textAlignment = NSTextAlignment.center
        numberLabel.minimumScaleFactor = 0.5
        numberLabel.font = delegate.fontForNumbers()
        
        super.init(frame: CGRect(x: position.x, y: position.y, width: width, height: width))
        addSubview(numberLabel)
        layer.cornerRadius = radius
        
        self.value = value
        backgroundColor = delegate.tileColor(value)
        numberLabel.textColor = delegate.numberColor(value)
        numberLabel.text = "\(value)"
    }
}
