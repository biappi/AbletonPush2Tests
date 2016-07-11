//
//  PushJSON.swift
//  nanotests
//
//  Created by Antonio Malara on 26/06/16.
//  Copyright © 2016 Antonio Malara. All rights reserved.
//

import Foundation


protocol JSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}

protocol JSONSerializable: JSONRepresentable {}

extension JSONSerializable {
    var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as JSONRepresentable:
                representation[label] = value.JSONRepresentation
                
            case let value as NSObject:
                representation[label] = value
                
            default:
                // Ignore any unserializable properties
                break
            }
        }
        
        return representation
    }
}

extension JSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation
        
        guard NSJSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(representation, options: [])
            return String(data: data, encoding: NSUTF8StringEncoding)
        } catch {
            return nil
        }
    }
}

extension Track : JSONSerializable {}
extension TrackListModel : JSONSerializable {}
extension Device : JSONSerializable {}
extension DeviceListModel : JSONSerializable {}
extension ItemSlotModel : JSONSerializable {}
extension ParameterBankListModel : JSONSerializable {}
extension EditModeOption : JSONSerializable {}
extension EditModeOptionsModel : JSONSerializable {}
extension Chain : JSONSerializable {}
extension ChainListModel : JSONSerializable {}
extension MixerSelectionListModel : JSONSerializable {}
extension TrackMixerSelectionListModel : JSONSerializable {}
extension DeviceParameter : JSONSerializable {}
extension Encoder : JSONSerializable {}
extension Controls : JSONSerializable {}
extension Slice : JSONSerializable {}
extension Sample : JSONSerializable {}
extension SimplerView : JSONSerializable {}
extension WaveformNavigationFocusMarker : JSONSerializable {}
extension WaveformNavigation : JSONSerializable {}
extension SimplerProperties : JSONSerializable {}
extension DeviceParameterListModel : JSONSerializable {}
extension SimplerDeviceViewModel : JSONSerializable {}
extension RealTimeChannel : JSONSerializable {}
extension TrackControlModel : JSONSerializable {}
extension BrowserListView : JSONSerializable {}
extension BrowserItem : JSONSerializable {}
extension BrowserModel : JSONSerializable {}
extension BrowserList : JSONSerializable {}
extension BrowserData : JSONSerializable {}
extension Notification : JSONSerializable {}
extension RealTimeClient : JSONSerializable {}
extension ConvertModel : JSONSerializable {}
extension NoteLayout : JSONSerializable {}
extension ScalesModel : JSONSerializable {}
extension QuantizeSettingsModel : JSONSerializable {}
extension StepSettingsModel : JSONSerializable {}
extension StepAutomationSettingsModel : JSONSerializable {}
extension NoteSettingModel : JSONSerializable {}
extension NoteSettingsModel : JSONSerializable {}
extension FixedLengthSettingsModel : JSONSerializable {}
extension FixedLengthSelectorModel : JSONSerializable {}
extension LoopSettingsModel : JSONSerializable {}
extension AudioClipSettingsModel : JSONSerializable {}
extension ClipViewModel : JSONSerializable {}
extension ClipModel : JSONSerializable {}
extension ClipControlModel : JSONSerializable {}
extension ModeState : JSONSerializable {}
extension MixerRealTimeMeterModel : JSONSerializable {}
extension MixerViewModel : JSONSerializable {}
extension GeneralSettingsModel : JSONSerializable {}
extension PadSettingsModel : JSONSerializable {}
extension HardwareSettingsModel : JSONSerializable {}
extension DisplayDebugSettingsModel : JSONSerializable {}
extension ProfilingSettingsModel : JSONSerializable {}
extension ExperimentalSettingsModel : JSONSerializable {}
extension SettingsModel : JSONSerializable {}
extension VelocityCurveModel : JSONSerializable {}
extension SetupModel : JSONSerializable {}
extension ValueModel : JSONSerializable {}
extension ImportantGlobals : JSONSerializable {}
extension FirmwareInfo : JSONSerializable {}
extension FirmwareUpdateModel : JSONSerializable {}
extension LiveDialogViewModel : JSONSerializable {}
extension RootModel : JSONSerializable {}
extension PushCommand : JSONSerializable {}

