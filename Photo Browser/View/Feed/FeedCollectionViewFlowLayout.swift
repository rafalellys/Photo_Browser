//
//  FeedCollectionViewFlowLayout.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-25.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class FeedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
          return true
      }

      override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
          let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
          context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
          return context
      }
}
