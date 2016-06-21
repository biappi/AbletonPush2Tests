//
//  main.swift
//  nanotests
//
//  Created by Antonio Malara on 20/06/16.
//  Copyright © 2016 Antonio Malara. All rights reserved.
//

import Foundation
import CoreMIDI

func send(sock : Int32, response : [UInt8]) {
    let sendresp = nn_send(sock, response, response.count, 0)
    print("response: \(response) ret: \(sendresp)")
}

func receive(sock : Int32) -> [UInt8]? {
    var charPtr : UnsafePointer<UInt8> = nil
    let len = nn_recv(sock, &charPtr, -1, 0)
    if len < 0 {
        return nil
    }
    else {
        let charBuf = UnsafeBufferPointer<UInt8>(start: charPtr, count: Int(len))
        let array = Array<UInt8>(charBuf)
        print ("received: \(array)")
        return array
    }
}

class MidiThread : NSThread, MidiDelegate {
    let m = Midi()
    let portName : String
    
    init(name: String) {
        self.portName = name
    }
    
    override func main() {
        print("midithread start")
        m.listen(self, name: portName)
        NSRunLoop.currentRunLoop().run()
        print("midithread end")
    }
    
    func receivedNoteOnChannel(channel: UInt8, note: UInt8, velocity: UInt8) {
        print("noteon \(channel) \(note) \(velocity)")
    }
    
    func receivedPitchWheelChannel(channel: UInt8, value: UInt16) {
        print("pitchwheel \(channel) \(value)")
    }
    
    func receivedControlChangeChannel(channel: UInt8, controller: UInt8, value: UInt8) {
        print("cc \(channel) \(controller) \(value)")
    }
    
    func receivedChannelPressureChannel(channel: UInt8, value: UInt8) {
        print("channelpressure \(channel) \(value)")
    }
    
    func receivedSysEx(data: UnsafeMutablePointer<UInt8>, len: Int) {
        let sysex = Array<UInt8>(UnsafeBufferPointer(start: data, count: len))
        print("sysex \(sysex)")
        
        let identityRequest : [UInt8] = [0xf0, 0x7e, 0x7f, 0x06, 0x01, 0xf7]
        
        if sysex == identityRequest {
            let response : [UInt8] = [
                0xF0,
                0x7E,
                0x01,
                0x06,
                0x02,
                0x00,
                0x21,
                0x1D,
                0x67,
                0x32,
                0x02,
                0x00,
                0x01,
                0x00,
                0x2F,
                0x00,
                0x3B,
                0x5F,
                0x41,
                0x08,
                0x00,
                0x01,
                0xF7,
            ]
            
            m.sendMidiBytes(response, count: response.count)
            //print("midi send \(response)")
        }
    }
}

if Process.arguments.count > 4 {
    print("NANOMSG SIDE")
    
    let ipcPort = Process.arguments[4]
    let sock = nn_socket(AF_SP, (NN_PROTO_PAIR * 16 + 0))
    
    let res = "ipc:///tmp/\(ipcPort)".withCString { (string) in
        return nn_connect(sock, string)
    }
    
    print("bind res: \(res)")
    
    send(sock, response: [0, 0, 0, 0])
    
    while true {
        let maybeThing = receive(sock)
        if let thing = maybeThing {
            if thing.count > 4 {
                if thing[0..<4] == [3, 0, 0, 0] {
                    let maybePayload = String(bytes: thing[4..<thing.count], encoding: NSUTF8StringEncoding)
                    
                    if let payload = maybePayload {
                        print (payload)
//                        let j = try! NSJSONSerialization.JSONObjectWithData(payload.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions())
//                        print("json payload: \(j)")
                    }
                }
            }
//            // from push -> live
            
//            if thing == [0, 0, 0, 0] {
//                send(sock, response: [1, 0, 0, 0])
//            }
        }
    }
}
else {
    print("MIDI SIDE")
    let t = MidiThread(name: "Live Port")
    t.start()
    
    NSRunLoop.currentRunLoop().run()
}
