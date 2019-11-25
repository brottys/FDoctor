//
//  CarouselCollectionView.swift
//  FDoctor
//
//  Created by BrottyS on 25.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

// Copy-pasted and adopted from github.com/superpeteblaze/ScalingCarousel

import UIKit

class CarouselCollectionView: UICollectionView, UIScrollViewDelegate {
    
    // MARK: - Properties (Private)
    
    private let cardWidthCoeff: CGFloat = 1.5
    private let cardMargin: CGFloat = 8
    private var lastCurrentCenterCellIndex: IndexPath?
    
    private var invisibleScrollView: UIScrollView!
    private var invisibleWidthConstraint: NSLayoutConstraint?
    private var invisibleLeftConstraint: NSLayoutConstraint?
    
    // MARK: - Properties (Public)
    
    /// Inset of the main, center cell
    var inset: CGFloat = 0.0 {
        didSet {
            configureLayout()
        }
    }
    
    /// Returns the current center cell of the carousel if it can be calculated
    var currentCenterCell: UICollectionViewCell? {
        let lowerBound = inset - 20
        let upperBound = inset + 20
        
        for cell in visibleCells {
            let cellRect = convert(cell.frame, to: nil)
            
            if cellRect.origin.x > lowerBound && cellRect.origin.x < upperBound {
                return cell
            }
        }
        
        return nil
    }
    
    /// Returns the IndexPath of the current center cell if it can be calculated
    var currentCenterCellIndex: IndexPath? {
        guard let currentCenterCell = self.currentCenterCell else { return nil }
        
        return indexPath(for: currentCenterCell)
    }
    
    /// Override of the collection view content size to add an observer
    override var contentSize: CGSize {
        didSet {
            guard let dataSource = dataSource,
                let invisibleScrollView = invisibleScrollView else { return }
            
            // Calculate total number of items in collection view
            let numberItems = dataSource.collectionView(self, numberOfItemsInSection: 0)
            
            // Set the invisibleScrollView contentSize width based on number of items
            let contentWidth = invisibleScrollView.frame.width * CGFloat(numberItems)
            invisibleScrollView.contentSize = CGSize(width: contentWidth, height: invisibleScrollView.frame.height)
        }
    }
    
    // MARK: - Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let collectionViewSize = self.frame.size
        let itemWidth = collectionViewSize.width / cardWidthCoeff
        let itemWidthWithMargins = itemWidth + cardMargin * 2
        self.inset = (collectionViewSize.width - itemWidthWithMargins) / 2 + cardMargin
    }
    
    // MARK: - Overrides
    
    override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        invisibleScrollView.setContentOffset(rect.origin, animated: animated)
    }
    
    override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        
        let originX = (CGFloat(indexPath.item) * (frame.size.width - (inset * 2)))
        let rect = CGRect(x: originX, y: 0, width: frame.size.width - (inset * 2), height: frame.height)
        scrollRectToVisible(rect, animated: animated)
        lastCurrentCenterCellIndex = indexPath
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addInvisibleScrollView(to: superview)
    }
    
    // MARK: - Public API
    
    /*
     This method should ALWAYS be called from the ScalingCarousel delegate when
     the UIScrollViewDelegate scrollViewDidScroll(_:) method is called
     
     e.g In the ScalingCarousel delegate, implement:
     
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carousel.didScroll()
     }
    */
    public func didScroll() {
        scrollViewDidScroll(self)
    }
    
    // MARK: - ScrollView Magic
    
    func addInvisibleScrollView(to superview: UIView?) {
        guard let superview = superview else { return }
        
        /// Add our 'invisible' scrollview
        invisibleScrollView = UIScrollView(frame: bounds)
        invisibleScrollView.translatesAutoresizingMaskIntoConstraints = false
        invisibleScrollView.isPagingEnabled = true
        invisibleScrollView.showsHorizontalScrollIndicator = false
        
        /*
         Disable user interaction on the 'invisible' scrollview,
         This means touch events will fall through to the underlying UICollectionView
         */
        invisibleScrollView.isUserInteractionEnabled = false
        
        /// Set the scroll delegate to be the ScalingCarouselView
        invisibleScrollView.delegate = self
        
        /*
         Now add the invisible scrollview's pan
         gesture recognizer to the ScalingCarouselView
         */
        addGestureRecognizer(invisibleScrollView.panGestureRecognizer)
        
        /*
         Finally, add the 'invisible' scrollview as a subview
         of the ScalingCarousel's superview
        */
        superview.addSubview(invisibleScrollView)
        
        /*
         Add constraints for height and top, relative to the
         ScalingCarouselView
        */
        invisibleScrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        invisibleScrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        /*
         Further configure our layout and add more constraints
         for width and left position
        */
        configureLayout()
    }
    
    func configureLayout() {
        // Create a ScalingCarouselLayout using our inset
        collectionViewLayout = CarouselFlowLayout(withInset: inset, cardMargin: cardMargin)
        
        /*
         Only continue if we have a reference to
         our 'invisible' UIScrollView
        */
        guard let invisibleScrollView = invisibleScrollView else { return }
    
        // Remove constraints if they already exist
        invisibleWidthConstraint?.isActive = false
        invisibleLeftConstraint?.isActive = false
        
        /*
         Add constrants for width and left postion
         to our 'invisible' UIScrollView
        */
        invisibleWidthConstraint = invisibleScrollView.widthAnchor.constraint(equalTo: widthAnchor, constant: -(2 * inset))
        invisibleLeftConstraint =  invisibleScrollView.leftAnchor.constraint(
            equalTo: leftAnchor, constant: inset)
        
        // Activate the constraints
        invisibleWidthConstraint?.isActive = true
        invisibleLeftConstraint?.isActive = true
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /*
         Move the ScalingCarousel based on the
         contentOffset of the 'invisible' UIScrollView
        */
        updateOffSet()
        
        // Also, this is where we scale our cells
        for cell in visibleCells {
            if let infoCardCell = cell as? CarouselCollectionViewCell {
                infoCardCell.scale(withInset: inset)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
        guard let indexPath = currentCenterCellIndex else { return }
        lastCurrentCenterCellIndex = indexPath
    }
    
    private func updateOffSet() {
        contentOffset = invisibleScrollView.contentOffset
    }

}
