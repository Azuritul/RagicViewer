//
//  AZLoginHomeViewController.m
//  RagicRestClient
//
//  Created by azuritul on 2014/9/9.
//  Copyright (c) 2014年 Azuritul. All rights reserved.
//

#import "AZLoginHomeViewController.h"
#import "AZBasicAuthLoginViewController.h"
#import "AZRagicUtils.h"

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
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleImage.JPG"]] autorelease];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurView = [[[UIVisualEffectView alloc] initWithEffect:blurEffect] autorelease];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [blurView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [super viewDidLoad];

    //Configure title label
    UILabel * titleLabel = [[[UILabel alloc] init] autorelease];
    [titleLabel setText:@"Ragic Viewer"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:34]];
    [titleLabel setTextColor:[AZRagicUtils colorFromHexString:@"#D70700"]];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    //Configure subtitle
    UILabel * subtitle = [[[UILabel alloc] init] autorelease];
    [subtitle setText:@"An Unofficial Viewer for Ragic Cloud DB"];
    [subtitle setFont:[UIFont boldSystemFontOfSize:13]];
    [subtitle setTextColor:[AZRagicUtils colorFromHexString:@"#B0B0B0"]];
    [subtitle setTranslatesAutoresizingMaskIntoConstraints:NO];

    //Configure login button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginOption) forControlEvents:UIControlEventTouchUpInside];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setBackgroundColor:[AZRagicUtils colorFromHexString:@"#D70700"]];
    button.layer.cornerRadius = 5;
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [button setAlpha:0.9f];

    [self.view addSubview:imageView];
    [self.view addSubview:blurView];
    [self.view addSubview:button];
    [self.view addSubview:titleLabel];
    [self.view addSubview:subtitle];
    self.view.backgroundColor = [UIColor whiteColor];

    //Adding constraints
    NSDictionary *bindings = NSDictionaryOfVariableBindings(imageView, blurView, titleLabel, subtitle, button);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:bindings] ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:bindings] ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|" options:0 metrics:nil views:bindings] ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurView]|" options:0 metrics:nil views:bindings] ];
    //View constraints for title label
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-80]];
    //View constraints for subtitle
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:subtitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-6-[subtitle]" options:0 metrics:nil views:bindings]];
    //View constraints for login button
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[button]-40-|" options:0 metrics:nil views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==52)]-20-|" options:0 metrics:nil views:bindings]];
}

- (void)loginOption {
    AZBasicAuthLoginViewController *tabs = [[[AZBasicAuthLoginViewController alloc] init] autorelease];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:tabs] autorelease];
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nav animated:YES completion:nil];
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

@end
