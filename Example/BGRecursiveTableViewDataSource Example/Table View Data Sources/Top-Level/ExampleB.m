//
//  ExampleB.m
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/19.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "ExampleB.h"
////

#import "RedExampleSectionGroup.h"
#import "YellowExampleSectionGroup.h"
#import "BlueExampleSectionGroup.h"


#define tableView_sectionGroup_red 0
#define tableView_sectionGroup_blue 1
#define tableView_sectionGroupCount 2


@implementation ExampleB

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
                ////
                
                [sectionGroupDataSource setInnerSectionGroup:[[YellowExampleSectionGroup alloc] initWithTableView:[self tableView]] forRowAtNonSubsectionIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] isInitiallyActive:YES];
                
            }
            else if (sectionGroupIndex==tableView_sectionGroup_blue)
            {
                sectionGroupDataSource=[[BlueExampleSectionGroup alloc] initWithTableView:[self tableView]];
                ////
                
                [sectionGroupDataSource setInnerSectionGroup:[[YellowExampleSectionGroup alloc] initWithTableView:[self tableView]] forRowAtNonSubsectionIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] isInitiallyActive:YES];
                
            }
            
            [self appendSectionGroupToNewDataSource:sectionGroupDataSource];
            
        }
        
    }
    
    return self;
    
}

@end
