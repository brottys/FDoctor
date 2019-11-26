//
//  PillsViewController.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import UIKit
import Kingfisher

class PillsViewController: UIViewController, UICollectionViewDataSource, IPillsModelDelegate, CarouselCollectionViewDelegate {
    
    private let presentationAssembly: IPresentationAssembly
    private let model: IPillsModel
    private let carouselCellIdentifier = "CarouselCollectionViewCell"
    private var dataSource: [PillDisplayModel] = []
    private var isCarouselScrolling: Bool = false
    
    @IBOutlet weak var carouselCollectionView: CarouselCollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descrDoseLabel: UILabel!
    
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
        guard (0..<dataSource.count).contains(index) else { return }
        
        let indexPath = IndexPath(row: index, section: 0)
        let pill = dataSource[index]
        
        DispatchQueue.main.async {
            self.pageControl.currentPage = index
            self.nameLabel.text = pill.name
            self.descrDoseLabel.text = pill.descrDose
            self.labelsView.alpha = 0.0
            self.labelsView.fadeOut() {_ in
                self.labelsView.fadeIn()
            }
            if !self.isCarouselScrolling {
                self.carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                //self.carouselCollectionView.didScroll()
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
        
        carouselCollectionView.carouselDelegate = self
        
        pageControl.numberOfPages = 0
        nameLabel.text = ""
        descrDoseLabel.text = ""
    }
    
    // MARK: - CarouselCollectionViewDelegate
    
    func didChangePageIndex(newPageIndex: Int) {
        model.didSelectPillAt(index: newPageIndex)
    }
    
    func carouselStartedScrolling() {
        isCarouselScrolling = true
    }
    
    func carouselStoppedScrolling() {
        isCarouselScrolling = false
    }
    
}
