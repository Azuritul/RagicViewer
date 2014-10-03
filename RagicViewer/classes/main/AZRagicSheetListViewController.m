//
// Created by azuritul on 2014/9/29.
// Copyright (c) 2014 Azuritul. All rights reserved.
//

#import "AZRagicSheetListViewController.h"
#import "AZRagicSheetItem.h"
#import "AZRagicDataListingViewController.h"

@implementation AZRagicSheetListViewController

@synthesize tableView = _tableView;
@synthesize dataArray = _dataArray;
@synthesize dataDict = _dataDict;

- (AZRagicSheetListViewController *)initWithArray:(NSArray *)array {
        self = [super init];
        if(self) {
            if(self.dataArray == nil) {
                self.dataArray = [NSArray array];
            }
            self.dataArray = [self.dataArray arrayByAddingObjectsFromArray:array];
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellKey = @"gg";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellKey];
    if(!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellKey] autorelease];
    }
    AZRagicSheetItem * item = [self.dataArray objectAtIndex:indexPath.row];
    if(item) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    cell.imageView.image = [[UIImage imageNamed:@"glyphicons_440_folder_closed.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.imageView.tintColor = [UIColor colorWithRed:98/255.0f green:126/255.0f blue:255/255.0f alpha:1.0];
    cell.textLabel.text=item.name;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AZRagicSheetItem * item = [self.dataArray objectAtIndex:(NSUInteger) indexPath.row];
    AZRagicDataListingViewController *listingViewController = [[[AZRagicDataListingViewController alloc] initWithURL:item.itemUrl] autorelease];
    [self.navigationController pushViewController:listingViewController animated:YES];
}


- (void)dealloc {
    [_tableView release];
    [_dataArray release];
    [_dataDict release];
    [super dealloc];
}
@end