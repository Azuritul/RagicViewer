//
// Created by azuritul on 2014/10/2.
// Copyright (c) 2014 Labcule. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "AZRagicDataListingViewController.h"
#import "AZRagicClient.h"
#import "AZRagicLeafViewController.h"

@interface AZRagicDataListingViewController () <RagicClientDelegate>
@end

@implementation AZRagicDataListingViewController

@synthesize tableView = _tableView;
@synthesize dataDict = _dataDict;
@synthesize url = _url;

- (AZRagicDataListingViewController *) initWithURL:(NSString *)url {
    self = [super init];
    if(self) {
        if(self.dataDict == nil) {
            self.dataDict = [NSMutableDictionary dictionary];
        }
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Ragic Viewer";
    self.tableView = [[[UITableView alloc] init] autorelease];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:viewDict]];
    [self loadData];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
}

- (void) loadData {
    AZRagicClient *client = [[[AZRagicClient alloc] init] autorelease];
    client.delegate = self;
    [client loadSheet:self.url];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellKey = @"dataListing";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellKey];
    if(!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellKey] autorelease];
    }

    NSDictionary * item = [self.dataDict objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    if(item.count > 0) {
        NSString * title = item[item.allKeys[0]];

        if(item) {
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
            cell.selectedBackgroundView = [[[UIView alloc] init] autorelease];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:9];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        }
        cell.textLabel.text=title;
        cell.detailTextLabel.text = [self detailTextFromResultDict:item];
    }
    return cell;
}

-(NSString *)detailTextFromResultDict: (NSDictionary *) dict {
    NSMutableString *text = [[@"" mutableCopy] autorelease];
    for( NSString * key in [dict allKeys]) {
        if([key hasPrefix:@"_"] && [key hasSuffix:@"_"]) {
            continue;
        }
        if([dict[key] isKindOfClass:[NSString class]]) {
            [text appendString:dict[key]];
            [text appendString:@"  "];
        }
    }
    return [NSString stringWithString:text];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * item = [self.dataDict objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    NSString *nodeId = item[@"_ragicId"];
    NSString *detailViewURL = [NSString stringWithFormat:@"%@/%@.xhtml", self.url, nodeId];
    AZRagicLeafViewController *webViewController = [[[AZRagicLeafViewController alloc] initWithUrl:detailViewURL] autorelease];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)loadFinishedWithResult:(NSDictionary *)result {
    if(result) {
        [self.dataDict addEntriesFromDictionary:result];
        [self reloadData];
    } else {
        [SVProgressHUD performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:NO];
    }
}

- (void)reloadData {
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [SVProgressHUD performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:NO];
}


- (void)dealloc {
    [_tableView release];
    [_dataDict release];
    [_url release];
    [super dealloc];
}
@end