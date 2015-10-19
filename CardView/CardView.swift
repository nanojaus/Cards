//
//  CardView.swift
//  CardView
//
//  Created by Juan Manuel Abrigo on 10/19/15.
//  Copyright © 2015 Lateral View. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBOutlet weak private var contentView:UIView!
    var elements:NSMutableArray!
    @IBOutlet var scroll:UIScrollView!
    let cardW:CGFloat = 140.0
    let cardH:CGFloat = 220.0
    
    @IBOutlet var aCardView: Card!
    
    var leftRect: CGRect = CGRectZero
    var rightRect: CGRect = CGRectZero
    var centerRect: CGRect = CGRectZero
    var cardRect: CGRect = CGRectZero
    var currentPosition = -1
    var open = false
    
    var stack:NSMutableArray!
    var indexStack = 0
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("CardView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.addSubview(contentView)
        cardRect = self.aCardView.frame
        
        rightRect = CGRectMake(self.scroll.frame.size.width-50, self.scroll.frame.origin.y, 50, self.scroll.frame.size.height)
        
        leftRect = CGRectMake(0, self.scroll.frame.origin.y, 50, self.scroll.frame.size.height)
        centerRect = CGRectMake(50, self.scroll.frame.origin.y, self.scroll.frame.size.width-100, self.scroll.frame.size.height)
    }
    
    func setup(cards: NSMutableArray, stackCards: NSMutableArray){
        elements = cards
        stack = stackCards
        self.setupScroll()
        self.addACard()
    }

    private func setupScroll(){
        
        for var index = 0; index < elements.count; ++index {
            let card = self.scroll.viewWithTag(index+1000)
            if card != nil {
                card?.removeFromSuperview()
            }
        }
        
        
        for var index = 0; index < elements.count; ++index {
            
            let position:CGFloat = cardW * CGFloat(index)
            let card = Card(frame: CGRectMake(position, 0, cardW, cardH))
            card.textLabel.text = elements[index] as? String
            card.layer.borderColor = UIColor.blackColor().CGColor
            card.layer.borderWidth = 2
            card.tag = 1000 + index
            
            scroll.addSubview(card)
        }
        
        scroll.contentSize = CGSizeMake(cardW * CGFloat(elements.count), cardH)
    }
    
    private func indexForItemAtPoint(point: CGPoint)->Int{
        let x = scroll.contentOffset.x + point.x
        return Int(x/cardW)
    }
    
    func pan(rec:UIPanGestureRecognizer) {
        
        let p:CGPoint = rec.locationInView(self)
        let index = self.indexForItemAtPoint(p)
        
        switch rec.state {
        case .Began:
            print("began")
            self.aCardView.center = p
            
        case .Changed:
            self.aCardView.center = p
            var moveTo = index
            if isOver(self.rightRect, over: self.aCardView) {
                moveTo = index < elements.count ? index+1: index
            }
            if isOver(self.leftRect, over: self.aCardView) {
                moveTo = index > 0 ? index-1: index
            }
            
            let newRect = CGRectMake(CGFloat(moveTo) * cardW, 0, cardW, cardH)
            self.scroll.scrollRectToVisible(newRect, animated: true)
            
            if isOver(centerRect, over: self.aCardView){
                print("Item:")
                print(index)
                
                if currentPosition != index {
                    if open {
                        self.returnSpaceForItem(index)
                        self.generateSpaceForItem(index+1)
                    }else{
                        self.generateSpaceForItem(index+1)
                    }
                    currentPosition = index
                }
                
            }else{
                self.returnSpaceForItem(index+1)
                currentPosition = -1
            }
            
            
        case .Ended:
            print("ended")
            self.aCardView.center = p
            
            
            
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                //--
                self.aCardView.frame.origin.x = (CGFloat(index+1) * self.cardW) - self.scroll.contentOffset.x
                self.aCardView.frame.origin.y = self.scroll.frame.origin.y
                }, completion: { (completed) -> Void in
                    //--
                    self.elements.insertObject(self.aCardView.textLabel.text!, atIndex: index+1)
                    self.setupScroll()
                    self.aCardView.removeFromSuperview()
                    
                    
                    self.addACard()
                    
            })
            
        case .Possible:
            print("possible")
        case .Cancelled:
            print("cancelled")
        case .Failed:
            print("failed")
        }
    }
    
    private func isOver(origin: CGRect, over: UIView) -> Bool {
        if (over.center.x > origin.origin.x && over.center.x < origin.origin.x + origin.size.width) && (over.center.y > origin.origin.y && over.center.y < origin.origin.y + origin.size.height){
            return true
        }
        return false
    }
    
    private func returnSpaceForItem(item: Int){
        for var index = item; index < elements.count; ++index {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                //--
                let newX = CGFloat(index) * self.cardW //- self.cardW
                let card = self.scroll.viewWithTag(index+1000)
                card?.frame = CGRectMake(newX, (card?.frame.origin.y)!, self.cardW, self.cardH)
                
                }, completion: { (completed) -> Void in
                    //--
                    
            })
        }
        open = false
    }
    
    private func generateSpaceForItem(item: Int){
        
        for var index = item; index < elements.count; ++index {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                //--
                let newX = CGFloat(index) * self.cardW + self.cardW
                let card = self.scroll.viewWithTag(index+1000)
                card?.frame = CGRectMake(newX, (card?.frame.origin.y)!, self.cardW, self.cardH)
                
                }, completion: { (completed) -> Void in
                    //--
                    
            })
        }
        open = true
    }
    
    private func addACard(){
        
        if indexStack < stack.count {
            self.aCardView = Card(frame: self.cardRect)
            self.aCardView.textLabel.text = stack[indexStack] as? String
            self.aCardView.layer.borderColor = UIColor.blackColor().CGColor
            self.aCardView.layer.borderWidth = 2
            self.addSubview(self.aCardView)
            let pan = UIPanGestureRecognizer(target:self, action:"pan:")
            pan.maximumNumberOfTouches = 1
            pan.minimumNumberOfTouches = 1
            self.aCardView.addGestureRecognizer(pan)
            
            ++indexStack
        }
        
    }

}
