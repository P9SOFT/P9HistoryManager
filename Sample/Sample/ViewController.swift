//
//  ViewController.swift
//  Sample
//
//  Created by Tae Hyun Na on 2017. 3. 10.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

import UIKit

class ViewController: UIViewController {

    @IBOutlet var undoButton: UIButton!
    @IBOutlet var redoButton: UIButton!
    @IBOutlet var kingghidorahImageView: UIImageView!
    @IBOutlet var godzillaImageView: UIImageView!
    
    let historyKey:String = "playWithMonsters"
    let moveStepName:String = "transform"
    var temporaryTransform:CATransform3D = CATransform3DIdentity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.updateButtonStatus()
        
        P9ViewDragger.defaultTracker().trackingView(self.kingghidorahImageView, parameters: nil, ready: { (trackingView:UIView?) in
            self.temporaryTransform = self.kingghidorahImageView.layer.transform
        }, trackingHandler: nil) { (trackingView:UIView?) in
            let previousTransfrom:CATransform3D = self.temporaryTransform
            let currentTransform:CATransform3D = self.kingghidorahImageView.layer.transform
            P9HistoryManager.default().step(forKey: self.historyKey, stepName: self.moveStepName, parameters: nil, undoAction: { (parameters:[AnyHashable : Any]?) in
                self.kingghidorahImageView.layer.transform = previousTransfrom
                self.updateButtonStatus()
            }, redoAction: { (parameters:[AnyHashable : Any]?) in
                self.kingghidorahImageView.layer.transform = currentTransform
                self.updateButtonStatus()
            })
            self.updateButtonStatus()
        }
        
        P9ViewDragger.defaultTracker().trackingView(self.godzillaImageView, parameters: nil, ready: { (trackingView:UIView?) in
            self.temporaryTransform = self.godzillaImageView.layer.transform
        }, trackingHandler: nil) { (trackingView:UIView?) in
            let previousTransfrom:CATransform3D = self.temporaryTransform
            let currentTransform:CATransform3D = self.kingghidorahImageView.layer.transform
            P9HistoryManager.default().step(forKey: self.historyKey, stepName: self.moveStepName, parameters: nil, undoAction: { (parameters:[AnyHashable : Any]?) in
                self.godzillaImageView.layer.transform = previousTransfrom
                self.updateButtonStatus()
            }, redoAction: { (parameters:[AnyHashable : Any]?) in
                self.godzillaImageView.layer.transform = currentTransform
                self.updateButtonStatus()
            })
            self.updateButtonStatus()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateButtonStatus() {
        
        undoButton.isEnabled = (P9HistoryManager.default().countOfPrevSteps(forKey: historyKey) > 0)
        redoButton.isEnabled = (P9HistoryManager.default().countOfNextSteps(forKey: historyKey) > 0)
    }
    
    @IBAction func undoButtonTouchUpInside(_ sender: Any) {
        
        P9HistoryManager.default().undoStep(forKey: historyKey)
        updateButtonStatus()
    }
    
    @IBAction func reduButtonTouchUpInside(_ sender: Any) {
        
        P9HistoryManager.default().redoStep(forKey: historyKey)
        updateButtonStatus()
    }

}

