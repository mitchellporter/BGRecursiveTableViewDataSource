//
//  AppDelegate.m
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/19.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "AppDelegate.h"

#import "BGRecursiveTableViewDataSource.h"
////

#import "ExampleTableViewController.h"
#import "GroupedStyleExampleTableViewController.h"

#import "ExampleA.h"
#import "ExampleB.h"
#import "ExampleC.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSMutableArray *viewControllers=[NSMutableArray new];
    
    void (^createExampleTableViewController)(Class, NSString *) = ^(Class dataSourceOfClass, NSString *label)
    {
        BOOL theFlip=!([viewControllers count] % 2);
        ////
        
        ExampleTableViewController *exampleTableViewController=[(theFlip ? [ExampleTableViewController class] : [GroupedStyleExampleTableViewController class]) new];
        
        [exampleTableViewController setTitle:[NSString stringWithFormat:@"Example %@", label]];
        [exampleTableViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:[exampleTableViewController title] image:[UIImage imageNamed:(theFlip ? @"first" : @"second")] tag:0]];
        
        [exampleTableViewController setDataSource:[[dataSourceOfClass alloc] initWithTableView:[exampleTableViewController tableView]]];
        
        [viewControllers addObject:[[UINavigationController alloc] initWithRootViewController:exampleTableViewController]];
        
    };
    
    createExampleTableViewController([ExampleA class], @"A");
    createExampleTableViewController([ExampleB class], @"B");
    createExampleTableViewController([ExampleC class], @"C");
    createExampleTableViewController([ExampleC class], @"D");
    ////
    
    UITabBarController *tabBarController=[UITabBarController new];
    [tabBarController setViewControllers:viewControllers];
    
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self window] setRootViewController:tabBarController];
    [[self window] makeKeyAndVisible];
    
    return YES;
    
}

@end
