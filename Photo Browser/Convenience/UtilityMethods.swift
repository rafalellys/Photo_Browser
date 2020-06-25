//
//  UtilityMethods.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class UtilityMethods {
    
    class func setShadowOn<Element: UIView>(_ element: Element) {
        element.layer.masksToBounds = false
        element.layer.shadowColor = UIColor.lightGray.cgColor
        element.layer.shadowOpacity = 0.7
        element.layer.shadowRadius = 2
        element.layer.shadowOffset = CGSize(width: 0.7, height: 1.0)
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
