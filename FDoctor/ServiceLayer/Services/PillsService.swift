//
//  PillsService.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

protocol IPillsService: class {
    func loadPills(completionHandler: @escaping ([PillApiModel]?, String?) -> Void)
}

class PillsService: IPillsService {
    
    private let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadPills(completionHandler: @escaping ([PillApiModel]?, String?) -> Void) {
        let requestConfig = RequestFactory.PillsRequests.pillsConfig()
        
        requestSender.send(requestConfig: requestConfig) { (result: Result<[PillApiModel]>) in
            switch result {
            case .success(let pills):
                completionHandler(pills, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }

}
