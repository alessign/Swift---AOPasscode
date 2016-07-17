//
//  AOPasscode.swift
//  AOPasscode
//
//  Created by Ales Olasz on 13/07/2016.
//  Copyright © 2016 ViralIdeasLtd. All rights reserved.
//

import UIKit

extension Array {
    var shuffle: [Element] {
        var elements = self
        for index in indices.dropLast() {
            guard
                case let swapIndex = Int(arc4random_uniform(UInt32(count - index))) + index
                where swapIndex != index else { continue }
            swap(&elements[index], &elements[swapIndex])
        }
        return elements
    }
    mutating func shuffled() {
        for index in indices.dropLast() {
            guard
                case let swapIndex = Int(arc4random_uniform(UInt32(count - index))) + index
                where swapIndex != index
                else { continue }
            swap(&self[index], &self[swapIndex])
        }
    }
    var chooseOne: Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
    func choose(n: Int) -> [Element] {
        return Array(shuffle.prefix(n))
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.addAnimation(animation, forKey: "shake")
    }
}

extension UIColor {
    var colorComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
    }
}


class AOPasscode: UIView {
 
    // source arrays
    var colorArr: Array = Array<UIColor>()
    var colorDict: Dictionary = Dictionary<String, UIColor>()
    var numberArr: Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    var savedCode = Array<String>()
    
    var dict:Dictionary = [String: Array<AnyObject>]()
    
    var correctAnswer = 0
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
        return UINib(nibName: "AOPasscodeView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    func setUp() {
        
        // colors
        
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
        
        self.colorArr.append(red)
        self.colorArr.append(yellow)
        self.colorArr.append(purple)
        self.colorArr.append(green)
        self.colorArr.append(blue)
        self.colorArr.append(white)
        self.colorArr.append(orange)
        self.colorArr.append(brown)
        self.colorArr.append(gray)
        self.colorArr.append(black)
        
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
        
        
        // retrieve saved passcode
        savedCode = Array<String>()
        
        
        if let savedArray = NSUserDefaults.standardUserDefaults().arrayForKey("passCode"){
            
            
            for item in (savedArray as NSArray){
                
                
                if (item is UIColor){
                savedCode.append(item as! String)
                    print("savedArray item is UIColor")
                    
                }
                else if item is String{
                savedCode.append(item as! String)
                    print("savedArray item is String")
                }
            }
        }
        
        print("savedCode: \(savedCode)")
        
        
        // generate random combinations and display btns
        
        var randomColorPickArr: Array = colorArr.shuffle
        var randomNumberPickArr: Array = numberArr.shuffle
        
        for i in 0 ..< 10{
            
            var arr:Array = [AnyObject]()
            //print(i, arr)
            
            arr.append(randomColorPickArr[i])
            arr.append(String(randomNumberPickArr[i]))
            
            //print(arr)
            let key = "btn\(randomNumberPickArr[i])"
            dict[key] = arr
        }
        
        //print("Dict: \(dict)")
        
        //set radius + title for all buttons
        var i = 0
        for btn in self.subviews as! [UIButton]{
        
            let title:Array<AnyObject> = dict["btn\(i)"]!
            
            btn.layer.cornerRadius = 40
            btn.setTitle(title[1] as? String, forState: .Normal)
            btn.backgroundColor = title[0] as? UIColor
            
            
        
            i = i + 1
        }
        
        self.drawIndicatorCircles()
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
        
        print("button: \(sender.titleLabel?.text!)")
    
        // retrieve saved sequence by user - any 4 items
        
        
        let key:String = (sender.titleLabel?.text)!
        let btnInfo: Array<AnyObject> = dict["btn\(key)"]!
        print("btnInfo: \(btnInfo)")
        
        if tapCount < 4{
            
            let roundItem: AnyObject = savedCode[tapCount] // get the exact sequence as the user have saved
            print("roundItem: \(roundItem)")
            
            if roundItem.length > 2 {
                print("roundItem is UIColor")
                
                
                let colorFromDict = self.colorDict[roundItem as! String]
                print("colorfromDict: \(colorFromDict)")
                
                 if ((btnInfo as NSArray).containsObject(colorFromDict! as UIColor)) {
                
                 correctAnswer += 1
                 }
            }
            else if roundItem.length < 2{
                print("roundItem is String")
                
                if ((btnInfo as NSArray).containsObject(roundItem as! String)) {
                    
                     correctAnswer += 1
                    }
            }
        
            tapCount += 1
            
            // check result after every 4 taps
            if tapCount == 4 {
                self.checkresult()
            }
        }
        
        print(correctAnswer)
        print(tapCount)
    }
   
    func checkresult(){
        
        if tapCount == 4 && correctAnswer == 4 {
            
            //print("Correct!")
            
            self.removeFromSuperview()
        }
        else{
        
           // print("Wrong!")
            // shake with dots
            self.indicatorsView.shake()
            
            // reset tapCount and correctAnswer
            tapCount = 0
            correctAnswer = 0
            
            // update circle indicators fill color
            for layer in self.indicatorsView.layer.sublayers! {
                
                let circle = layer as! CAShapeLayer
                    circle.fillColor = UIColor.clearColor().CGColor
            }
        }
    }
 
}
