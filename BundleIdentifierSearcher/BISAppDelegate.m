//
//  BISAppDelegate.m
//  BundleIdentifierSearcher
//
//  Created by hyde on 2013/02/22.
//  Copyright (c) 2013年 r-plus. All rights reserved.
//

#import "BISAppDelegate.h"
#import "BISApplication.h"

#ifdef DEBUG
# define Log(...) NSLog(@"%@", [NSString stringWithFormat:__VA_ARGS__])
#else
# define Log(...)
#endif

@implementation BISAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // NOTE: if you prefer smallest, comment out below line.
    self.tableView.delegate = self;
    
    [self.tableView setTarget:self];
    [self.tableView setDoubleAction:@selector(doubleAction:)];
}

- (void)doubleAction:(id)arg
{
    if ([self.tableView clickedRow] >= 0) {
        Log(@"double clicked");
        NSString *bundleIdentifier = [[_arrayController selectedObjects][0] bundleIdentifier];
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard declareTypes:@[NSStringPboardType] owner:self];
        [pasteboard setString:bundleIdentifier forType:NSPasteboardTypeString];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return self.results.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 60.0f;
}

- (IBAction)search:(id)sender
{
    NSString *country = [self.country titleOfSelectedItem];
    Log(@"country = %@", country);
    NSString *store = nil;
    switch ([self.segment selectedSegment]) {
        case 0:
            store = @"software";
            break;
        case 1:
            store = @"iPadSoftware";
            break;
        case 2:
            store = @"macSoftware";
            break;
    }
    Log(@"store = %@", store);
    Log(@"text = %@", [sender stringValue]);
    NSString *encodedString = [[sender stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    Log(@"encoded text = %@", encodedString);
    
    NSString *URL = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&country=%@&media=software&entity=%@&limit=10", encodedString, country, store];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    self.results = dict[@"results"];
    for (id app in self.results) {
        BISApplication *application = [[BISApplication alloc] init];
        NSURL *iconURL = [NSURL URLWithString:app[@"artworkUrl60"]];
        application.icon = [[NSImage alloc] initWithContentsOfURL:iconURL];
        application.bundleIdentifier = app[@"bundleId"];
        [array addObject:application];
    }
    [_arrayController setContent:array];
}
@end
