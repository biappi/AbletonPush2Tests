//
//  Push2Model.swift
//  nanotests
//
//  Created by Antonio Malara on 24/06/16.
//  Copyright © 2016 Antonio Malara. All rights reserved.
//

import Foundation

struct Track {
    var name : String = "" 
    var colorIndex : Int = 0
    var isFoldable : Bool = false
    var containsDrumRack : Bool = false 
    var canShowChains : Bool = false 
    var nestingLevel : Int = 0 
    var activated : Bool = false 
    var isFrozen : Bool = false 
    var parentColorIndex : Int = 0 
    var arm : Bool = false 
    var isMaster : Bool = false 
    var isAudio : Bool = false 
    var id : Int = 0
}

struct TrackListModel {
    var visible : Bool = false 
    var tracks : [Track] = [] 
    var selectedTrack = Track()
    var absolute_selected_track_index : Int = 0 
}

struct Device {
    var name : String = "" 
    var nestingLevel : Int = 0 
    var is_active : Bool = false 
    var id : Int = 0 
    var class_name : String = "" 
    var icon : String = "" 
}

struct DeviceListModel {
    var visible : Bool = false 
    var items : [Device] = [] 
    var selectedItem = Device()
    var moving : Bool = false 
}

struct ItemSlotModel {
    var name : String = "" 
    var icon : String = "" 
    
}
struct ParameterBankListModel {
    var visible : Bool = false 
    var items : [ItemSlotModel] = [] 
    var selectedItem = ItemSlotModel()
}

struct EditModeOption {
    var firstChoice : String = "" 
    var secondChoice : String = "" 
    var activeIndex : Int = 0 
    var active : Bool = false 
}

struct EditModeOptionsModel {
    var visible : Bool = false 
    var device : String = "" 
    var options : [EditModeOption] = [] 
}

struct Chain {
    var name : String = "" 
    var id : Int = 0
    var icon : String = "" 
}

struct ChainListModel {
    var visible : Bool = false 
    var items : [Chain] = [] 
    var selectedItem = Chain()
}

struct MixerSelectionListModel {
    var visible : Bool = false 
    var items : [ItemSlotModel] = [] 
    var selectedItem : String = "" 
}

struct TrackMixerSelectionListModel {
    var visible : Bool = false 
    var items : [ItemSlotModel] = [] 
}

struct DeviceParameter {
    var name : String = "" 
    var original_name : String = "" 
    var min = Float()
    var max = Float()
    var value = Float()
    var valueItems : [String] = [] 
    var displayValue : String = "" 
    var unit : String = "" 
    var id : Int = 0 
    var is_enabled : Bool = false 
    var hasAutomation : Bool = false 
    var automationActive : Bool = false 
    var isActive : Bool = false 
}

struct Encoder {
    var id : Int = 0
    var touched : Bool = false 
}

struct Controls {
    var encoders : [Encoder] = [] 
}

struct Slice {
    var id : Int = 0 
    var time : Int = 0 
}

struct Sample {
    var start_marker : Int = 0 
    var end_marker : Int = 0 
    var length : Int = 0 
}

struct SimplerView {
    var sample_start : Int = 0 
    var sample_end : Int = 0 
    var sample_loop_start : Int = 0 
    var sample_loop_end : Int = 0 
    var sample_loop_fade : Int = 0 
    var sample_env_fade_in : Int = 0 
    var sample_env_fade_out : Int = 0 
    
}
struct WaveformNavigationFocusMarker {
    var name : String = "" 
    var position : Int = 0 
    
}
struct WaveformNavigation {
    var animate_visible_region : Bool = false 
    var visible_start = Float()
    var visible_end = Float()
    var show_focus : Bool = false 
    var focus_marker = WaveformNavigationFocusMarker()
}

struct SimplerProperties {
    var sample_start = DeviceParameter()
    var sample_length = DeviceParameter()
    var loop_length = DeviceParameter()
    var loop_on = DeviceParameter()
    var zoom = DeviceParameter()
    var gain = Float()
    var start_marker : Int = 0 
    var end_marker : Int = 0 
    var multi_sample_mode : Bool = false 
    var current_playback_mode : Int = 0 
    var slices : [Slice] = [] 
    var selected_slice = Slice()
    var playhead_real_time_channel_id : String = "" 
    var waveform_real_time_channel_id : String = "" 
    var sample = Sample()
    var view = SimplerView()
    var waveform_navigation = WaveformNavigation()
}

struct DeviceParameterListModel {
    var visible : Bool = false 
    var deviceType : String = "" 
    var parameters : [DeviceParameter] = [] 
}

struct SimplerDeviceViewModel {
    var visible : Bool = false 
    var deviceType : String = "" 
    var simpler = Device()
    var parameters : [DeviceParameter] = [] 
    var properties = SimplerProperties()
    var wants_waveform_shown : Bool = false 
    var processed_zoom_requests : Int = 0 
    
}
struct RealTimeChannel {
    var channel_id : String = "" 
    var object_id : String = "" 
    
}
struct TrackControlModel {
    var visible : Bool = false 
    var parameters : [DeviceParameter] = [] 
    var scrollOffset : Int = 0 
    var real_time_meter_channel = RealTimeChannel()
}

struct BrowserListView {
    var id : Int = 0
    var selected_index : Int = 0 
}

struct BrowserItem {
    var id : Int = 0
    var name : String = "" 
    var icon : String = "" 
    var is_loadable : Bool = false 
}

struct BrowserModel {
    var visible : Bool = false 
    var lists : [BrowserListView] = [] 
    var scrolling : Bool = false 
    var horizontal_navigation : Bool = false 
    var focused_list_index : Int = 0 
    var focused_item = BrowserItem()
    var list_offset : Int = 0 
    var can_enter : Bool = false 
    var can_exit : Bool = false 
    var expanded : Bool = false 
    var load_text : String = "" 
    var prehear_enabled : Bool = false 
    var context_text : String = "" 
    var context_color_index : Int = 0 
}

struct BrowserList {
    var id : Int = 0
    var items : [BrowserItem] = [] 
}

struct BrowserData {
    var lists : [BrowserList] = [] 
    
}
struct Notification {
    var visible : Bool = false 
    var message : String = "" 
}

struct RealTimeClient {
    var clientId : String = "" 
    
}
struct ConvertModel {
    var source_color_index : Int = 0 
    var source_name : String = "" 
    var visible : Bool = false 
    var available_conversions : [String] = [] 
}

struct NoteLayout {
    var is_in_key : Bool = false 
    var is_fixed : Bool = false 
    
}
struct ScalesModel {
    var visible : Bool = false 
    var scale_names : [String] = [] 
    var selected_scale_index : Int = 0 
    var root_note_names : [String] = [] 
    var selected_root_note_index : Int = 0 
    var note_layout = NoteLayout()
    var horizontal_navigation : Bool = false 
}

struct QuantizeSettingsModel {
    var visible : Bool = false 
    var swing_amount = Float()
    var quantize_to_index : Int = 0 
    var quantize_amount = Float()
    var record_quantization_index : Int = 0 
    var record_quantization_enabled : Bool = false 
    var quantization_option_names : [String] = [] 
}

struct StepSettingsModel {
    var visible : Bool = false 
    
}
struct StepAutomationSettingsModel {
    var visible : Bool = false 
    var deviceType : String = "" 
    var parameters : [DeviceParameter] = [] 
    var can_automate_parameters : Bool = false 
}

struct NoteSettingModel {
    var min = Float()
    var max = Float()
}

struct NoteSettingsModel {
    var nudge = NoteSettingModel()
    var coarse = NoteSettingModel()
    var fine = NoteSettingModel()
    var velocity = NoteSettingModel()
    var color_index : Int = 0 
    var visible : Bool = false 
}

struct FixedLengthSettingsModel {
    var option_names : [String] = [] 
    var selected_index : Int = 0 
    var enabled : Bool = false 
}

struct FixedLengthSelectorModel {
    var visible : Bool = false 
}

struct LoopSettingsModel {
    var looping : Bool = false 
    var loop_parameters : [DeviceParameter] = [] 
    var zoom = DeviceParameter()
    var processed_zoom_requests : Int = 0 
    var waveform_navigation = WaveformNavigation()
}
struct AudioClipSettingsModel {
    var warping : Bool = false 
    var gain = Float()
    var audio_parameters : [DeviceParameter] = [] 
    var waveform_real_time_channel_id : String = "" 
    var playhead_real_time_channel_id : String = "" 
}

struct ClipViewModel {
    var sample_length : Int = 0 
    var sample_start_marker : Int = 0 
    var sample_end_marker : Int = 0 
    var sample_loop_start : Int = 0 
    var sample_loop_end : Int = 0 
}

struct ClipModel {
    var id : Int = 0
    var name : String = "" 
    var color_index : Int = 0 
    var is_recording : Bool = false 
    var view = ClipViewModel()
}

struct ClipControlModel {
    var clip = ClipModel()
}

struct ModeState {
    var main_mode : String = "" 
    var mix_mode : String = "" 
    var global_mix_mode : String = "" 
    var device_mode : String = "" 
}

struct MixerRealTimeMeterModel {
    var real_time_meter_channel_ids : [String] = [] 
}

struct MixerViewModel {
    var volumeControlListView = DeviceParameterListModel()
    var panControlListView = DeviceParameterListModel()
    var trackControlView = TrackControlModel()
    var sendControlListView = DeviceParameterListModel()
    var realtimeMeterData : [RealTimeChannel] = [] 
}

struct GeneralSettingsModel {
    var workflow : String = "" 
}

struct PadSettingsModel {
    var sensitivity : Int = 0 
    var min_sensitivity : Int = 0 
    var max_sensitivity : Int = 0 
    var gain : Int = 0 
    var min_gain : Int = 0 
    var max_gain : Int = 0 
    var dynamics : Int = 0 
    var min_dynamics : Int = 0 
    var max_dynamics : Int = 0 
}

struct HardwareSettingsModel {
    var min_led_brightness : Int = 0 
    var max_led_brightness : Int = 0 
    var led_brightness : Int = 0 
    var min_display_brightness : Int = 0 
    var max_display_brightness : Int = 0 
    var display_brightness : Int = 0 
}

struct DisplayDebugSettingsModel {
    var show_row_spaces : Bool = false 
    var show_row_margins : Bool = false 
    var show_row_middle : Bool = false 
    var show_button_spaces : Bool = false 
    var show_unlit_button : Bool = false 
    var show_lit_button : Bool = false 
}

struct ProfilingSettingsModel {
    var show_qml_stats : Bool = false 
    var show_usb_stats : Bool = false 
    var show_realtime_ipc_stats : Bool = false 
}

struct ExperimentalSettingsModel {
    var new_waveform_navigation : Bool = false 
}

struct SettingsModel {
    var general = GeneralSettingsModel()
    var pad_settings = PadSettingsModel()
    var hardware = HardwareSettingsModel()
    var display_debug = DisplayDebugSettingsModel()
    var profiling = ProfilingSettingsModel()
    var experimental = ExperimentalSettingsModel()
}

struct VelocityCurveModel {
    var curve_points : [Int] = [] 
}

struct SetupModel {
    var visible : Bool = false 
    var settings = SettingsModel()
    var selected_mode : String = "" 
    var modes : [String] = [] 
    var velocity_curve = VelocityCurveModel()
}

struct ValueModel {
    var visible : Bool = false 
    var value_string : String = "" 
    
}
struct ImportantGlobals {
    var masterVolume = ValueModel()
    var cueVolume = ValueModel()
    var swing = ValueModel()
    var tempo = ValueModel()
}

struct FirmwareInfo {
    var major : Int = 0 
    var minor : Int = 0 
    var build : Int = 0 
    var serialNumber : Int = 0 
}

struct FirmwareUpdateModel {
    var visible : Bool = false 
    var firmware_file : String = "" 
    var data_file : String = "" 
    var state : String = "" 
}

struct LiveDialogViewModel {
    var visible : Bool = false 
    var text : String = "" 
    var can_cancel : Bool = false 
}

struct RootModel {
    var notificationView = Notification()
    var realTimeClient = RealTimeClient()
    var modeState = ModeState()
    var controls = Controls()
    var liveDialogView = LiveDialogViewModel()
    var mixerSelectView = MixerSelectionListModel()
    var trackMixerSelectView = TrackMixerSelectionListModel()
    var devicelistView = DeviceListModel()
    var editModeOptionsView = EditModeOptionsModel()
    var deviceParameterView = DeviceParameterListModel()
    var simplerDeviceView = SimplerDeviceViewModel()
    var mixerView = MixerViewModel()
    var tracklistView = TrackListModel()
    var chainListView = ChainListModel()
    var parameterBankListView = ParameterBankListModel()
    var browserView = BrowserModel()
    var browserData = BrowserData()
    var convertView = ConvertModel()
    var scalesView = ScalesModel()
    var quantizeSettingsView = QuantizeSettingsModel()
    var fixedLengthSelectorView = FixedLengthSelectorModel()
    var fixedLengthSettings = FixedLengthSettingsModel()
    var noteSettingsView = NoteSettingsModel()
    var stepSettingsView = StepSettingsModel()
    var stepAutomationSettingsView = StepAutomationSettingsModel()
    var audioClipSettingsView = AudioClipSettingsModel()
    var loopSettingsView = LoopSettingsModel()
    var clipView = ClipControlModel()
    var setupView = SetupModel()
    var importantGlobals = ImportantGlobals()
    var firmwareInfo = FirmwareInfo()
    var firmwareUpdate = FirmwareUpdateModel()
}

/* - */

struct PushCommand {
    var command : String = ""
    var payload = RootModel()
}