//
//  ViewController.swift
//  CardView
//
//  Created by Juan Manuel Abrigo on 10/13/15.
//  Copyright © 2015 Lateral View. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var elements:NSMutableArray!
    @IBOutlet var cardView: CardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        elements = ["0","1","2","3","4","5","6","7","8"]
        cardView.setup(elements, stackCards: ["A", "B", "C", "D", "E"])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

