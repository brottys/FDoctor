//
//  PillsViewController.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import UIKit

class PillsViewController: UIViewController {
    
    private let presentationAssembly: IPresentationAssembly
    private let model: IPillsModel
    
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
        
        model.fetchPills()
    }
}
