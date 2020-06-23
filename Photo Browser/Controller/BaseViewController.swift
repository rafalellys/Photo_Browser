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
                
                let indicator = UIActivityIndicatorView(style: .medium)
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
            DispatchQueue.main.async {
                self.overlay?.removeFromSuperview()
                self.indicatorView?.removeFromSuperview()
                self.indicatorView = nil
            }
        }
    
    func animateTable(_ tableView: UITableView) {
           tableView.reloadData()
           
           let cells = tableView.visibleCells
           let tableHeight: CGFloat = tableView.bounds.size.height
           
           for i in cells {
               let cell: UITableViewCell = i as UITableViewCell
               cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
           }
           
           var index = 0
           
           for a in cells {
               let cell: UITableViewCell = a as UITableViewCell
               UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                   cell.transform = CGAffineTransform(translationX: 0, y: 0);
                   self.view.layoutIfNeeded()
               }, completion: nil)
               index += 1
           }
       }
}
