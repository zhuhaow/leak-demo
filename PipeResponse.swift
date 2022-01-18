//
//  Response.swift
//  xpc
//
//  Created by Zhuhao Wang on 2022/1/18.
//

import Foundation
import SwiftyXPC

class PipeResponse: Codable {
    let read: XPCFileDescriptor
    let write: XPCFileDescriptor
    
    init(read: XPCFileDescriptor, write: XPCFileDescriptor) {
        self.read = read
        self.write = write
    }
}
