//
//  PdBridge.h
//  padpod
//
//  Created by Arthur Berman on 1/30/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdBase.h"
#import "PdDispatcher.h"
#import "PdAudioController.h"

@interface PdBridge : UIImageView <PdReceiverDelegate>
@property  PdAudioController *controller;
@property PdDispatcher *dispatcher;
-(void) initialize;
-(void) play;
-(void) changePitchTo:(float)pitch;
-(void) sendFloat:(float)val toReceive:(NSString*) name;
-(void) sendBangTo:(NSString*) name;
-(void) sendNote:(int)val toPitch:(int)pit toVelocity:(int)vel;
-(void) sendString:(NSString*)message withArguments:(NSArray*)list toReceiver:(NSString *)receiverName;
-(void) getNoteNumber;
-(void) addNewListener:(NSObject<PdListener>*)listener withSource: (NSString*) source;

@end
