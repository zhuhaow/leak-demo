//
//  Service.swift
//  xpc
//
//  Created by Zhuhao Wang on 2022/1/18.
//

import Foundation
import SwiftyXPC

class Service {
    let listener: XPCListener
    
    init() {
        listener = try! XPCListener(type: .service, codeSigningRequirement: nil)
        
        listener.setMessageHandler(name: "createPipe", handler: self.createPipe)
        
        listener.activate()
    }
    
    func createPipe(_: XPCConnection) async throws -> PipeResponse {
        var pipes: [Int32] = [0, 0]
        let result = pipes.withUnsafeMutableBufferPointer {
            return pipe($0.baseAddress!)
        }
        
        guard result == 0 else {
            exit(EXIT_FAILURE)
        }
        
        // We pass ownership of the fd here, they are expected to be closed on the server side after the response is encoded.
        return PipeResponse(read: XPCFileDescriptor(fileDescriptor: pipes[0]), write: XPCFileDescriptor(fileDescriptor: pipes[1]))
    }
}
