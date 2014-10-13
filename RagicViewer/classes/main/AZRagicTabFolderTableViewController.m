//
//  AZRagicTabFolderTableViewController.m
//  RagicViewer
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
    self.view.backgroundColor = [AZRagicUtils colorFromHexString:@"#F0F0F2"];
    UIBarButtonItem *moreButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"glyphicons_187_more"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self action:@selector(moreButtonPressed)] autorelease];

    self.navigationItem.rightBarButtonItem = moreButton;
    self.title = @"Ragic Viewer";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [AZRagicUtils colorFromHexString:@"#D70700"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    UITableView *tableView = [[[UITableView alloc] init] autorelease];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.opaque = NO;
    tableView.backgroundColor = [AZRagicUtils colorFromHexString:@"#F0F0F2"];
    //tableView.backgroundView = nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];

    //Add dropdown menu
    UIView *dropdownView = [[[UIView alloc] init] autorelease];
    [dropdownView setTranslatesAutoresizingMaskIntoConstraints:NO];
    dropdownView.backgroundColor = [UIColor whiteColor];
    dropdownView.alpha = 0.95;

    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    logoutButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [logoutButton setTitleColor:[AZRagicUtils colorFromHexString:@"#636363"] forState:UIControlStateNormal];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    logoutButton.backgroundColor = [UIColor clearColor];
    [logoutButton addTarget:self action:@selector(confirmLogout) forControlEvents:UIControlEventTouchUpInside];

    UIButton *switchAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchAccountButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    switchAccountButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    switchAccountButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [switchAccountButton setTitleColor:[AZRagicUtils colorFromHexString:@"#636363"] forState:UIControlStateNormal];
    [switchAccountButton setTitle:@"Switch Account" forState:UIControlStateNormal];
    switchAccountButton.backgroundColor = [UIColor clearColor];
    [switchAccountButton addTarget:self action:@selector(popSwitchAccountController) forControlEvents:UIControlEventTouchUpInside];

    UIView *line = [[[UIView alloc] init] autorelease];
    [line setTranslatesAutoresizingMaskIntoConstraints:NO];
    [line setBackgroundColor:[AZRagicUtils colorFromHexString:@"#E0DDDD"]];

    [dropdownView addSubview:switchAccountButton];
    [dropdownView addSubview:line];
    [dropdownView addSubview:logoutButton];

    self.dropdownMenu = dropdownView;
    [self.view addSubview:dropdownView];

    NSDictionary *viewBinding = NSDictionaryOfVariableBindings(logoutButton, line, switchAccountButton, dropdownView);
    NSArray *menuHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dropdownView(>=130)]" options:0 metrics:nil views:viewBinding];
    NSLayoutConstraint *xAxisToParentView = [NSLayoutConstraint constraintWithItem:dropdownView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *viewWidthConstraint = [NSLayoutConstraint constraintWithItem:dropdownView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    self.xAxisLayoutConstraint = xAxisToParentView;
    [dropdownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[switchAccountButton]|" options:0 metrics:nil views:viewBinding]];
    [dropdownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[line]-10-|" options:0 metrics:nil views:viewBinding]];
    [dropdownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[logoutButton]|" options:0 metrics:nil views:viewBinding]];
    [dropdownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[switchAccountButton(==60)][line(==1)][logoutButton(>=60)]|" options:0 metrics:nil views:viewBinding]];
    [self.view addConstraint:viewWidthConstraint];
    [self.view addConstraints:menuHeightConstraint];
    [self.view addConstraint:self.xAxisLayoutConstraint];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self loadData];
}

- (void)popSwitchAccountController {
    AZRagicAccountListViewController *accountsViewController = [[[AZRagicAccountListViewController alloc] init] autorelease];
    accountsViewController.delegate = self;
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:accountsViewController] autorelease];

    navigationController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *presentation = accountsViewController.popoverPresentationController;
    presentation.permittedArrowDirections = UIPopoverArrowDirectionAny;
    presentation.sourceView = self.dropdownMenu;
    [self presentViewController:navigationController animated:YES completion:^{}];
    [self showMenuAnimated];
}

- (void)moreButtonPressed {
    [self showMenuAnimated];
}

- (void)showMenuAnimated {
    [self.view setNeedsUpdateConstraints];
    CGFloat axis = self.xAxisLayoutConstraint.constant > 0 ? -100 : 184;
    [UIView animateWithDuration:0.3  animations:^{
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
        if (self.result.count > 0) {
            [self.result removeAllObjects];
        }
        self.result = [[[self.result arrayByAddingObjectsFromArray:resultArray] mutableCopy] autorelease];
        [self reloadTable];
    }
}

- (void)didSwitchToAccount {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self loadData];
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

    AZRagicSheetItem * item = [self.result objectAtIndex:(NSUInteger) indexPath.row];
    if(item) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.textLabel.textColor = [AZRagicUtils colorFromHexString:@"#636363"];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[[UIView alloc] init] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text=item.name;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.result.count == 0) {
        UILabel *messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)] autorelease];
        messageLabel.text = @"There is currently no data.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[[UIView alloc] init] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.bounds.size.width, 44)] autorelease];
    label.text = [AZRagicUtils getUserMainAccount];
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    header.backgroundColor = [AZRagicUtils colorFromHexString:@"#A12B28"];
    header.alpha = 0.9;
    [header addSubview:label];
    return header;
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
