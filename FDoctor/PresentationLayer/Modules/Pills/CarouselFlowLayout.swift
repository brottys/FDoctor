//
//  CarouselFlowLayout.swift
//  FDoctor
//
//  Created by BrottyS on 25.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

// Copy-pasted and adopted from github.com/superpeteblaze/ScalingCarousel

import UIKit

class CarouselFlowLayout: UICollectionViewFlowLayout {
    
    private var inset: CGFloat = 0.0
    //private var cardMargin: CGFloat = 0.0
    
    convenience init(withInset inset: CGFloat/*, cardMargin: CGFloat*/) {
        self.init()
        self.inset = inset
        //self.cardMargin = cardMargin
    }
    
    override func prepare() {
        guard let collectionViewSize = collectionView?.frame.size else { return }
        
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        
        itemSize = collectionViewSize
        //itemSize.height = itemSize.height - cardMargin * 2
        itemSize.width = itemSize.width - inset * 2
        
        //minimumLineSpacing = cardMargin
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        headerReferenceSize = .zero
        footerReferenceSize = .zero
        
        sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
}
