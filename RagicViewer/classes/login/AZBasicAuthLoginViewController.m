//
// Created by azuritul on 2014/9/26.
// Copyright (c) 2014 Azuritul. All rights reserved.
//

#import "AZBasicAuthLoginViewController.h"
#import "AZRagicClient.h"

@interface AZBasicAuthLoginViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RagicClientDelegate>

@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) UITextField * accountField;
@property (nonatomic, retain) UITextField * passwordField;
@end

@implementation AZBasicAuthLoginViewController

@synthesize tableView = _tableView;
@synthesize accountField = _accountField;
@synthesize passwordField = _passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *customBarItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self action:@selector(back)] autorelease];

    UIBarButtonItem *loginBarItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self action:@selector(loginButtonPressed)] autorelease];

    self.navigationItem.leftBarButtonItem = customBarItem;
    self.navigationItem.rightBarButtonItem = loginBarItem;
    self.navigationItem.title = @"RagicViewer";
    self.view.backgroundColor = [UIColor whiteColor];

    UITableView *tempTableView = [[[UITableView alloc] init] autorelease];
    [tempTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    tempTableView.delegate = self;
    tempTableView.dataSource = self;
    tempTableView.backgroundColor = [UIColor whiteColor];
    self.tableView = tempTableView;

    [self.view addSubview:self.tableView];

    NSDictionary *bindings = NSDictionaryOfVariableBindings(_tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_tableView]-20-|" options:0 metrics:nil  views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_tableView(200)]" options:0 metrics:nil  views:bindings]];

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

    NSString * username = self.accountField.text;
    NSString * password = self.passwordField.text;
    [client loginWithUsername:username password:password];
}

- (Boolean)loginFinishedWithStatusCode:(NSString *)code andResult:(NSDictionary *)result {
    return false;
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellKey = @"inputCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"inputCell"];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellKey] autorelease];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITextField *field = [[[UITextField alloc] init] autorelease];
    [field setTranslatesAutoresizingMaskIntoConstraints:NO];
    switch (indexPath.row) {
        case 0:
            field.placeholder = @"email address";
            self.accountField = field;
            [cell.contentView addSubview:self.accountField];
            break;
        case 1:
            field.placeholder = @"your password";
            field.secureTextEntry = YES;
            self.passwordField = field;
            [cell.contentView addSubview:self.passwordField];
            break;
        default:break;
    }

    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[field]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(field)]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[field(40)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(field)]];

    return cell;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // To "clear" the footer view
    return [[UIView new] autorelease];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)dealloc {
    [_tableView release];
    [_accountField release];
    [_passwordField release];
    [super dealloc];
}
@end
