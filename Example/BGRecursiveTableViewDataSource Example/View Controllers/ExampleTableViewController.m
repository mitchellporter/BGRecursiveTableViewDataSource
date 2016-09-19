//
//  ExampleTableViewController.m
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/19.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "ExampleTableViewController.h"
////

#import "BGRecursiveTableViewDataSource.h"



@interface ExampleTableViewController ()

@property (strong, nonatomic) BGRecursiveTableViewDataSource *internalStrongDataSource;


@end


@implementation ExampleTableViewController

- (void)setDataSource:(BGRecursiveTableViewDataSource *)dataSource
{
    _internalStrongDataSource=dataSource;
    [[self tableView] setDataSource:_internalStrongDataSource];
    
    [[self tableView] setEstimatedRowHeight:44];
    
    [[self tableView] reloadData];
    
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id optionalReturnValue=[_internalStrongDataSource resolveSectionGroupAndInnerIndexPathForTopLevelIndexPath:indexPath matchBlock:^id(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSIndexPath *innerIndexPath)
    {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"Row Tapped!" message:[NSString stringWithFormat:@"You tapped the row #%ld in section #%ld of the section group \"%@\".\n\nIts top-level index path is row #%ld in section #%ld.", [innerIndexPath row], [innerIndexPath section], sectionGroup, [indexPath row], [indexPath section]] preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        ////
        
        return @"Hello World!"; // NOTE: It's possible to pass a return-value through this matching block!
        
    } ];
    ////
    
    NSLog(@"Optional return value passed-through? \"%@\"", optionalReturnValue);
    ////
    
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
