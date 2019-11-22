//
//  PillsParser.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import Foundation

struct PillApiModel {
    let name: String
}

class PillsParser: IParser {
    
    typealias Model = [PillApiModel]
    
    func parse(data: Data) -> [PillApiModel]? {
        return [PillApiModel(name: "Мезим форте")]
    }
    
}
