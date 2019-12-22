//
//  PillsRequest.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import Foundation

class PillsRequest: IRequest {
    
//    private let baseUrl = "https://cloud.fdoctor.ru"
//    private let command = "/test_task"
    private let baseUrl = "https://api.jsonbin.io/b/5dff5f75bda54254c5f0fd2b"
    private var urlString: String {
        return baseUrl /* + command */
    }
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
}
