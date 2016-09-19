//
//  ExampleTableViewController.h
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/19.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BGRecursiveTableViewDataSource;


@interface ExampleTableViewController : UITableViewController

- (void)setDataSource:(BGRecursiveTableViewDataSource *)dataSource;


@end
