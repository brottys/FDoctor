//
//  PresentationAssembly.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

protocol IPresentationAssembly: class {
    func pillsViewController() -> PillsViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServiceAssembly
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func pillsViewController() -> PillsViewController {
        let model = pillsModel()
        return PillsViewController(presentationAssembly: self, model: model)
    }
    
    // MARK: - Private Section
    
    private func pillsModel() -> IPillsModel {
        return PillsModel(pillsService: serviceAssembly.pillsService)
    }
    
}
