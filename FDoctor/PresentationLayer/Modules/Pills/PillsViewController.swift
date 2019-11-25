//
//  PillsViewController.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import UIKit
import Kingfisher

class PillsViewController: UIViewController, UICollectionViewDataSource, IPillsModelDelegate {
    
    private let presentationAssembly: IPresentationAssembly
    private let model: IPillsModel
    private let carouselCellIdentifier = "CarouselCollectionViewCell"
    private let cardWidthCoeff: CGFloat = 1.5
    private let cardMargin: CGFloat = 8
    
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descrDoseLabel: UILabel!
    
    private var dataSource: [PillDisplayModel] = []
    
    init(presentationAssembly: IPresentationAssembly, model: IPillsModel) {
        self.presentationAssembly = presentationAssembly
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    
        refresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutCarousel()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: carouselCellIdentifier, for: indexPath) as! CarouselCollectionViewCell
        configurePillImage(for: cell, with: dataSource[indexPath.row])
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func refresh() {
        model.fetchPills()
    }
    
    @IBAction func next() {
        model.nextPill()
    }
    
    // MARK: - IPillsModelDelegate
    
    func setup(dataSource: [PillDisplayModel]) {
        self.dataSource = dataSource
        
        DispatchQueue.main.async {
            self.pageControl.numberOfPages = dataSource.count
            self.carouselCollectionView.reloadData()
        }
    }
    
    func setCurrentPillAt(index: Int) {
        if index > -1 {
            let indexPath = IndexPath(row: index, section: 0)
            let pill = dataSource[index]
            
            DispatchQueue.main.async {
                self.pageControl.currentPage = index
                self.nameLabel.text = pill.name
                self.descrDoseLabel.text = pill.descrDose
                self.carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func configurePillImage(for cell: CarouselCollectionViewCell, with pill: PillDisplayModel) {
        if let imageView = cell.viewWithTag(1000) as? UIImageView, let url = URL(string: pill.imageUrl) {
            imageView.kf.setImage(with: url)
        }
    }
    
    private func configureUI() {
        carouselCollectionView.register(UINib(nibName: "\(CarouselCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: carouselCellIdentifier)
        
        if let flowLayout = carouselCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = cardMargin
        }
        
        pageControl.numberOfPages = 0
        nameLabel.text = ""
        descrDoseLabel.text = ""
    }
    
    private func layoutCarousel() {
        if let flowLayout = carouselCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = carouselCollectionView.bounds.width / cardWidthCoeff
            flowLayout.itemSize = CGSize(width: itemWidth, height: carouselCollectionView.bounds.height - cardMargin * 2)
            let itemWidthWithMargins = itemWidth + cardMargin * 2
            let inset = (carouselCollectionView.bounds.width - itemWidthWithMargins) / 2 + cardMargin
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        }
    }
    
}
