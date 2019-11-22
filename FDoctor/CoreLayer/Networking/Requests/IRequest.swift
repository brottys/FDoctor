//
//  IRequest.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import Foundation

protocol IRequest: class {
    var urlRequest: URLRequest? { get }
}
