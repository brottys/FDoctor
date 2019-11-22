//
//  PillsModel.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import Foundation

protocol IPillsModel: class {
    func fetchPills()
}

class PillsModel: IPillsModel {
    
    private let pillsService: IPillsService
    
    init(pillsService: IPillsService) {
        self.pillsService = pillsService
    }
    
    func fetchPills() {
        pillsService.loadPills() { (pills: [PillApiModel]?, error) in
            if let pills = pills {
                print(pills)
            } else {
                print(error ?? "ERROR")
            }
        }
    }
    
}
