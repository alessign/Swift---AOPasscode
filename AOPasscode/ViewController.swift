//
//  ViewController.swift
//  AOPasscode
//
//  Created by Ales Olasz on 13/07/2016.
//  Copyright © 2016 ViralIdeasLtd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
     /*   UIView.animateWithDuration(0.3, delay: 0.5, options: .CurveEaseInOut, animations: {
            
            let view2 = AOPasscode.instanceFromNib()
            view2.frame = self.view.frame
            self.view.addSubview(view2)
            
            }, completion: nil)
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setPasscode(sender: UIButton){
    
        print(sender.tag)
        
        let passView = SetAOPasscodeView.instanceFromNib()
        passView.frame = self.view.frame
        self.view.addSubview(passView)
    }
    @IBAction func testPasscode(){
    
        let view = AOPasscode.instanceFromNib()
        view.frame = self.view.frame
        self.view.addSubview(view)
    }
}

