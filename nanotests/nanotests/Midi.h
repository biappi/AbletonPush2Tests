//
//  Midi.h
//  nanotests
//
//  Created by Antonio Malara on 21/06/16.
//  Copyright © 2016 Antonio Malara. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MidiDelegate

- (void)receivedNoteOnChannel:(uint8_t)channel note:(uint8_t)note velocity:(uint8_t)velocity;
- (void)receivedControlChangeChannel:(uint8_t)channel controller:(uint8_t)controller value:(uint8_t)value;
- (void)receivedChannelPressureChannel:(uint8_t)channel value:(uint8_t)value;
- (void)receivedPitchWheelChannel:(uint8_t)channel value:(uint16_t)value;
- (void)receivedSysEx:(uint8_t *)data len:(NSInteger)len;
@end

@interface Midi : NSObject

- (void)listen:(id<MidiDelegate>)delegate name:(NSString *)name;
- (void)sendMidiBytes:(const uint8_t *)bytes count:(size_t)count;

@end
