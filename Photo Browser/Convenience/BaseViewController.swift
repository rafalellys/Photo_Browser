//
//  BaseViewController.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

var indicatorView: CustomIndicatorView?

var overlay: UIView?
    
      func showLoadingIndicator() {
            
            //UIApplication.shared.beginIgnoringInteractionEvents()
            
            if indicatorView == nil {
                let x = UIScreen.main.bounds.width / 2 - 33
                var y = UIScreen.main.bounds.height / 2 - 33
                
                if let navbar = navigationController?.navigationBar { if !navbar.isTranslucent { y -= 64 } }
                
                overlay = UIView(frame: UIScreen.main.bounds)
                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                guard let ovLay = overlay else {return}
                blurEffectView.frame = ovLay.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                ovLay.addSubview(blurEffectView)
                
                indicatorView = CustomIndicatorView(frame: CGRect(x: x, y: y, width: 66, height: 66))
                indicatorView?.layer.cornerRadius = 6
                
                let indicator = UIActivityIndicatorView(style: .gray)
    //            indicator.color = .gray
                indicator.center = CGPoint(x: 33, y: 33)
                indicator.startAnimating()
                
                guard let iView = indicatorView else {return}
                iView.addSubview(indicator)
                DispatchQueue.main.async {
                    self.view.addSubview(ovLay)
                    self.view.addSubview(iView)
                }
            }
        }
        
        func hideLoadingIndicator() {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                //            UIApplication.shared.endIgnoringInteractionEvents()
                self.overlay?.removeFromSuperview()
                self.indicatorView?.removeFromSuperview()
                self.indicatorView = nil
            })
        }
    
    
    

}
