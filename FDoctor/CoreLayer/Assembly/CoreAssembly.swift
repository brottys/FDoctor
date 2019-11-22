//
//  CoreAssembly.swift
//  FDoctor
//
//  Created by BrottyS on 22.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

protocol ICoreAssembly: class {
    var requestSender: IRequestSender { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var requestSender: IRequestSender = RequestSender()
}
