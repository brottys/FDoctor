//
//  RequestSender.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import Foundation

class RequestSender: IRequestSender {
    
    private let session = URLSession.shared
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser: IParser {
        guard let urlRequest = requestConfig.request.urlRequest else {
            completionHandler(Result.error("Can't make URL from url string"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.error(error.localizedDescription))
                return
            }
            guard let data = data, let parsedModel: Parser.Model = requestConfig.parser.parse(data: data) else {
                completionHandler(Result.error("Can't parse received data"))
                return
            }
            
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
    }
    
}
