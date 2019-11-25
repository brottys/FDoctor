//
//  CarouselCollectionViewCell.swift
//  FDoctor
//
//  Created by BrottyS on 23.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

// Copy-pasted and adopted from github.com/superpeteblaze/ScalingCarousel

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties (Public)
    
    /// The minimum value to scale to, should be set between 0 and 1
    var scaleMinimum: CGFloat = 0.9
    
    /// Divisior used when calculating the scale value.
    /// Lower values cause a greater difference in scale between subsequent cells.
    var scaleDivisor: CGFloat = 10.0
    
    // MARK: - IBOutlets
    
    // This property should be connected to the main cell subview
    @IBOutlet public var mainView: UIView!
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let carouselView = superview as? CarouselCollectionView else { return }
        
        scale(withInset: carouselView.inset)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainView.transform = CGAffineTransform.identity
    }
    
    /// Scale the cell when it is scrolled
    ///
    /// - parameter carouselInset: The inset of the related SPBCarousel view
    func scale(withInset carouselInset: CGFloat) {
        // Ensure we have a superView, and mainView
        guard let superview = superview,
            let mainView = mainView else { return }
        
        // Get our absolute origin value
        let originX = superview.convert(frame, to: superview.superview).origin.x
        
        // Calculate our actual origin.x value using our inset
        let originXActual = originX - carouselInset
        
        let width = frame.size.width
        
        // Calculate our scale values
        let scaleCalculator = abs(width - abs(originXActual))
        let percentageScale = scaleCalculator / width
        
        let scaleValue = scaleMinimum + (percentageScale / scaleDivisor)
        
        let affineIdentity = CGAffineTransform.identity
        
        // Scale our mainView and set it's alpha value
        mainView.transform = affineIdentity.scaledBy(x: scaleValue, y: scaleValue)
    }

}
