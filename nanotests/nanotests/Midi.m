//
//  Midi.m
//  nanotests
//
//  Created by Antonio Malara on 21/06/16.
//  Copyright © 2016 Antonio Malara. All rights reserved.
//

#import "Midi.h"

#import <CoreMIDI/CoreMIDI.h>

static void InputPortCallback(const MIDIPacketList * pktlist, void * refCon, void * connRefCon);

@implementation Midi
{
    MIDIClientRef   client;
    
    MIDIEndpointRef source;
    MIDIEndpointRef destination;
}

- (void)listen:(id<MidiDelegate>)delegate name:(NSString *)name;
{
    CFStringRef theName = (__bridge CFStringRef)(name);
    SInt32 uniqueId = (SInt32)name.hash;
    
    MIDIClientCreate(theName, NULL, NULL, &client);
    MIDIObjectSetIntegerProperty(client, kMIDIPropertyUniqueID, uniqueId);
    
    MIDISourceCreate(client, theName, &source);
    MIDIObjectSetIntegerProperty(source, kMIDIPropertyUniqueID, uniqueId + 1);
    
    MIDIDestinationCreate(client, theName, InputPortCallback, (__bridge void * _Nullable)(delegate), &destination);
    MIDIObjectSetIntegerProperty(destination, kMIDIPropertyUniqueID, uniqueId + 2);
}

- (void)sendMidiBytes:(const uint8_t *)bytes count:(size_t)count;
{
    char packetListData[1024];
    
    MIDIPacketList * packetList = (MIDIPacketList *)packetListData;
    MIDIPacket     * curPacket  = NULL;
    
    curPacket = MIDIPacketListInit(packetList);
    curPacket = MIDIPacketListAdd(packetList, 1024, curPacket, 0, count, bytes);
    
    
    printf("sending midi: ");
    for (int i = 0; i < count; i++) printf("%02x ", bytes[i]);
    printf("\n");
    
    MIDIReceived(source, packetList);
}

@end


static void InputPortCallback(const MIDIPacketList * pktlist, void * refCon, void * connRefCon)
{
    MIDIPacket      * packet = (MIDIPacket *)pktlist->packet;
    id<MidiDelegate>  zelf   = (__bridge id<MidiDelegate>)refCon;
    
    @autoreleasepool {
        for (unsigned int j = 0; j < pktlist->numPackets; j++)
        {
            uint8_t * d = packet->data;
            uint8_t   c = d[0] & 0xF0;
            
            switch (d[0] & 0xF0)
            {
                case 0x90:
                    [zelf receivedNoteOnChannel:c note:d[1] velocity:d[2]];
                    break;
                    
                case 0xB0:
                    [zelf receivedControlChangeChannel:c controller:d[1] value:d[2]];
                    break;
                    
                case 0xD0:
                    [zelf receivedChannelPressureChannel:c value:(d[1] | (d[2] << 7))];
                    break;
                    
                case 0xF0:
                    [zelf receivedSysEx:packet->data len:packet->length];
                    break;
            }
            
            packet = MIDIPacketNext(packet);
        }
    }
}
