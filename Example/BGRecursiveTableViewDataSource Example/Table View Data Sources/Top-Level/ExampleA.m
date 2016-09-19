//
//  ExampleA.m
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/19.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "ExampleA.h"
////

#import "RedExampleSectionGroup.h"
#import "GreenExampleSectionGroup.h"
#import "BlueExampleSectionGroup.h"


#define tableView_sectionGroup_red 0
#define tableView_sectionGroup_green 1
#define tableView_sectionGroup_blue 2
#define tableView_sectionGroupCount 3


@implementation ExampleA

- (instancetype)initWithTableView:(UITableView *)tableView
{
    if (self=[super initWithTableView:tableView])
    {
        for (NSUInteger sectionGroupIndex=0; sectionGroupIndex<tableView_sectionGroupCount; sectionGroupIndex++)
        {
            BGRecursiveTableViewDataSourceSectionGroup *sectionGroupDataSource;
            
            if (sectionGroupIndex==tableView_sectionGroup_red)
            {
                sectionGroupDataSource=[[RedExampleSectionGroup alloc] initWithTableView:[self tableView]];
                
            }
            else if (sectionGroupIndex==tableView_sectionGroup_green)
            {
                sectionGroupDataSource=[[GreenExampleSectionGroup alloc] initWithTableView:[self tableView]];
                
            }
            else if (sectionGroupIndex==tableView_sectionGroup_blue)
            {
                sectionGroupDataSource=[[BlueExampleSectionGroup alloc] initWithTableView:[self tableView]];
                
            }
            
            [self appendSectionGroupToNewDataSource:sectionGroupDataSource];
            ////
            
            /*
            NSError *error;
            
            if ([sectionGroupDataSource fetchedResultsController] && ![[sectionGroupDataSource fetchedResultsController] performFetch:&error])
            {
                NSLog(@"Unresolved Core Data error while performing fetch: %@, %@", error, [error userInfo]);
                
            }
            */
            
        }
        
    }
    
    return self;
    
}

@end
