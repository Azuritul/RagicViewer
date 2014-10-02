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
#import "SVProgressHUD.h"
#import "AZRagicUtils.h"
#import "AZLoginHomeViewController.h"

@interface AZRagicTabFolderTableViewController ()

- (void)forwardToLoginView;
@end

@implementation AZRagicTabFolderTableViewController

@synthesize tableView = _tableView;
@synthesize result = _result;
@synthesize dropdownMenu = _dropdownMenu;
@synthesize xAxisLayoutConstraint = _xAxisLayoutConstraint;

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
    UIBarButtonItem *moreButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"glyphicons_187_more"]
                                                                   style:UIBarButtonSystemItemDone
                                                                  target:self action:@selector(moreButtonPressed)] autorelease];

    self.navigationItem.rightBarButtonItem = moreButton;
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

    //Add dropdown menu
    UIView *dropdownView = [[[UIView alloc] init] autorelease];
    dropdownView.backgroundColor = [UIColor blackColor];
    dropdownView.alpha = 0.9;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dropdownView setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitle:@"Logout" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(confirmLogout) forControlEvents:UIControlEventTouchUpInside];
    [dropdownView addSubview:button];
    self.dropdownMenu = dropdownView;
    [self.view addSubview:dropdownView];

    NSArray *menuHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dropdownView(>=44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(dropdownView)];
    NSLayoutConstraint *xAxisToParentView = [NSLayoutConstraint constraintWithItem:dropdownView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:0 constant:0];
    NSLayoutConstraint *viewWidthConstraint = [NSLayoutConstraint constraintWithItem:dropdownView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    self.xAxisLayoutConstraint = xAxisToParentView;
    [dropdownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    [dropdownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];    [dropdownView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:dropdownView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:viewWidthConstraint];
    [self.view addConstraints:menuHeightConstraint];
    [self.view addConstraint:self.xAxisLayoutConstraint];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];

}

- (void)moreButtonPressed {
    [self showMenuAnimated];
}

- (void)showMenuAnimated {
    [self.view setNeedsUpdateConstraints];
    CGFloat axis = self.xAxisLayoutConstraint.constant > 0 ? -100 : 100;
    [UIView animateWithDuration:0.6  animations:^{
         self.xAxisLayoutConstraint.constant = axis;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}


- (void)confirmLogout {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Logout"
                                                                             message:@"Are you sure?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         [AZRagicUtils removeUserInfo];
                                                         [self forwardToLoginView];
                                                     }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)forwardToLoginView {
    AZLoginHomeViewController * controller = [[[AZLoginHomeViewController alloc] init] autorelease];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}


- (void) loadData {
    AZRagicClient *client = [[[AZRagicClient alloc] init] autorelease];
    client.delegate = self;
    NSString *apikey = [[NSUserDefaults standardUserDefaults] objectForKey:@"ragic_apikey"];
    [client loadTopLevel:apikey];
}


-(void)reloadTable {
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
}

- (void)reload {
    if([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    [self.tableView reloadData];
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
    [_dropdownMenu release];
    [_xAxisLayoutConstraint release];
    [super dealloc];
}

@end
