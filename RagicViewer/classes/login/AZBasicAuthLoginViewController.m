//
// Created by azuritul on 2014/9/26.
// Copyright (c) 2014 Azuritul. All rights reserved.
//

#import "AZBasicAuthLoginViewController.h"
#import "AZRagicClient.h"
#import "AZRagicTabFolderTableViewController.h"
#import "SVProgressHUD.h"

@interface AZBasicAuthLoginViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RagicClientDelegate, UITextViewDelegate, UIWebViewDelegate>

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

    UITableView *tempTableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];

    [tempTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    tempTableView.delegate = self;
    tempTableView.dataSource = self;
    tempTableView.backgroundColor = [UIColor whiteColor];
    tempTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView = tempTableView;
    [self.view addSubview:self.tableView];

    NSDictionary *bindings = NSDictionaryOfVariableBindings(_tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_tableView]|" options:0 metrics:nil  views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_tableView]|" options:0 metrics:nil  views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tableView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings( _tableView)]];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginButtonPressed {
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
    if([self isFormValid]) {
        [self login];
        [self.passwordField resignFirstResponder];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Username or password is wrong"];
    }
}

- (Boolean)isFormValid {
    if (self.accountField.text.length <= 1) return NO;
    if (self.passwordField.text.length <= 0) return NO;
    if (![self.accountField.text containsString:@"@"]) return NO;
    return YES;
}

- (void)login {
    AZRagicClient *client = [[[AZRagicClient alloc] init] autorelease];
    client.delegate = self;

    NSString * username = self.accountField.text;
    NSString * password = self.passwordField.text;
    [client loginWithUsername:username password:password];

}

- (void)loginFinishedWithStatusCode:(NSString *)code andResult:(NSDictionary *)result {
    if ([code isEqualToString:@"success"]) {
        [self performSelectorOnMainThread:@selector(dispatchToMainView) withObject:nil waitUntilDone:NO];
    } else {
        [SVProgressHUD performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:NO];
        [SVProgressHUD performSelectorOnMainThread:@selector(showErrorWithStatus:) withObject:@"Login failed" waitUntilDone:NO];
    }

}

- (void)dispatchToMainView {
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    AZRagicTabFolderTableViewController *controller = [[[AZRagicTabFolderTableViewController alloc] init] autorelease];
    UINavigationController *newNav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:newNav animated:YES completion:nil];
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

    switch (indexPath.row) {
        case 0: {
            UITextField *field = [[[UITextField alloc] init] autorelease];
            [field setTranslatesAutoresizingMaskIntoConstraints:NO];
            field.placeholder = @"email address";
            field.autocapitalizationType = UITextAutocapitalizationTypeNone;
            field.keyboardType = UIKeyboardTypeEmailAddress;
            self.accountField = field;
            [cell.contentView addSubview:self.accountField];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[field]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(field)]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[field(>=40)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(field)]];
            }
            break;
        case 1:{
            UITextField *field = [[[UITextField alloc] init] autorelease];
            [field setTranslatesAutoresizingMaskIntoConstraints:NO];
            field.placeholder = @"password";
            field.secureTextEntry = YES;
            self.passwordField = field;
            [cell.contentView addSubview:self.passwordField];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[field]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(field)]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[field(>=40)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(field)]];
            }
            break;
        default:break;
    }

    return cell;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
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
