//
// Created by azuritul on 2014/9/26.
// Copyright (c) 2014 Azuritul. All rights reserved.
//

#import "AZBasicAuthLoginViewController.h"
#import "AZRagicClient.h"

@interface AZBasicAuthLoginViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RagicClientDelegate>

@property (nonatomic, retain) UITableView * tableView;

@end

@implementation AZBasicAuthLoginViewController


@synthesize tableView = _tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.navigationItem setHidesBackButton:NO];
//    self.navigationItem.backBarButtonItem.title = @"back";
    UIBarButtonItem *customBarItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)] autorelease];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.view.backgroundColor = [UIColor whiteColor];
//    UITableView *tempTableView = [[[UITableView alloc] init] autorelease];
//    [tempTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    tempTableView.delegate = self;
//    tempTableView.dataSource = self;
//
//    self.tableView = tempTableView;

    UITextField *apikeyField = [[[UITextField alloc] init] autorelease];
    [apikeyField setTranslatesAutoresizingMaskIntoConstraints:NO];
    apikeyField.delegate = self;
    apikeyField.placeholder = @"Please enter your api key";
    [self.view addSubview:apikeyField];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setBackgroundColor:[UIColor blueColor]];
    button.layer.cornerRadius = 7;
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];

    [self.view addSubview:button];
//    [self.view addSubview:self.tableView];

    NSDictionary *bindings = NSDictionaryOfVariableBindings(button, apikeyField);

    //LoginButton stretch
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[button]-20-|" options:0 metrics:nil  views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[apikeyField]-20-|" options:0 metrics:nil  views:bindings]];
    //Vertical layout of tableview and login button
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[apikeyField(44)]-12-[button(44)]" options:0 metrics:nil views:bindings]];
    //Centering login button to super view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //LoginButton and apikey field same width
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:apikeyField attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginButtonPressed {
    [NSThread detachNewThreadSelector:@selector(login) toTarget:self withObject:nil];
}

- (void)login {
    AZRagicClient *client = [[[AZRagicClient alloc] init] autorelease];
    client.delegate = self;
//    [client loginWithAPIKey:nil];
    [client loginWithUsername:@"labcule@gmail.com" password:@"abc1234"];

}

- (Boolean)loginFinishedWithStatusCode:(NSString *)code andResult:(NSDictionary *)result {
    NSLog(@"logged in");
    return false;
}


#pragma mark UITableViewDataSource
//Only 1 row for entering apikey
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellKey = @"inputCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"inputCell"];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellKey] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITextField *field = [[[UITextField alloc] init] autorelease];
    [field setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.contentView addSubview:field];

    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[field]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(field)]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[field]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(field)]];
    field.placeholder = @"Please input API key";

    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
