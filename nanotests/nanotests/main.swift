//
//  main.swift
//  nanotests
//
//  Created by Antonio Malara on 20/06/16.
//  Copyright © 2016 Antonio Malara. All rights reserved.
//

import Foundation
import CoreMIDI

// MARK: Simple NanoMsg socket wrapper
// MARK: -

class NanoMsgSocket {
    let sock : Int32
    
    init(connectedTo: String) {
        sock = nn_socket(AF_SP, (NN_PROTO_PAIR * 16 + 0))
        let res = "ipc:///tmp/\(connectedTo)".withCString { return nn_connect(sock, $0) }
        print("connect res: \(res)")
    }
    
    init(boundTo: String) {
        sock = nn_socket(AF_SP, (NN_PROTO_PAIR * 16 + 0))
        let res = "ipc:///tmp/\(boundTo)".withCString { return nn_bind(sock, $0) }
        
        print("bind res: \(res) \(errno)")
    }
    
    func send(response : [UInt8]) {
        let sendresp = nn_send(sock, response, response.count, 0)
        if sendresp < 1 {
            print("fail to send response: \(response) ret: \(sendresp)")
        }
    }
    
    func receive() -> [UInt8]? {
        var charPtr : UnsafePointer<UInt8> = nil
        let len = nn_recv(sock, &charPtr, -1, 0)
        if len < 0 {
            return nil
        }
        else {
            let charBuf = UnsafeBufferPointer<UInt8>(start: charPtr, count: Int(len))
            let array = Array<UInt8>(charBuf)
            return array
        }
    }
}

// MARK: -
// MARK: Midi thread to advertise as push
// MARK: -

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
                0xF0, 0x7E, 0x01, 0x06, 0x02, 0x00, 0x21, 0x1D,
                0x67, 0x32, 0x02, 0x00, 0x01, 0x00, 0x2F, 0x00,
                0x3B, 0x5F, 0x41, 0x08, 0x00, 0x01, 0xF7,
            ]
            
            m.sendMidiBytes(response, count: response.count)
        }
    }
}

// MARK: -
// MARK: Common protocol between Live and Push
// MARK: -

extension String {
    func toBytes() -> [UInt8] {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        return Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(data.bytes), count: data.length))
    }
}

typealias PushProtocolCommand = ArraySlice<UInt8>
typealias PushProtocolCommandCallback = (PushProtocolCommand, NanoMsgSocket) -> ()
typealias PushProtocolCommandDispatch = PushProtocolCommand -> PushProtocolCommandCallback?

func pushProtocolLoop(sock: NanoMsgSocket, commands: PushProtocolCommandDispatch) {
    while true {
        let data = sock.receive()
        if let data = data {
            let command  = data[0..<4]
            let rest     = data[4..<data.count]
            
            if let callback = commands(command) {
                callback(rest, sock)
            }
            else {
                print("unknown command: \(data) \(rest)")
            }
        }
        else {
            print("less than 4 bytes in: \(data)")
        }
    }
}

// MARK: -
// MARK: Faking Push
// MARK: -

func PushGotJson(bytes: ArraySlice<UInt8>, sock: NanoMsgSocket) {
    let maybePayload = String(bytes: bytes, encoding: NSUTF8StringEncoding)
    
    if let payload = maybePayload {
        print (payload)
    }
}

func CommandToCallbackFakingPush(cmd: PushProtocolCommand) -> PushProtocolCommandCallback? {
    if cmd == [3, 0, 0, 0] { return PushGotJson }
    return nil
}

// MARK: -
// MARK: Faking Live
// MARK: -

func PushSentProbe(bytes: ArraySlice<UInt8>, sock: NanoMsgSocket) {
    var model = RootModel()
    model.notificationView = Notification(visible: true, message: "TEST")
    
    let cmd = PushCommand(command: "full-model-update", payload: model)

    sock.send([1, 0, 0, 0])
    sock.send([3, 0, 0, 0] + cmd.toJSON()!.toBytes())
}

func CommandToCallbackFakingLive(cmd: ArraySlice<UInt8>) -> ((ArraySlice<UInt8>, NanoMsgSocket) -> ())? {
    if cmd == [0, 0, 0, 0] { return PushSentProbe }
    if cmd == [3, 0, 0, 0] { return PushGotJson   }
    return nil
}

// MARK: -
// MARK: - main() functions
// MARK: -

func tryToBePush() {
    if Process.arguments.count > 4 {
        print("NANOMSG SIDE")
        
        let ipcPort = Process.arguments[4]
        
        let sock = NanoMsgSocket(connectedTo: ipcPort)
        sock.send([0, 0, 0, 0])
        pushProtocolLoop(sock, commands: CommandToCallbackFakingPush)
    }
    else {
        print("MIDI SIDE")
        let t = MidiThread(name: "Live Port")
        t.start()
        
        NSRunLoop.currentRunLoop().run()
    }
}

func tryToBeLive() {
    system("/Applications/Ableton\\ Live\\ 9\\ Suite.app/Contents/Push2/Push2DisplayProcess.app/Contents/MacOS/Push2DisplayProcess --push2-log-to-console --push2-log-level=debug --push2-mode=emulator &")
    
    let sock = NanoMsgSocket(boundTo: "push2ipc")

    
    sleep(3)
    
    pushProtocolLoop(sock, commands: CommandToCallbackFakingLive)
}


tryToBeLive()