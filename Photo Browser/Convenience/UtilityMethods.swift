//
//  UtilityMethods.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class UtilityMethods {
    
    //MARK:- Set shadow on view
    
    class func setShadowOnView(_ view : UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0.7, height: 1.0)
    }
    
    class func setShadowOnLabel(_ view : UILabel) {
           view.layer.masksToBounds = false
           view.layer.shadowColor = UIColor.lightGray.cgColor
           view.layer.shadowOpacity = 0.7
           view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0.7, height: 0.5)
       }
    
    class func setShadowOnImageView(_ view : UIImageView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0.7, height: 1.0)
    }
    
    class func makeDateWithReadableMonth(dateTobeConverted: String?) -> String {
        var formattedDate = String()
        if let surveyPublishDate = dateTobeConverted  {
            if surveyPublishDate.count <= 25 {
                //no miliseconds
                let dateFormatter = ISO8601DateFormatter()
                if let newDate = dateFormatter.date(from:surveyPublishDate) {
                    
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateFormat = "MMM d yyyy"
                    formattedDate = dateFormatter2.string(from: newDate)
                }
            } else {
                //with miliseconds
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                if let newDate = dateFormatter.date(from:surveyPublishDate) {
                    
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateFormat = "MMM d yyyy"
                    formattedDate = dateFormatter2.string(from: newDate)
                }
            }
            
        }
        return formattedDate
    }
}
