//
//  MavLinkUtility.m
//  iGCS
//
//  Created by Claudio Natoli on 21/07/13.
//
//

#import "MavLinkUtility.h"

@implementation MavLinkUtility

NSMutableDictionary *missionItemMetaData;

+ (void) initialize {
    if (self == [MavLinkUtility class]) {
        // Define the list of mission item meta-data
        missionItemMetaData = [[NSMutableDictionary alloc] init];
        
        // NAV mission items
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Altitude" units:kUNIT_M andType:kPARAM_Z], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_NAV_WAYPOINT]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Altitude" units:kUNIT_M andType:kPARAM_Z], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_NAV_LOITER_UNLIM]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Altitude" units:kUNIT_M andType:kPARAM_Z],
                                        [[MissionItemField alloc] initWithLabel:@"# Turns"                andType:kPARAM_1], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_NAV_LOITER_TURNS]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Altitude" units:kUNIT_M andType:kPARAM_Z],
                                        // FIXME: test this - older docs say (seconds*10), code suggests it is in seconds
                                        [[MissionItemField alloc] initWithLabel:@"Time"     units:kUNIT_S andType:kPARAM_1], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_NAV_LOITER_TIME]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Altitude" units:kUNIT_M andType:kPARAM_Z], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_NAV_RETURN_TO_LAUNCH]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Altitude" units:kUNIT_M andType:kPARAM_Z], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_NAV_LAND]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Altitude"      units:kUNIT_M   andType:kPARAM_Z],
                                        [[MissionItemField alloc] initWithLabel:@"Takeoff Pitch" units:kUNIT_DEG andType:kPARAM_1], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_NAV_TAKEOFF]];
        
        // Conditional CMD mission items
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Time" units:kUNIT_S andType:kPARAM_3], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_CONDITION_DELAY]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Rate"              units:kUNIT_CM_S andType:kPARAM_1],
                                        [[MissionItemField alloc] initWithLabel:@"Final Altitude" units:kUNIT_M    andType:kPARAM_2], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_CONDITION_CHANGE_ALT]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Distance" units:kUNIT_M andType:kPARAM_3], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_CONDITION_DISTANCE]];
        
        // DO CMD mission items
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Index"        andType:kPARAM_1],
                                        [[MissionItemField alloc] initWithLabel:@"Repeat Count" andType:kPARAM_3], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_DO_JUMP]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Speed type"                   andType:kPARAM_1],
                                        [[MissionItemField alloc] initWithLabel:@"Speed"        units:kUNIT_M_S andType:kPARAM_2],
                                        [[MissionItemField alloc] initWithLabel:@"Throttle (%)"                 andType:kPARAM_3], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_DO_CHANGE_SPEED]];
        
        /* FIXME: review implementation of do_set_home - appears that lat/lon/alt are from x/y/z a(nd not param2/3/4 as per earlier doc)
         [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
         [[MissionItemField alloc] initWithLabel:@"Use current" andType:kPARAM_1],
         [[MissionItemField alloc] initWithLabel:@"Altitude"    andType:kPARAM_2],
         [[MissionItemField alloc] initWithLabel:@"Latitude"    andType:kPARAM_3],
         [[MissionItemField alloc] initWithLabel:@"Longitude"   andType:kPARAM_4], nil]
         forKey:[NSNumber numberWithInt: MAV_CMD_DO_SET_HOME]];
         */
        
        /*
         [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
         [[MissionItemField alloc] initWithLabel:@"Param #"     andType:kPARAM_1],
         [[MissionItemField alloc] initWithLabel:@"Param Value" andType:kPARAM_2], nil]
         forKey:[NSNumber numberWithInt: MAV_CMD_DO_SET_PARAMETER]];
         */
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Relay #" andType:kPARAM_1],
                                        [[MissionItemField alloc] initWithLabel:@"On/Off"  andType:kPARAM_2], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_DO_SET_RELAY]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Relay #"                   andType:kPARAM_1],
                                        [[MissionItemField alloc] initWithLabel:@"Cycle count"               andType:kPARAM_2],
                                        [[MissionItemField alloc] initWithLabel:@"Cycle time"  units:kUNIT_S andType:kPARAM_3], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_DO_REPEAT_RELAY]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Servo # (5-8)" andType:kPARAM_1],
                                        [[MissionItemField alloc] initWithLabel:@"On/Off"        andType:kPARAM_2], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_DO_SET_SERVO]];
        [missionItemMetaData setObject:[[NSArray alloc] initWithObjects:
                                        [[MissionItemField alloc] initWithLabel:@"Servo # (5-8)"            andType:kPARAM_1],
                                        [[MissionItemField alloc] initWithLabel:@"Cycle count"              andType:kPARAM_2],
                                        [[MissionItemField alloc] initWithLabel:@"Cycle time" units:kUNIT_S andType:kPARAM_3], nil]
                                forKey:[NSNumber numberWithInt: MAV_CMD_DO_REPEAT_SERVO]];
    }
}

+ (NSString*) mavModeEnumToString:(enum MAV_MODE)mode {
    NSString *str = [NSString stringWithFormat:@""];
    if (mode & MAV_MODE_FLAG_TEST_ENABLED)          str = [str stringByAppendingString:@"Test "];
    if (mode & MAV_MODE_FLAG_AUTO_ENABLED)          str = [str stringByAppendingString:@"Auto "];
    if (mode & MAV_MODE_FLAG_GUIDED_ENABLED)        str = [str stringByAppendingString:@"Guided "];
    if (mode & MAV_MODE_FLAG_STABILIZE_ENABLED)     str = [str stringByAppendingString:@"Stabilize "];
    if (mode & MAV_MODE_FLAG_HIL_ENABLED)           str = [str stringByAppendingString:@"HIL "];
    if (mode & MAV_MODE_FLAG_MANUAL_INPUT_ENABLED)  str = [str stringByAppendingString:@"Manual "];
    if (mode & MAV_MODE_FLAG_CUSTOM_MODE_ENABLED)   str = [str stringByAppendingString:@"Custom "];
    if (!(mode & MAV_MODE_FLAG_SAFETY_ARMED))       str = [str stringByAppendingString:@"(Disarmed)"];
    return str;
}

+ (NSString*) mavStateEnumToString:(enum MAV_STATE)state {
    switch (state) {
        case MAV_STATE_UNINIT:      return @"Uninitialized";
        case MAV_STATE_BOOT:        return @"Boot";
        case MAV_STATE_CALIBRATING: return @"Calibrating";
        case MAV_STATE_STANDBY:     return @"Standby";
        case MAV_STATE_ACTIVE:      return @"Active";
        case MAV_STATE_CRITICAL:    return @"Critical";
        case MAV_STATE_EMERGENCY:   return @"Emergency";
        case MAV_STATE_POWEROFF:    return @"Power Off";
        case MAV_STATE_ENUM_END:    break;
    }
    return [NSString stringWithFormat:@"MAV_STATE (%d)", state];
}

+ (NSString*) mavCustomModeToString:(int)customMode {
    switch (customMode) {
        case MANUAL:        return @"Manual";
        case CIRCLE:        return @"Circle";
        case STABILIZE:     return @"Stabilize";
        case FLY_BY_WIRE_A: return @"FBW_A";
        case FLY_BY_WIRE_B: return @"FBW_B";
        case FLY_BY_WIRE_C: return @"FBW_C";
        case AUTO:          return @"Auto";
        case RTL:           return @"RTL";
        case LOITER:        return @"Loiter";
        case TAKEOFF:       return @"Takeoff";
        case LAND:          return @"Land";
        case GUIDED:        return @"Guided";
        case INITIALISING:  return @"Initialising";
            
    }
    return [NSString stringWithFormat:@"CUSTOM_MODE (%d)", customMode];
}


+ (NSArray*) supportedMissionItemTypes {
    return [missionItemMetaData allKeys];
}

+ (NSArray*) getMissionItemMetaData:(uint16_t)command {
    return [missionItemMetaData objectForKey: [NSNumber numberWithInt: command]];
}

@end
