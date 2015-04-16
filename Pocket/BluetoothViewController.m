//
//  ViewController.m
//  MusicBlueb
//
//  Created by Arthur Berman on 3/21/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//
#import "BluetoothViewController.h"
#import "CoreAudioKit/CABTMIDICentralViewController.h"
@import CoreMIDI;
#import "CoreAudioKit/CABTMIDILocalPeripheralViewController.h"
#import "MIKMIDI.h"
#import "Pocket-Swift.h"

@interface BluetoothViewController ()
@property (weak, nonatomic) IBOutlet UILabel *noteGet;

@end

@implementation BluetoothViewController
int curnote = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)doneAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)configureCentral:(id)sender
{
    CABTMIDICentralViewController *vController = [CABTMIDICentralViewController new];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vController];
    
    // this will present a view controller as a popover in iPad and modal VC on iPhone
    vController.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(doneAction:)];
    
    navController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popC = navController.popoverPresentationController;
    popC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popC.sourceRect = [sender frame];
    
    UIButton *button = (UIButton *)sender;
    popC.sourceView = button.superview;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)configureLocalPeripheral:(UIButton *)sender {
    CABTMIDILocalPeripheralViewController *vController = [[CABTMIDILocalPeripheralViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vController];
    
    // this will present a view controller as a popover in iPad and modal VC on iPhone
    vController.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(doneAction:)];
    
    navController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popC = navController.popoverPresentationController;
    popC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popC.sourceRect = [sender frame];
    
    UIButton *button = (UIButton *)sender;
    popC.sourceView = button.superview;
    
    [MaestroPuredataBridge setDelegate:self];
    [self presentViewController:navController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendNote:(int) channel pitch:(int) note velocity:(int) velocity {
    MIKMIDIDeviceManager *manager = [MIKMIDIDeviceManager sharedDeviceManager];
    NSArray *availableMIDIDevices = [manager availableDevices];
    for (MIKMIDIDevice *device in availableMIDIDevices) {
        NSLog(@"name %@", device.name);
        for (MIKMIDIEntity *entity in device.entities) {
            NSLog(@"entities %@", entity.name);
            //currently sends notes to every connected device. There should only ever be one, so this should work.
            for (MIKMIDIDestinationEndpoint *destination in entity.destinations){
                NSError *error = nil;
                MIKMutableMIDINoteOnCommand *command = [[MIKMutableMIDINoteOnCommand alloc] init];
                command.note = note;
                command.velocity = velocity;
                command.channel = channel;
                NSLog(@"note %lu", command.note);
                NSArray *commands = [NSArray arrayWithObjects:command, nil];
                [manager sendCommands:commands toEndpoint:destination error:&error];
                NSLog(@"Destination");
                NSLog(@"help");
                
            }
        }
    }
    
}

- (IBAction)activateReceipt:(id)sender {
    
    MIKMIDIDeviceManager *manager = [MIKMIDIDeviceManager sharedDeviceManager];
    NSArray *availableMIDIDevices = [manager availableDevices];
    for (MIKMIDIDevice *device in availableMIDIDevices) {
        NSLog(@"name %@", device.name);
        for (MIKMIDIEntity *entity in device.entities) {
            NSLog(@"entities %@", entity.name);
            int i = 0;
            for (MIKMIDISourceEndpoint *source in entity.sources){
                NSError *error = nil;
                NSLog(@"%@", source.name);
                if (!([manager.connectedInputSources containsObject:source])){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addInstrument" object:nil];
                    BOOL success = [manager connectInput:source error:&error eventHandler: //use a lambda expression to handle the incoming notes
                                    ^(MIKMIDISourceEndpoint *source, NSArray *commands) {
                                        for (MIKMIDINoteOnCommand *command in commands) {
                                            // Handle each command
                                            NSLog(@"%lu", (unsigned long)command.note);
                                            [MaestroPuredataBridge sendNoteOn:11 + i pitch:command.note + 12 velocity:command.velocity];
                                        }
                                    }];
                    i++;
                    if (!success) {
                        NSLog(@"Unable to connect to %@: %@", source, error);
                        // Handle the error
                    } else {
                        NSLog(@"Connected");
                    }
                } else {
                    NSLog(@"Already connected");
                }
            }
        }
    }
}
@end
