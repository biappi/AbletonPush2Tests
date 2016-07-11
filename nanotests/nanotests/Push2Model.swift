//
//  Push2Model.swift
//  nanotests
//
//  Created by Antonio Malara on 24/06/16.
//  Copyright © 2016 Antonio Malara. All rights reserved.
//

import Foundation

struct Track {
    var name : String 
    var colorIndex : Int 
    var isFoldable : Bool 
    var containsDrumRack : Bool 
    var canShowChains : Bool 
    var nestingLevel : Int 
    var activated : Bool 
    var isFrozen : Bool 
    var parentColorIndex : Int 
    var arm : Bool 
    var isMaster : Bool 
    var isAudio : Bool 
    var id : Int
}

struct TrackListModel {
    var visible : Bool 
    var tracks : [Track] 
    var selectedTrack : Track
    var absolute_selected_track_index : Int 
}

struct Device {
    var name : String 
    var nestingLevel : Int 
    var is_active : Bool 
    var id : Int 
    var class_name : String 
    var icon : String 
}

struct DeviceListModel {
    var visible : Bool 
    var items : [Device] 
    var selectedItem : Device 
    var moving : Bool 
}

struct ItemSlotModel {
    var name : String 
    var icon : String 
    
}
struct ParameterBankListModel {
    var visible : Bool 
    var items : [ItemSlotModel] 
    var selectedItem : ItemSlotModel
}

struct EditModeOption {
    var firstChoice : String 
    var secondChoice : String 
    var activeIndex : Int 
    var active : Bool 
}

struct EditModeOptionsModel {
    var visible : Bool 
    var device : String 
    var options : [EditModeOption] 
}

struct Chain {
    var name : String 
    var id : Int
    var icon : String 
}

struct ChainListModel {
    var visible : Bool 
    var items : [Chain] 
    var selectedItem : Chain
}

struct MixerSelectionListModel {
    var visible : Bool 
    var items : [ItemSlotModel] 
    var selectedItem : String 
}

struct TrackMixerSelectionListModel {
    var visible : Bool 
    var items : [ItemSlotModel] 
}

struct DeviceParameter {
    var name : String 
    var original_name : String 
    var min : Float 
    var max : Float 
    var value : Float 
    var valueItems : [String] 
    var displayValue : String 
    var unit : String 
    var id : Int 
    var is_enabled : Bool 
    var hasAutomation : Bool 
    var automationActive : Bool 
    var isActive : Bool 
}

struct Encoder {
    var id : Int
    var touched : Bool 
}

struct Controls {
    var encoders : [Encoder] 
}

struct Slice {
    var id : Int 
    var time : Int 
}

struct Sample {
    var start_marker : Int 
    var end_marker : Int 
    var length : Int 
}

struct SimplerView {
    var sample_start : Int 
    var sample_end : Int 
    var sample_loop_start : Int 
    var sample_loop_end : Int 
    var sample_loop_fade : Int 
    var sample_env_fade_in : Int 
    var sample_env_fade_out : Int 
    
}
struct WaveformNavigationFocusMarker {
    var name : String 
    var position : Int 
    
}
struct WaveformNavigation {
    var animate_visible_region : Bool 
    var visible_start : Float 
    var visible_end : Float 
    var show_focus : Bool 
    var focus_marker : WaveformNavigationFocusMarker 
}

struct SimplerProperties {
    var sample_start : DeviceParameter 
    var sample_length : DeviceParameter 
    var loop_length : DeviceParameter 
    var loop_on : DeviceParameter 
    var zoom : DeviceParameter 
    var gain : Float 
    var start_marker : Int 
    var end_marker : Int 
    var multi_sample_mode : Bool 
    var current_playback_mode : Int 
    var slices : [Slice] 
    var selected_slice : Slice 
    var playhead_real_time_channel_id : String 
    var waveform_real_time_channel_id : String 
    var sample : Sample 
    var view : SimplerView 
    var waveform_navigation : WaveformNavigation
}

struct DeviceParameterListModel {
    var visible : Bool 
    var deviceType : String 
    var parameters : [DeviceParameter] 
}

struct SimplerDeviceViewModel {
    var visible : Bool 
    var deviceType : String 
    var simpler : Device
    var parameters : [DeviceParameter] 
    var properties : SimplerProperties 
    var wants_waveform_shown : Bool 
    var processed_zoom_requests : Int 
    
}
struct RealTimeChannel {
    var channel_id : String 
    var object_id : String 
    
}
struct TrackControlModel {
    var visible : Bool 
    var parameters : [DeviceParameter] 
    var scrollOffset : Int 
    var real_time_meter_channel : RealTimeChannel
}

struct BrowserListView {
    var id : Int
    var selected_index : Int 
}

struct BrowserItem {
    var id : Int
    var name : String 
    var icon : String 
    var is_loadable : Bool 
}

struct BrowserModel {
    var visible : Bool 
    var lists : [BrowserListView] 
    var scrolling : Bool 
    var horizontal_navigation : Bool 
    var focused_list_index : Int 
    var focused_item : BrowserItem
    var list_offset : Int 
    var can_enter : Bool 
    var can_exit : Bool 
    var expanded : Bool 
    var load_text : String 
    var prehear_enabled : Bool 
    var context_text : String 
    var context_color_index : Int 
}

struct BrowserList {
    var id : Int
    var items : [BrowserItem] 
}

struct BrowserData {
    var lists : [BrowserList] 
    
}
struct Notification {
    var visible : Bool 
    var message : String 
}

struct RealTimeClient {
    var clientId : String 
    
}
struct ConvertModel {
    var source_color_index : Int 
    var source_name : String 
    var visible : Bool 
    var available_conversions : [String] 
}

struct NoteLayout {
    var is_in_key : Bool 
    var is_fixed : Bool 
    
}
struct ScalesModel {
    var visible : Bool 
    var scale_names : [String] 
    var selected_scale_index : Int 
    var root_note_names : [String] 
    var selected_root_note_index : Int 
    var note_layout : NoteLayout
    var horizontal_navigation : Bool 
}

struct QuantizeSettingsModel {
    var visible : Bool 
    var swing_amount : Float 
    var quantize_to_index : Int 
    var quantize_amount : Float 
    var record_quantization_index : Int 
    var record_quantization_enabled : Bool 
    var quantization_option_names : [String] 
}

struct StepSettingsModel {
    var visible : Bool 
    
}
struct StepAutomationSettingsModel {
    var visible : Bool 
    var deviceType : String 
    var parameters : [DeviceParameter] 
    var can_automate_parameters : Bool 
}

struct NoteSettingModel {
    var min : Float 
    var max : Float 
}

struct NoteSettingsModel {
    var nudge : NoteSettingModel
    var coarse : NoteSettingModel
    var fine : NoteSettingModel
    var velocity : NoteSettingModel
    var color_index : Int 
    var visible : Bool 
}

struct FixedLengthSettingsModel {
    var option_names : [String] 
    var selected_index : Int 
    var enabled : Bool 
}

struct FixedLengthSelectorModel {
    var visible : Bool 
}

struct LoopSettingsModel {
    var looping : Bool 
    var loop_parameters : [DeviceParameter] 
    var zoom : DeviceParameter
    var processed_zoom_requests : Int 
    var waveform_navigation : WaveformNavigation
    
}
struct AudioClipSettingsModel {
    var warping : Bool 
    var gain : Float 
    var audio_parameters : [DeviceParameter] 
    var waveform_real_time_channel_id : String 
    var playhead_real_time_channel_id : String 
}

struct ClipViewModel {
    var sample_length : Int 
    var sample_start_marker : Int 
    var sample_end_marker : Int 
    var sample_loop_start : Int 
    var sample_loop_end : Int 
}

struct ClipModel {
    var id : Int
    var name : String 
    var color_index : Int 
    var is_recording : Bool 
    var view : ClipViewModel
}

struct ClipControlModel {
    var clip : ClipModel
}

struct ModeState {
    var main_mode : String 
    var mix_mode : String 
    var global_mix_mode : String 
    var device_mode : String 
}

struct MixerRealTimeMeterModel {
    var real_time_meter_channel_ids : [String] 
}

struct MixerViewModel {
    var volumeControlListView : DeviceParameterListModel
    var panControlListView : DeviceParameterListModel
    var trackControlView : TrackControlModel
    var sendControlListView : DeviceParameterListModel
    var realtimeMeterData : [RealTimeChannel] 
}

struct GeneralSettingsModel {
    var workflow : String 
}

struct PadSettingsModel {
    var sensitivity : Int 
    var min_sensitivity : Int 
    var max_sensitivity : Int 
    var gain : Int 
    var min_gain : Int 
    var max_gain : Int 
    var dynamics : Int 
    var min_dynamics : Int 
    var max_dynamics : Int 
}

struct HardwareSettingsModel {
    var min_led_brightness : Int 
    var max_led_brightness : Int 
    var led_brightness : Int 
    var min_display_brightness : Int 
    var max_display_brightness : Int 
    var display_brightness : Int 
}

struct DisplayDebugSettingsModel {
    var show_row_spaces : Bool 
    var show_row_margins : Bool 
    var show_row_middle : Bool 
    var show_button_spaces : Bool 
    var show_unlit_button : Bool 
    var show_lit_button : Bool 
}

struct ProfilingSettingsModel {
    var show_qml_stats : Bool 
    var show_usb_stats : Bool 
    var show_realtime_ipc_stats : Bool 
}

struct ExperimentalSettingsModel {
    var new_waveform_navigation : Bool 
}

struct SettingsModel {
    var general : GeneralSettingsModel
    var pad_settings : PadSettingsModel
    var hardware : HardwareSettingsModel
    var display_debug : DisplayDebugSettingsModel
    var profiling : ProfilingSettingsModel
    var experimental : ExperimentalSettingsModel
}

struct VelocityCurveModel {
    var curve_points : [Int] 
}

struct SetupModel {
    var visible : Bool 
    var settings : SettingsModel
    var selected_mode : String 
    var modes : [String] 
    var velocity_curve : VelocityCurveModel
}

struct ValueModel {
    var visible : Bool 
    var value_string : String 
    
}
struct ImportantGlobals {
    var masterVolume : ValueModel
    var cueVolume : ValueModel
    var swing : ValueModel
    var tempo : ValueModel
}

struct FirmwareInfo {
    var major : Int 
    var minor : Int 
    var build : Int 
    var serialNumber : Int 
}

struct FirmwareUpdateModel {
    var visible : Bool 
    var firmware_file : String 
    var data_file : String 
    var state : String 
}

struct LiveDialogViewModel {
    var visible : Bool 
    var text : String 
    var can_cancel : Bool 
}

struct RootModel {
    var notificationView : Notification 
    var realTimeClient : RealTimeClient 
    var modeState : ModeState 
    var controls : Controls 
    var liveDialogView : LiveDialogViewModel 
    var mixerSelectView : MixerSelectionListModel 
    var trackMixerSelectView : TrackMixerSelectionListModel 
    var devicelistView : DeviceListModel 
    var editModeOptionsView : EditModeOptionsModel 
    var deviceParameterView : DeviceParameterListModel 
    var simplerDeviceView : SimplerDeviceViewModel 
    var mixerView : MixerViewModel 
    var tracklistView : TrackListModel 
    var chainListView : ChainListModel 
    var parameterBankListView : ParameterBankListModel 
    var browserView : BrowserModel 
    var browserData : BrowserData 
    var convertView : ConvertModel 
    var scalesView : ScalesModel 
    var quantizeSettingsView : QuantizeSettingsModel 
    var fixedLengthSelectorView : FixedLengthSelectorModel 
    var fixedLengthSettings : FixedLengthSettingsModel 
    var noteSettingsView : NoteSettingsModel 
    var stepSettingsView : StepSettingsModel 
    var stepAutomationSettingsView : StepAutomationSettingsModel 
    var audioClipSettingsView : AudioClipSettingsModel 
    var loopSettingsView : LoopSettingsModel 
    var clipView : ClipControlModel 
    var setupView : SetupModel 
    var importantGlobals : ImportantGlobals 
    var firmwareInfo : FirmwareInfo 
    var firmwareUpdate : FirmwareUpdateModel 
}

/* - */

struct PushCommand {
    var command : String
    var payload : RootModel
}