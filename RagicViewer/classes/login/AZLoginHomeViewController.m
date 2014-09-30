//
//  AZLoginHomeViewController.m
//  RagicRestClient
//
//  Created by azuritul on 2014/9/9.
//  Copyright (c) 2014年 Azuritul. All rights reserved.
//

#import "AZLoginHomeViewController.h"
#import "AZBasicAuthLoginViewController.h"

@interface AZLoginHomeViewController ()

@property (nonatomic, retain) UITableView * tableView;

@end


@implementation AZLoginHomeViewController

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
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleimage.JPG"]] autorelease];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurView = [[[UIVisualEffectView alloc] initWithEffect:blurEffect] autorelease];
    [blurView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginOption) forControlEvents:UIControlEventTouchUpInside];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setBackgroundColor:[UIColor blueColor]];
    button.layer.cornerRadius = 7;
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [button setAlpha:0.5];

    UILabel * titleLabel = [[[UILabel alloc] init] autorelease];
    [titleLabel setText:@"Ragic Viewer"];
    [titleLabel setFont:[UIFont fontWithName:@"KohinoorDevanagari-Medium" size:28]];
    [titleLabel setTextColor:[UIColor redColor]];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view addSubview:imageView];
    [self.view addSubview:blurView];
    [self.view addSubview:button];
    [self.view addSubview:titleLabel];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)] ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)] ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(blurView)] ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(blurView)] ];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:220]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-60-[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel, button)]];
}

- (void)loginOption {

    AZBasicAuthLoginViewController *tabs = [[[AZBasicAuthLoginViewController alloc] init] autorelease];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:tabs] autorelease];
//    self.navigationController.navigationItem.hidesBackButton = NO;
//    [self.navigationController pushViewController:tabs animated:YES];
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:tabs animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
