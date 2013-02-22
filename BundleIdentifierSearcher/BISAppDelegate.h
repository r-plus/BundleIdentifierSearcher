//
//  BISAppDelegate.h
//  BundleIdentifierSearcher
//
//  Created by hyde on 2013/02/22.
//  Copyright (c) 2013年 r-plus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BISAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSSegmentedControl *segment;
@property (weak) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSPopUpButton *country;
@property (strong) NSArray *results;

- (IBAction)search:(id)sender;

@end
