//
//  Card.swift
//  CardView
//
//  Created by Juan Manuel Abrigo on 10/13/15.
//  Copyright © 2015 Lateral View. All rights reserved.
//

import UIKit

class Card: UIView {

    @IBOutlet weak private var contentView:UIView!
    @IBOutlet weak var textLabel:UILabel!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("Card", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.addSubview(contentView)
    }

}
