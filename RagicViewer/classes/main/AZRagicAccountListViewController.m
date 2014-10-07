//
// Created by azuritul on 2014/10/7.
// Copyright (c) 2014 Labcule. All rights reserved.
//

#import "AZRagicAccountListViewController.h"
#import "AZRagicUtils.h"


@interface AZRagicAccountListViewController ()
@property(nonatomic, retain) NSMutableArray *dataArray;
@property(nonatomic, retain) UITableView *tableView;
@end

@implementation AZRagicAccountListViewController

@synthesize dataArray = _dataArray;
@synthesize tableView = _tableView;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *dismissButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"glyphicons_207_remove_2.png"]
                                                                style:UIBarButtonItemStyleDone
                                                               target:self action:@selector(dismissPressed)] autorelease];
    self.navigationItem.rightBarButtonItem = dismissButton;
    self.title = @"Switch Account";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [AZRagicUtils colorFromHexString:@"#D70700"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    UITableView *temp = [[[UITableView alloc] init] autorelease];
    [temp setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.tableView = temp;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];

    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)dismissPressed {
    [self dismissViewControllerAnimated:YES completion:^{
        if([self.delegate respondsToSelector:@selector(didSwitchToAccount)]) {
            [self.delegate didSwitchToAccount];
        }
    }];
}

- (void) loadData {
    NSArray *array = [NSArray arrayWithContentsOfFile:[AZRagicUtils accountsFilePath]];
    if(array) {
        self.dataArray = [[array mutableCopy] autorelease];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellKey = @"accountCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellKey];
    if(!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellKey] autorelease];
    }

    NSDictionary *dict = self.dataArray[(NSUInteger) indexPath.row];
    if (dict) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        cell.textLabel.textColor = [AZRagicUtils colorFromHexString:@"#636363"];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[[UIView alloc] init] autorelease];
    }
    cell.textLabel.text = dict[@"account"];
    if([[AZRagicUtils getUserMainAccount] isEqualToString:dict[@"account"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell) {
        NSDictionary *dict = self.dataArray[(NSUInteger) indexPath.row];
        [AZRagicUtils switchAccount:dict[@"account"]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}


- (void)dealloc {
    [_dataArray release];
    [_tableView release];
    [super dealloc];
}


@end