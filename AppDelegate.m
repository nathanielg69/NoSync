//
//  AppDelegate.m
//  NoSync
//
//  Created by 3x7R00Tripper on 28.12.13.
//  Copyright (c) 2013 3x7R00Tripper. All rights reserved.
//

#import "AppDelegate.h"

static AppDelegate *classPointer;
struct am_device* device;
struct am_device_notification *notification;

void notification_callback(struct am_device_notification_callback_info *info, int cookie) {
	if (info->msg == ADNCI_MSG_CONNECTED) {
		NSLog(@"Device connected.");
		device = info->dev;
		AMDeviceConnect(device);
		AMDevicePair(device);
		AMDeviceValidatePairing(device);
		AMDeviceStartSession(device);
		[classPointer populateData];
	} else if (info->msg == ADNCI_MSG_DISCONNECTED) {
		NSLog(@"Device disconnected.");
		[classPointer dePopulateData];
	} else {
		NSLog(@"Received device notification: %d", info->msg);
	}
}

void recovery_connect_callback(struct am_recovery_device *rdev) {
	[classPointer recoveryCallback];
}

void recovery_disconnect_callback(struct am_recovery_device *rdev) {
	[classPointer dePopulateData];
}



@implementation AppDelegate

@synthesize ipadir;
@synthesize profiledir;
@synthesize appname;
@synthesize deviceDetails;
@synthesize loadingInd;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [window setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"bg.png"]]];

	classPointer = self;
	AMDeviceNotificationSubscribe(notification_callback, 0, 0, 0, &notification);
	AMRestoreRegisterForDeviceNotifications(recovery_disconnect_callback, recovery_connect_callback, recovery_disconnect_callback, recovery_disconnect_callback, 0, NULL);
	
	NSString *foundValue = [deviceDetails stringValue];
	
	if ([foundValue isEqualToString:@"Recovery Device Connected"]) {
		
        
	} else {
        
	}
    
	
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

- (void)enterRecovery {
	AMDeviceConnect(device);
	AMDeviceEnterRecovery(device);
}

- (void)recoveryCallback {
	[deviceDetails setStringValue:@"Recovery Device Connected"];
}

- (IBAction)setup:(id)sender {
        system("cd /usr/local; rm libimobiledevice-macosx; git clone https://github.com/3x7R00Tripper/libimobiledevice-macosx;");
}

- (void)populateData {
	NSString *serialNumber = [self getDeviceValue:@"SerialNumber"];
	NSString *modelNumber = [self getDeviceValue:@"ModelNumber"];
	NSString *deviceString = [self getDeviceValue:@"ProductType"];
	NSString *firmwareVersion = [self getDeviceValue:@"ProductVersion"];
	
	if ([deviceString isEqualToString:@"iPod1,1"]) {
		deviceString = @"iPod Touch 1G";
	} else if ([deviceString isEqualToString:@"iPod2,1"]) {
		deviceString = @"iPod Touch 2G";
	} else if ([deviceString isEqualToString:@"iPod3,1"]) {
		deviceString = @"iPod Touch 3G";
	} else if ([deviceString isEqualToString:@"iPhone1,1"]) {
		deviceString = @"iPhone 2G";
	} else if ([deviceString isEqualToString:@"iPhone1,2"]) {
		deviceString = @"iPhone 3G";
	} else if ([deviceString isEqualToString:@"iPhone2,1"]) {
		deviceString = @"iPhone 3G[S]";
	} else if ([deviceString isEqualToString:@"iPhone3,1"]) {
		deviceString = @"iPhone 4";
	} else if ([deviceString isEqualToString:@"iPad1,1"]) {
		deviceString = @"iPad 1G";
	} else {
		deviceString = @"Unknown";
	}
	
	if (deviceString == @"Unknown") {
		NSString *completeString = [NSString stringWithFormat:@"%@ Mode/Device Detected",deviceString];
		[deviceDetails setStringValue:completeString];
	} else {
		[loadingInd setHidden:YES];
		NSString *completeString = [NSString stringWithFormat:@"%@ Connected, %@, %@, %@", deviceString, modelNumber, firmwareVersion, serialNumber];
		[deviceDetails setStringValue:completeString];
	}
	
}

- (void)dePopulateData {
	[deviceDetails setStringValue:@"Device disconnected"];
}

- (void)loadingProgress {
	[loadingInd setHidden:NO];
	[loadingInd startAnimation: self];
}

- (NSString *)getDeviceValue:(NSString *)value {
	return AMDeviceCopyValue(device, 0, value);
}
- (IBAction)installprofile:(id)sender {
    system("cd /usr/local/libimobiledevice-macosx; chmod +x cpprofile");
    NSString *run2 = @"/usr/local/libimobiledevice-macosx/cpprofile";
    NSString *des2 = [NSString stringWithFormat:@"%@ %@", run2, profiledir.stringValue];
    char* runcommand2 = [des2 UTF8String];
    system( runcommand2 );
    NSRunAlertPanel(@"Done", @"Finish", @"Ok", NULL, NULL);
}
- (IBAction)openprofiledir:(id)sender {
    int it;
    NSOpenPanel* openDlg2 = [NSOpenPanel openPanel];
    [openDlg2 setCanChooseFiles:YES];
    [openDlg2 setCanChooseDirectories:NO];
    if ( [openDlg2 runModalForDirectory:nil file:nil] == NSOKButton )
    {
        NSArray* files2 = [openDlg2 filenames];
        for( it = 0; it < [files2 count]; it++ )
        {
            NSString* fileName2;
            fileName2  = [files2 objectAtIndex:it];
            [profiledir setStringValue:fileName2];
            NSString *decpfadt2 = profiledir.stringValue;
        }
    }
}
- (IBAction)installipa:(id)sender {
        NSString *run = @"cd /usr/local/libimobiledevice-macosx; export DYLD_LIBRARY_PATH=/usr/local/libimobiledevice-macosx/:$DYLD_LIBRARY_PATH; PATH=${PATH}:/usr/local/imobiledevice-macosx/; ./ideviceinstaller -i";
        NSString *des = [NSString stringWithFormat:@"%@ %@ %@", run, ipadir.stringValue];
        char* runcommand = [des UTF8String];
        system( runcommand );
        NSRunAlertPanel(@"Done", @"Finish", @"Ok", NULL, NULL);
}
- (IBAction)openipadir:(id)sender {
    int i;
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton )
    {
        NSArray* files = [openDlg filenames];
        for( i = 0; i < [files count]; i++ )
        {
            NSString* fileName;
            fileName  = [files objectAtIndex:i];
            [ipadir setStringValue:fileName];
            NSString *decpfadt = ipadir.stringValue;
        }
    }

}
- (IBAction)listallapps:(id)sender {
    system("cd /usr/local/libimobiledevice-macosx; export DYLD_LIBRARY_PATH=/usr/local/libimobiledevice-macosx/:$DYLD_LIBRARY_PATH; PATH=${PATH}:/usr/local/imobiledevice-macosx/; chmod +x listallapps.sh; chmod +x listallmyapps.sh; ./listallapps.sh");
}
- (IBAction)restorebackup:(id)sender {
}
- (IBAction)v1byme:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://3x7R00Tripper.com"]];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://twitter.com/3x7R00Tripper"]];
}
- (IBAction)donate:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://3x7R00Tripper.com/#donate"]];
}
- (IBAction)followmeandteam:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://twitter.com/syncdevteam"]];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://twitter.com/3x7R00Tripper"]];
}
@end
