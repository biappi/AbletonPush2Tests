//
//  main.swift
//  nanotests
//
//  Created by Antonio Malara on 20/06/16.
//  Copyright © 2016 Antonio Malara. All rights reserved.
//

import Foundation
import CoreMIDI

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
        print("response: \(response) ret: \(sendresp)")
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

var allJsons = NSMutableArray()

func PushGotJson(bytes: ArraySlice<UInt8>) {
    let maybePayload = String(bytes: bytes, encoding: NSUTF8StringEncoding)
    
    if let payload = maybePayload {
        print (payload)
        allJsons.addObject(payload)
        allJsons.writeToFile("/tmp/all-jsons", atomically: true)
    }
}

func CommandToCallback(cmd: ArraySlice<UInt8>) -> (ArraySlice<UInt8> -> ())? {
    if cmd == [3, 0, 0, 0] { return PushGotJson }
    return nil
}

func tryToBePush() {
    if Process.arguments.count > 4 {
        print("NANOMSG SIDE")
        
        let ipcPort = Process.arguments[4]
        
        let sock = NanoMsgSocket(connectedTo: ipcPort)
        sock.send([0, 0, 0, 0])
        
        while true {
            let maybeThing = sock.receive()
            if let thing = maybeThing {
                let command  = thing[0..<4]
                let rest     = thing[4..<thing.count]
                
                if let callback = CommandToCallback(command) {
                    callback(rest)
                }
                else {
                    print("unknown command: \(thing) \(rest)")
                }
            }
        }
    }
    else {
        print("MIDI SIDE")
        let t = MidiThread(name: "Live Port")
        t.start()
        
        NSRunLoop.currentRunLoop().run()
    }
}

extension String {
    func toBytes() -> [UInt8] {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        return Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(data.bytes), count: data.length))
    }
}

let model = RootModel(
    notificationView: Notification(
        visible: true,
        message: "Hello World!"
    ),
    realTimeClient: RealTimeClient(clientId: ""),
    modeState: ModeState(
        main_mode: "device",
        mix_mode: "global",
        global_mix_mode: "volume",
        device_mode: "default"
    ),
    controls: Controls(encoders: []),
    liveDialogView: LiveDialogViewModel(
        visible: false,
        text: "",
        can_cancel: false
    ),
    mixerSelectView: MixerSelectionListModel(
        visible: false,
        items: [],
        selectedItem: ""
    ),
    trackMixerSelectView: TrackMixerSelectionListModel(
        visible: false,
        items: []
    ),
    devicelistView: DeviceListModel(
        visible: true,
        items: [],
        selectedItem: Device(
            name: "",
            nestingLevel: 0,
            is_active: false,
            id: 0,
            class_name: "",
            icon: ""
        ),
        moving: false
    ),
    editModeOptionsView: EditModeOptionsModel(
        visible: false,
        device: "",
        options: []
    ),
    deviceParameterView: DeviceParameterListModel(
        visible: false,
        deviceType: "",
        parameters: []
    ),
    simplerDeviceView: SimplerDeviceViewModel(
        visible: false,
        deviceType: "",
        simpler: Device(
            name: "",
            nestingLevel: 0,
            is_active: false,
            id: 0,
            class_name: "",
            icon: ""
        ),
        parameters: [],
        properties: SimplerProperties(
            sample_start: DeviceParameter(
                name: "",
                original_name: "",
                min: 0,
                max: 0,
                value: 0,
                valueItems: [],
                displayValue: "",
                unit: "",
                id: 0,
                is_enabled: false,
                hasAutomation: false,
                automationActive: false,
                isActive: false
            ),
            sample_length: DeviceParameter(
                name: "",
                original_name: "",
                min: 0,
                max: 0,
                value: 0,
                valueItems: [],
                displayValue: "",
                unit: "",
                id: 0,
                is_enabled: false,
                hasAutomation: false,
                automationActive: false,
                isActive: false
            ),
            loop_length: DeviceParameter(
                name: "",
                original_name: "",
                min: 0,
                max: 0,
                value: 0,
                valueItems: [],
                displayValue: "",
                unit: "",
                id: 0,
                is_enabled: false,
                hasAutomation: false,
                automationActive: false,
                isActive: false
            ),
            loop_on: DeviceParameter(
                name: "",
                original_name: "",
                min: 0,
                max: 0,
                value: 0,
                valueItems: [],
                displayValue: "",
                unit: "",
                id: 0,
                is_enabled: false,
                hasAutomation: false,
                automationActive: false,
                isActive: false
            ),
            zoom: DeviceParameter(
                name: "",
                original_name: "",
                min: 0,
                max: 0,
                value: 0,
                valueItems: [],
                displayValue: "",
                unit: "",
                id: 0,
                is_enabled: false,
                hasAutomation: false,
                automationActive: false,
                isActive: false
            ),
            gain: 0,
            start_marker: 0,
            end_marker: 0,
            multi_sample_mode: false,
            current_playback_mode: 0,
            slices: [],
            selected_slice: Slice(id: 0, time: 0),
            playhead_real_time_channel_id: "",
            waveform_real_time_channel_id: "",
            sample: Sample(start_marker: 0, end_marker: 0, length: 0),
            view: SimplerView(
                sample_start: 0,
                sample_end: 0,
                sample_loop_start: 0,
                sample_loop_end: 0,
                sample_loop_fade: 0,
                sample_env_fade_in: 0,
                sample_env_fade_out: 0
            ),
            waveform_navigation: WaveformNavigation(
                animate_visible_region: false,
                visible_start: 0,
                visible_end: 0,
                show_focus: false,
                focus_marker: WaveformNavigationFocusMarker(name: "", position: 0))
        ),
        wants_waveform_shown: false,
        processed_zoom_requests: 0
    ),
    mixerView: MixerViewModel(
        volumeControlListView: DeviceParameterListModel(
            visible: false,
            deviceType: "",
            parameters: []
        ),
        panControlListView: DeviceParameterListModel(
            visible: false,
            deviceType: "",
            parameters: []
        ),
        trackControlView: TrackControlModel(
            visible: false,
            parameters: [],
            scrollOffset: 0,
            real_time_meter_channel: RealTimeChannel(channel_id: "", object_id: "")
        ),
        sendControlListView: DeviceParameterListModel(
            visible: false,
            deviceType: "",
            parameters: []
        ),
        realtimeMeterData: []
    ),
    tracklistView: TrackListModel(
        visible: false,
        tracks: [],
        selectedTrack: Track(
            name: "",
            colorIndex: 0,
            isFoldable: false,
            containsDrumRack: false,
            canShowChains: false,
            nestingLevel: 0,
            activated: false,
            isFrozen: false,
            parentColorIndex: 0,
            arm: false,
            isMaster: false,
            isAudio: false,
            id: 0
        ),
        absolute_selected_track_index: 0
    ),
    chainListView: ChainListModel(visible: false,
        items: [],
        selectedItem: Chain(name: "", id: 0, icon: "")
    ),
    parameterBankListView: ParameterBankListModel(
        visible: false,
        items: [],
        selectedItem: ItemSlotModel(name: "", icon: "")
    ),
    browserView: BrowserModel(visible: false,
        lists: [],
        scrolling: false,
        horizontal_navigation: false,
        focused_list_index: 0,
        focused_item: BrowserItem(
            id: 0,
            name: "",
            icon: "",
            is_loadable: false
        ),
        list_offset: 0,
        can_enter: false,
        can_exit: false,
        expanded: false,
        load_text: "",
        prehear_enabled: false,
        context_text: "",
        context_color_index: 0
    ),
    browserData: BrowserData(
        lists: []
    ),
    convertView: ConvertModel(source_color_index: 0,
        source_name: "",
        visible: false,
        available_conversions: []
    ),
    scalesView: ScalesModel(
        visible: false,
        scale_names: [],
        selected_scale_index: 0,
        root_note_names: [],
        selected_root_note_index: 0,
        note_layout: NoteLayout(is_in_key: false, is_fixed: false),
        horizontal_navigation: false
    ),
    quantizeSettingsView: QuantizeSettingsModel(
        visible: false,
        swing_amount: 0,
        quantize_to_index: 0,
        quantize_amount: 0,
        record_quantization_index: 0,
        record_quantization_enabled: false,
        quantization_option_names: []
    ),
    fixedLengthSelectorView: FixedLengthSelectorModel(visible: false),
    fixedLengthSettings: FixedLengthSettingsModel(
        option_names: [],
        selected_index: 0,
        enabled: false
    ),
    noteSettingsView: NoteSettingsModel(
        nudge: NoteSettingModel(min: 0, max: 0),
        coarse: NoteSettingModel(min: 0, max: 0),
        fine: NoteSettingModel(min: 0, max: 0),
        velocity: NoteSettingModel(min: 0, max: 0),
        color_index: 0,
        visible: false
    ),
    stepSettingsView: StepSettingsModel(visible: false),
    stepAutomationSettingsView: StepAutomationSettingsModel(
        visible: false,
        deviceType: "",
        parameters: [],
        can_automate_parameters: false
    ),
    audioClipSettingsView: AudioClipSettingsModel(
        warping: false,
        gain: 0,
        audio_parameters: [],
        waveform_real_time_channel_id: "",
        playhead_real_time_channel_id: ""
    ),
    loopSettingsView: LoopSettingsModel(
        looping: false,
        loop_parameters: [],
        zoom: DeviceParameter(
            name: "",
            original_name: "",
            min: 0,
            max: 0,
            value: 0,
            valueItems: [],
            displayValue: "",
            unit: "",
            id: 0,
            is_enabled: false,
            hasAutomation: false,
            automationActive: false,
            isActive: false
        ),
        processed_zoom_requests: 0,
        waveform_navigation: WaveformNavigation(
            animate_visible_region: false,
            visible_start: 0,
            visible_end: 0,
            show_focus: false,
            focus_marker: WaveformNavigationFocusMarker(name: "", position: 0)
        )
            ),
            clipView: ClipControlModel(
                clip: ClipModel(
                    id: 0,
                    name: "",
                    color_index: 0,
                    is_recording: false,
                    view: ClipViewModel(
                        sample_length: 0,
                        sample_start_marker: 0,
                        sample_end_marker: 0,
                        sample_loop_start: 0,
                        sample_loop_end: 0
                    )
                )
            ),
    setupView: SetupModel(
        visible: false,
        settings: SettingsModel(
            general: GeneralSettingsModel(workflow: ""),
            pad_settings: PadSettingsModel(
                sensitivity: 0,
                min_sensitivity: 0,
                max_sensitivity: 0,
                gain: 0,
                min_gain: 0,
                max_gain: 0,
                dynamics: 0,
                min_dynamics: 0,
                max_dynamics: 0
            ),
            hardware: HardwareSettingsModel(
                min_led_brightness: 0,
                max_led_brightness: 0,
                led_brightness: 0,
                min_display_brightness: 0,
                max_display_brightness: 0,
                display_brightness: 0
            ),
            display_debug: DisplayDebugSettingsModel(
                show_row_spaces: false,
                show_row_margins: false,
                show_row_middle: false,
                show_button_spaces: false,
                show_unlit_button: false,
                show_lit_button: false
            ),
            profiling: ProfilingSettingsModel(
                show_qml_stats: false,
                show_usb_stats: false,
                show_realtime_ipc_stats: false
            ),
            experimental: ExperimentalSettingsModel(
                new_waveform_navigation: false
            )
        ),
        selected_mode: "",
        modes: [],
        velocity_curve: VelocityCurveModel(curve_points: [])
    ),
    importantGlobals: ImportantGlobals(
        masterVolume: ValueModel(visible: false, value_string: ""),
        cueVolume: ValueModel(visible: false, value_string: ""),
        swing: ValueModel(visible: false, value_string: ""),
        tempo: ValueModel(visible: false, value_string: "")
    ),
    firmwareInfo: FirmwareInfo(
        major: 0,
        minor: 0,
        build: 0,
        serialNumber: 0
    ),
    firmwareUpdate: FirmwareUpdateModel(visible: false,
        firmware_file: "/Applications/Ableton Live 9 Suite.app/Contents/App-Resources/MIDI Remote Scripts/Push2/firmware/FlashData.bin",
        data_file: "/Applications/Ableton Live 9 Suite.app/Contents/App-Resources/MIDI Remote Scripts/Push2/firmware/app_push2_1.0.44.upgrade",
        state: "welcome"
    )
)

let cmd = PushCommand(command: "full-model-update", payload: model)

func tryToBeLive() {
    system("/Applications/Ableton\\ Live\\ 9\\ Suite.app/Contents/Push2/Push2DisplayProcess.app/Contents/MacOS/Push2DisplayProcess --push2-log-to-console --push2-log-level=debug --push2-mode=emulator &")
    
    let sock = NanoMsgSocket(boundTo: "push2ipc")
    
    //let all_jsons = NSArray(contentsOfFile: "/tmp/all-jsons")! as! [String]
    
    let the_json : String = try! NSString(contentsOfFile: "/Users/willy/ableton.json", encoding: NSUTF8StringEncoding) as String
    
    sleep(3)
    
    while true {
        let maybeThing = sock.receive()
        if let thing = maybeThing {
            let command  = thing[0..<4]
            let rest     = thing[4..<thing.count]
            
            if command == [0, 0, 0, 0] {
                sock.send([1, 0, 0, 0])
//                sock.send([3, 0, 0, 0] + the_json.toBytes())
                sock.send([3, 0, 0, 0] + cmd.toJSON()!.toBytes())
            }
            else {
                print("unknown command: \(thing) \(rest)")
            }
        }
    }
}


tryToBeLive()