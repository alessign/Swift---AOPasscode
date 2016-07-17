//
//  SetPasscodeView.swift
//  AOPasscode
//
//  Created by Ales Olasz on 15/07/2016.
//  Copyright © 2016 ViralIdeasLtd. All rights reserved.
//

import UIKit

extension Dictionary where Value: Equatable {
    
    func someKeyFor(value: Value) -> Key? {
        
        guard let index = indexOf({ $0.1 == value }) else {
            return nil
        }
        
        return self[index].0
    }
}

class SetAOPasscodeView: UIView {
    
    // source arrays
    var colorArr: Array = Array<UIColor>()
    var colorDict: Dictionary = Dictionary<String, UIColor>()
    var numberArr: Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    var passcodeArr: Array<String>!
    var tapCount = 0
    var indicatorsView: UIView!
    
    // inits
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.mainScreen().bounds)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    class func instanceFromNib() -> UIView {
       return UINib(nibName: "SetAOPasscodeView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    func setUp() {
        
        let red = UIColor(red: 192.0/255.0, green: 57.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        let yellow = UIColor(red: 255.0/255.0, green: 205.0/255.0, blue: 2.0/255.0, alpha: 1.0)
        let purple = UIColor(red: 155.0/255.0, green: 89.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        let green = UIColor(red: 22.0/255.0, green: 160.0/255.0, blue: 133.0/255.0, alpha: 1.0)
        let blue = UIColor(red: 41.0/255.0, green: 128.0/255.0, blue: 185.0/255.0, alpha: 1.0)
        let white = UIColor.whiteColor()
        let orange = UIColor(red: 230.0/255.0, green: 126.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        let brown = UIColor(red: 163.0/255.0, green: 134.0/255.0, blue: 113.0/255.0, alpha: 1.0)
        let gray = UIColor(red: 189.0/255.0, green: 195.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        let black = UIColor.blackColor()
        
        self.colorArr.append(red as UIColor)
        self.colorArr.append(yellow as UIColor)
        self.colorArr.append(purple as UIColor)
        self.colorArr.append(green as UIColor)
        self.colorArr.append(blue as UIColor)
        self.colorArr.append(white as UIColor)
        self.colorArr.append(orange as UIColor)
        self.colorArr.append(brown as UIColor)
        self.colorArr.append(gray as UIColor)
        self.colorArr.append(black as UIColor)
        
        self.colorDict["red"] = red as UIColor
        self.colorDict["yellow"] = yellow as UIColor
        self.colorDict["purple"] = purple as UIColor
        self.colorDict["green"] = green as UIColor
        self.colorDict["blue"] = blue as UIColor
        self.colorDict["white"] = white as UIColor
        self.colorDict["orange"] = orange as UIColor
        self.colorDict["brown"] = brown as UIColor
        self.colorDict["gray"] = gray as UIColor
        self.colorDict["black"] = black as UIColor
        
        //set radius for all buttons
        for view in self.subviews {
        
            if view.tag == 1001{
            
                for btn in view.subviews as! [UIButton]{
                    btn.layer.cornerRadius = 30
                    
                    if btn.tag > 0 && btn.tag < 11 {
                        // color buttons
                        btn.backgroundColor = self.colorArr[btn.tag - 1]
                    }
                    else if btn.tag > 10 && btn.tag < 21 {
                        // number buttons
                        btn.backgroundColor = UIColor.whiteColor()
                    }
                }
            }
        }
        
        self.drawIndicatorCircles()
        self.passcodeArr = [String]()
        
        // NSUSerDefaults fetch the above sequence
        
    }
    
    func drawIndicatorCircles(){
        
        let circleSize: CGFloat = 10
        let space: CGFloat = 10
        let areaSize = CGFloat(4 * circleSize) + CGFloat(3 * space)
        let frame = UIScreen.mainScreen().bounds
        let startingPoint = CGFloat((frame.width - areaSize) / 2)
        
        self.indicatorsView = UIView()
        self.indicatorsView.frame = CGRectMake(startingPoint, frame.height - 50, areaSize, circleSize)
        self.indicatorsView.backgroundColor = UIColor.clearColor()
        
        print("\(areaSize), \(frame.width), \(startingPoint)")
        
        for i in 0..<4{
            
            let circle = CAShapeLayer()
            circle.path = UIBezierPath(ovalInRect: CGRectMake((circleSize * CGFloat(i)) + (space * CGFloat(i)), 0, circleSize, circleSize)).CGPath
            circle.fillColor = UIColor.clearColor().CGColor
            circle.strokeColor = UIColor.whiteColor().CGColor
            circle.lineWidth = 1
            circle.name = "circle\(i)"
            
            indicatorsView.layer.addSublayer(circle)
        }
        
        self.addSubview(self.indicatorsView)
        
    }
    
    @IBAction func buttonTapped(sender: UIButton){
        
        // update circle indicators
        for layer in self.indicatorsView.layer.sublayers! {
            
            let circle = layer as! CAShapeLayer
            
            if circle.name == "circle\(tapCount)" {
                circle.fillColor = UIColor.whiteColor().CGColor
            }
        }
        
        // identify button
        var id = String()
        
        // save sequence by user - any 4 items
        if tapCount < 4{
            
            if sender.tag > 0 && sender.tag < 11 {
                // color buttons
                id = self.colorDict.someKeyFor(self.colorArr[sender.tag - 1] as UIColor!)!
            }
            else if sender.tag > 10 && sender.tag < 21 {
                // number buttons
                id = "\(sender.titleLabel!.text!)"
            }
            
            self.passcodeArr.append(id)
            
            tapCount += 1
            
            // check result after every 4 taps
            if tapCount == 4 {
                
                //print("passcode: \(self.passcodeArr)")
                
                //save to NSUserDefaults or Core Data
                NSUserDefaults.standardUserDefaults().setObject(self.passcodeArr, forKey: "passCode")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                self.animateButtons()
            }
        }
    }
    
    func animateButtons(){
        
        var newPositionArr = Array<CGRect>()
        
        // create array of new positions for the animation
        let btnsOnX = 3
        let btnSize = 60
        let offsetX = (Int(self.frame.width) - (btnSize * btnsOnX)) / (btnsOnX + 1)
        
        let offsetY = (Int(self.frame.height) - (btnSize * 5)) / 4
        
        var xRow = 0
        var xPosMultiplier = 0
        
        for i in 0..<10{
            
            xPosMultiplier += 1
            
            if (i % btnsOnX == 0) { // change row each 3x
                xRow += 1
                xPosMultiplier = 0
                print("")
            }
            
            let xPos = offsetX + (xPosMultiplier * btnSize)
            let yPos = CGFloat(xRow * btnSize) - CGFloat(offsetY)
            
            var frameRect: CGRect = CGRectMake(CGFloat(xPos), yPos, CGFloat(btnSize), CGFloat(btnSize))
            
            if i == 9{
                frameRect = CGRectMake(CGFloat(xPos + btnSize), yPos, CGFloat(btnSize), CGFloat(btnSize))
            }
            
            newPositionArr.append(frameRect)
           
            if (i % btnsOnX  == 0) { // change row each 3x
                xPosMultiplier = 0 // reset with new row after x was set
            }
        }
        
        //-------
        
        // loop through all buttons, assign new frame and perform animation
        for view in self.subviews {
            
            if view.tag == 1001{
                
                for btn in view.subviews as! [UIButton]{
                    
                    UIView.animateWithDuration(0.3, animations: {() -> Void in
                    
                        if btn.tag > 0 && btn.tag <= 10 {
                            // color buttons
                            btn.frame = newPositionArr[btn.tag - 1]
                        }
                        else if btn.tag >= 10 && btn.tag <= 20 {
                            // number buttons
                            btn.frame = newPositionArr[btn.tag - 11]
                        }
                        }, completion: { (finished: Bool) -> Void in
                            
                            if btn.tag > 0 && btn.tag <= 10 {
                                // color buttons
                                btn.setTitle("\(btn.tag)", forState: .Normal)
                                
                                // handle "0"
                                if btn.tag == 10{
                                   btn.setTitle("0", forState: .Normal)
                                }
                            }
                            else if btn.tag >= 10 && btn.tag <= 20 {
                                // hide number buttons
                                btn.alpha = 0
                            }
                            
                            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(SetAOPasscodeView.dismiss), userInfo: nil, repeats: false)
                    })
                }
            }
        }
    }
    
    func dismiss(){
        self.removeFromSuperview()
    }
}

