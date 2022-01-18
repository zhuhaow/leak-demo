//
//  leak_demoApp.swift
//  leak-demo
//
//  Created by Zhuhao Wang on 2022/1/18.
//

import SwiftUI
import SwiftyXPC

@main
struct leak_demoApp: App {
    init() {
        Task {
            do {
                let service = Service()
                NSLog("Started")
                var response: PipeResponse? = try await service.createPipe()
                let readFd = response!.read.dup()
                // We close both read and write fd and only use the dupped new read fd.
                response = nil
                
                var buf: [UInt8] = Array(repeating: 0, count: 10)
                let r = buf.withUnsafeMutableBytes {
                    read(readFd, $0.baseAddress, 10)
                }
                if r == 0 {
                    // We should expect the read would get EOF (i.e., 0) here since the write is closed.
                    // But it won't happen until we kill the xpc-service manually.
                    NSLog("Closed!!!")
                } else {
                    NSLog("Error: \(r)")
                }
            } catch {
                NSLog("Failed: \(error)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
