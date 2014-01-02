//
//  AppDelegate.h
//  NoSync
//
//  Created by 3x7R00Tripper on 28.12.13.
//  Copyright (c) 2013 3x7R00Tripper. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MobileDevice.h"
#import <Foundation/Foundation.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    
    __unsafe_unretained NSWindow *_window;
    
    __weak NSProgressIndicator *_loadingInd;
    __weak NSTextField *_deviceDetails;
    
}
- (IBAction)installprofile:(id)sender;
- (IBAction)openprofiledir:(id)sender;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *profiledir;
- (IBAction)installipa:(id)sender;
@property (weak) IBOutlet NSTextField *ipadir;
- (IBAction)openipadir:(id)sender;
- (IBAction)listallapps:(id)sender;
@property (weak) IBOutlet NSTextField *appname;
- (IBAction)uninstallapps:(id)sender;
- (IBAction)removeapparchive:(id)sender;
- (IBAction)v1byme:(id)sender;
- (IBAction)donate:(id)sender;
- (IBAction)followmeandteam:(id)sender;
@property (weak) IBOutlet NSProgressIndicator *loadingInd;
- (IBAction)setup:(id)sender;

- (void)populateData;
- (void)dePopulateData;
- (void)recoveryCallback;
- (void)setup;
- (void)loadingProgress;
- (void)enterRecovery;
- (NSString *)getDeviceValue:(NSString *)value;


@property (weak) IBOutlet NSTextField *deviceDetails;

@end
