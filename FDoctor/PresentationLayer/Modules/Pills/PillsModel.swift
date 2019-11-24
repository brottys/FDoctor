//
//  PillsModel.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import Foundation

struct PillDisplayModel {
    let imageUrl: String
}

protocol IPillsModel: class {
    var delegate: IPillsModelDelegate? { get set }
    func fetchPills()
}

protocol IPillsModelDelegate: class {
    func setup(dataSource: [PillDisplayModel])
}

class PillsModel: IPillsModel {
    
    weak var delegate: IPillsModelDelegate?
    
    private let pillsService: IPillsService
    
    init(pillsService: IPillsService) {
        self.pillsService = pillsService
    }
    
    func fetchPills() {
        pillsService.loadPills() { (pills: [PillApiModel]?, error) in
            if let pills = pills {
                print(pills)
                let cells = pills.map({ PillDisplayModel(imageUrl: $0.img) })
                self.delegate?.setup(dataSource: cells)
            } else {
                print(error ?? "ERROR")
            }
        }
    }
    
}
