//
//  IParser.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import Foundation

protocol IParser: class {
    associatedtype Model
    func parse(data: Data) -> Model?
}
