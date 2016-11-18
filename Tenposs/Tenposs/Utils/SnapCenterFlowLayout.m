//
//  SnapCenterFlowLayout.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/15/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SnapCenterFlowLayout.h"

@implementation SnapCenterFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    UICollectionView *cv = self.collectionView;
    if (cv) {
        CGRect cvBounds = cv.bounds;
        CGFloat halfWidth = cvBounds.size.width * 0.5;
        CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth;\
        
        NSArray *attributesForVisibleCells = [self layoutAttributesForElementsInRect:cvBounds];
        UICollectionViewLayoutAttributes *candidateAttributes;
        for(UICollectionViewLayoutAttributes *attributes in attributesForVisibleCells){
            if (attributes.representedElementCategory != UICollectionElementCategoryCell ) {
                continue;
            }
            
            if ((attributes.center.x == 0) || (attributes.center.x > (cv.contentOffset.x + halfWidth) && velocity.x < 0)) {
                continue;
            }
            
            if(!candidateAttributes){
                candidateAttributes = attributes;
                continue;
            }else{
                UICollectionViewLayoutAttributes *candAttrs = candidateAttributes;
                
                CGFloat a = attributes.center.x - proposedContentOffsetCenterX;
                CGFloat b = candAttrs.center.x - proposedContentOffsetCenterX;
                
                if(fabsf(a) < fabsf(b)){
                    candidateAttributes = attributes;
                }
            }
        }
        
        if(proposedContentOffset.x == -(cv.contentInset.left)) {
            return proposedContentOffset;
        }
        
        return CGPointMake(floor(candidateAttributes.center.x - halfWidth),proposedContentOffset.y);
    }
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}

@end
