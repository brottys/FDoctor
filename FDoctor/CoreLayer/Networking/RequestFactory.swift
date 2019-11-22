//
//  RequestFactory.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

struct RequestFactory {
        
    struct PillsRequests {
        
        static func pillsConfig() -> RequestConfig<PillsParser> {
            return RequestConfig<PillsParser>(request: PillsRequest(), parser: PillsParser())
        }
        
    }
    
}
