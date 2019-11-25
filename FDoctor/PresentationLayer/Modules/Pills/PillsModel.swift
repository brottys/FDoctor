//
//  PillsModel.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import Foundation

struct PillDisplayModel {
    let name: String
    let imageUrl: String
    let descrDose: String
}

protocol IPillsModel: class {
    var delegate: IPillsModelDelegate? { get set }
    func fetchPills()
    func nextPill()
}

protocol IPillsModelDelegate: class {
    func setup(dataSource: [PillDisplayModel])
    func setCurrentPillAt(index: Int)
}

class PillsModel: IPillsModel {
    
    weak var delegate: IPillsModelDelegate?
    
    private let pillsService: IPillsService
    
    private var pills: [PillApiModel] = []
    private var currentPillIndex = -1
    
    init(pillsService: IPillsService) {
        self.pillsService = pillsService
    }
    
    func fetchPills() {
        pillsService.loadPills() { (pills: [PillApiModel]?, error) in
            if let pills = pills {
                self.pills = pills
                self.currentPillIndex = pills.count > 0 ? 0 : -1
                
                let cells = pills.map({
                    PillDisplayModel(
                        name: $0.name,
                        imageUrl: $0.img,
                        descrDose: "\($0.description). \($0.dose)"
                    )})
                self.delegate?.setup(dataSource: cells)
                self.delegate?.setCurrentPillAt(index: self.currentPillIndex)
            } else {
                print(error ?? "ERROR")
            }
        }
    }
    
    func nextPill() {
        guard currentPillIndex > -1 else {
            return
        }
        
        guard currentPillIndex + 1 < pills.count else {
            return
        }
        
        currentPillIndex += 1
    
        delegate?.setCurrentPillAt(index: currentPillIndex)
    }
    
}
