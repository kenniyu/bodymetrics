//
//  TabularDataCollectionViewFlowLayout.swift
//  BodyMetrics
//
//  Created by Ken Yu on 12/1/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit

class TabularDataCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let originalAttributes = super.layoutAttributesForElementsInRect(rect)
        if var newAttributes = originalAttributes, let cv = self.collectionView {
            let contentOffset = cv.contentOffset

            let missingSections = NSMutableIndexSet()
            for layoutAttributes in newAttributes {
                if layoutAttributes.representedElementCategory == UICollectionElementCategory.Cell {
                    missingSections.addIndex(layoutAttributes.indexPath.section)
                }
            }

            for layoutAttributes in newAttributes {
                if layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader {
                    missingSections.removeIndex(layoutAttributes.indexPath.section)
                }
            }

            missingSections.enumerateIndexesUsingBlock({ (sectionIndex, stop) -> Void in
                let indexPath = NSIndexPath(forItem: 0, inSection: sectionIndex)
                if let layoutAttributes = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath) {
                    newAttributes.append(layoutAttributes)
                }
            })

            for layoutAttributes in newAttributes {

                if layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader {

                    let section = layoutAttributes.indexPath.section
                    let numberOfItemsInSection = cv.numberOfItemsInSection(section)
                    let firstCellIndexPath = NSIndexPath(forItem: 0, inSection: section)
                    let lastCellIndexPath = NSIndexPath(forItem: max(0, numberOfItemsInSection - 1), inSection: section)

                    if let firstCellAttributes = self.layoutAttributesForItemAtIndexPath(firstCellIndexPath),
                        let lastCellAttributes = self.layoutAttributesForItemAtIndexPath(lastCellIndexPath) {
                        let headerHeight: CGFloat = CGRectGetHeight(layoutAttributes.frame)
                        var origin = layoutAttributes.frame.origin
                        origin.y = min(max(contentOffset.y, CGRectGetMinY(firstCellAttributes.frame) - headerHeight), CGRectGetMaxY(lastCellAttributes.frame) - headerHeight)
                        layoutAttributes.zIndex = 1024
                        let frame = CGRectMake(origin.x, origin.y, layoutAttributes.frame.width, layoutAttributes.frame.height)
                        layoutAttributes.frame = frame
                    }
                }
            }
        }
        return originalAttributes
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
