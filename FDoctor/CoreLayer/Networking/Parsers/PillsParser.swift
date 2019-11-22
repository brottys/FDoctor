//
//  PillsParser.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import Foundation

struct PillApiModel {
    let id: Int
    let name: String
    let img: String
    let description: String
    let dose: String
}

class PillsParser: IParser {
    
    typealias Model = [PillApiModel]
    
    func parse(data: Data) -> [PillApiModel]? {        
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
            guard let pills = json["pills"] as? [[String: Any]] else {
                return nil
            }
            
            var pillApiModels: [PillApiModel] = []
            
            for item in pills {
                guard let id = item["id"] as? Int,
                    let name = item["name"] as? String,
                    let img = item["img"] as? String,
                    let description = item["desription"] as? String,
                    let dose = item["dose"] as? String else {
                        continue
                }
                pillApiModels.append(PillApiModel(id: id, name: name, img: img, description: description, dose: dose))
            }
            
            return pillApiModels
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
