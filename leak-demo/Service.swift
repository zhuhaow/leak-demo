//
//  Service.swift
//  leak-demo
//
//  Created by Zhuhao Wang on 2022/1/18.
//

import Foundation
import SwiftyXPC

class Service {
    let connection: XPCConnection
    
    init() {
        self.connection = try! XPCConnection(type: .remoteService(bundleID: "me.zhuhao.leak-demo.xpc-server"), codeSigningRequirement: nil)
        
        self.connection.activate()
    }
    
    func createPipe() async throws -> PipeResponse {
        return try await connection.sendMessage(name: "createPipe")
    }
}
