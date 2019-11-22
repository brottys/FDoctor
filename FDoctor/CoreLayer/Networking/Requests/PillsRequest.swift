//
//  PillsRequest.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import Foundation

class PillsRequest: IRequest {
    
    private let baseUrl = "https://cloud.fdoctor.ru"
    private let command = "/test_task"
    private var urlString: String {
        return baseUrl + command
    }
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
}
