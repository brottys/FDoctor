//
//  ServiceAssembly.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

protocol IServiceAssembly: class {
    var pillsService: IPillsService { get }
}

class ServiceAssembly: IServiceAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var pillsService: IPillsService = PillsService(requestSender: self.coreAssembly.requestSender)
    
}
