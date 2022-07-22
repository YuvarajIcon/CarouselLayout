//
//  ViewController.swift
//  carousel
//
//  Created by Yuvaraj on 18/07/22.
//

import UIKit

open class CarouselLayout: UICollectionViewCompositionalLayout {
    fileprivate var scrollDirection: UICollectionView.ScrollDirection {
        return configuration.scrollDirection
    }
    
    @IBInspectable open var offFocusItemScale: CGFloat = 0.5
    @IBInspectable open var offFocusItemAlpha: CGFloat = 0.5
    @IBInspectable open var offFocusItemShift: CGFloat = 0
    
    override open func prepare() {
        super.prepare()
        self.setupCollectionView()
    }
    
    override public init(section: NSCollectionLayoutSection, configuration: UICollectionViewCompositionalLayoutConfiguration) {
        super.init(section: section, configuration: configuration)
        self.setupCollectionView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        let attributes = self.layoutAttributesForElements(in: collectionView.bounds)
        let cellSize = attributes?.first?.size ?? .zero
        if scrollDirection == .horizontal {
            let offset = (collectionView.bounds.width) / 2 - (cellSize.width / 2)
            collectionView.contentInset = .init(top: 0, left: offset, bottom: 0, right: offset)
        } else {
            let offset = (collectionView.bounds.height) / 2 - (cellSize.height / 2)
            collectionView.contentInset = .init(top: offset, left: 0, bottom: offset, right: 0)
        }
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }
    
    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        let isHorizontal = (scrollDirection == .horizontal)
        
        let collectionCenter = isHorizontal ? collectionView.center.x : collectionView.center.y
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset
        let maxDistance = (isHorizontal ? attributes.size.width : attributes.size.height)
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        
        let ratio = (maxDistance - distance) / maxDistance
        let alpha = ratio * (1 - self.offFocusItemAlpha) + self.offFocusItemAlpha
        let scale = ratio * (1 - self.offFocusItemScale) + self.offFocusItemScale
        let shift = (1 - ratio) * self.offFocusItemShift
        
        //self explanatory, transparency value.
        attributes.alpha = alpha
        
        //this will tell how to shrink/ expand/ rotate or do whatever you want to do to your cells.
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        
        if isHorizontal {
            attributes.center.y = attributes.center.y + shift
        } else {
            attributes.center.x = attributes.center.x + shift
        }
        
        return attributes
    }
    
    //This tells the collectionview where to stop scrolling. i.e., to achieve a paging effect kinda stuffs.
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView , !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        let isHorizontal = (scrollDirection == .horizontal)
        let midSide = (isHorizontal ? collectionView.center.x : collectionView.center.y)
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide
        
        var targetContentOffset: CGPoint
        if isHorizontal {
            let closest = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first!
            targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        }
        else {
            let closest = layoutAttributes.sorted { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first!
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))
        }
        
        return targetContentOffset
    }
}

