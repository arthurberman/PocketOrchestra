//
//  PdBridge.m
//  padpod
//
//  Created by Arthur Berman on 1/30/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
// Bridging Implementation for PD

#import "PdBridge.h"
#import "PdAudioController.h"
#import "PdDispatcher.h"
#import "PdMidiDispatcher.h"
#import "PdBase.h"
#import "PdFile.h"


@implementation PdBridge 
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void) initialize { // initialize a pd controller object, used as a swift-compatible interface into PD functionality
    self.controller = [PdAudioController new] ;
    if([self.controller configurePlaybackWithSampleRate:44100 numberChannels:2 inputEnabled:YES mixingEnabled:YES] != PdAudioOK) {
        NSLog(@"Something went wrong with PD");
    }
    [PdBase openFile:@"synth.pd" path: [[NSBundle mainBundle] resourcePath]];
    [self.controller setActive:YES];
    
    self.dispatcher = [PdDispatcher new];
    [PdBase setDelegate:self.dispatcher];
    NSLog(@"Balls");
}
-(void) play { // start playing sound from PD
    
    [PdBase openFile:@"synth2.pd" path: [[NSBundle mainBundle] resourcePath]];
    NSLog(@"play");
}

-(void) changePitchTo:(float)pitch {
    
    [PdBase sendFloat:pitch toReceiver:@"beat"];
}

-(void) sendBangTo:(NSString*) name {
    [PdBase sendBangToReceiver:name];
}


-(void) sendFloat:(float)val toReceive:(NSString*) name {
    [PdBase sendFloat:val toReceiver:name];
}

-(void) sendNote:(int)val toPitch:(int) pit toVelocity:(int) vel {
    [PdBase sendNoteOn:val pitch:pit velocity:vel];
}

-(void) sendString:(NSString*)message withArguments:(NSArray*)list toReceiver:(NSString *)receiverName {
    [PdBase sendMessage:message withArguments:list toReceiver:receiverName];
}

-(void) getNoteNumber {
    [PdBase receiveMidi];
}
-(void)addNewListener:(NSObject<PdListener>*)listener withSource: (NSString*) source {
    [self.dispatcher addListener:listener forSource:source];
}
@end
