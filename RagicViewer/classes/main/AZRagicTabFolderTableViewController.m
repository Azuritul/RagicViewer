//
//  AZRagicTabFolderTableViewController.m
//  RagicRestClient
//
//  Created by azuritul on 2014/9/9.
//  Copyright (c) 2014年 Azuritul. All rights reserved.
//

#import "AZRagicTabFolderTableViewController.h"
#import "AZRagicSheetItem.h"
#import "AZRagicSheetListViewController.h"

@interface AZRagicTabFolderTableViewController ()

@end

@implementation AZRagicTabFolderTableViewController

@synthesize tableView = _tableView;
@synthesize result = _result;

- (id)init {
    self = [super init];
    if(self) {
        self.result = [NSMutableArray array];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.title = @"Ragic Viewer";
    UITableView *tableView = [[[UITableView alloc] init] autorelease];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.opaque = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void) loadData {
    AZRagicClient *client = [[AZRagicClient alloc] init];
    client.delegate = self;
    NSString *apikey = [[NSUserDefaults standardUserDefaults] objectForKey:@"ragic_apikey"];
    [client loadTopLevel:apikey];
}


-(void)reloadTable {

    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)loadFinishedWithResult:(NSDictionary *)result {
    if(result) {
        NSMutableArray * resultArray = [NSMutableArray array];
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"ragic_account"];
        for(NSString *key in result.allKeys) {
            [resultArray addObject:[AZRagicSheetItem sheetItemFromDictionary:result[key] forKey:key andAccount:account]];
        }

        self.result = [[[self.result arrayByAddingObjectsFromArray:resultArray] mutableCopy] autorelease];
        [self reloadTable];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellKey = @"ekk";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellKey];
    if(!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellKey] autorelease];
    }

    AZRagicSheetItem * item = [self.result objectAtIndex:indexPath.row];
    if(item) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    cell.imageView.image = [[UIImage imageNamed:@"glyphicons_440_folder_closed.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.imageView.tintColor = [UIColor colorWithRed:98/255.0f green:126/255.0f blue:255/255.0f alpha:1.0];
    cell.textLabel.text=item.name;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AZRagicSheetItem * item = [self.result objectAtIndex:(NSUInteger) indexPath.row];
    AZRagicSheetListViewController *children = [[[AZRagicSheetListViewController alloc] initWithArray:item.children] autorelease];
    [self.navigationController pushViewController:children animated:YES];
}


- (void)dealloc {
    [_tableView release];
    [_result release];
    [super dealloc];
}

@end
