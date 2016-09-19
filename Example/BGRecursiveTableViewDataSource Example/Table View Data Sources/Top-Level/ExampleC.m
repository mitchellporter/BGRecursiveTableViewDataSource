//
//  ExampleC.m
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/19.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "ExampleC.h"
////

#import "SwitchToggledExampleSectionGroup.h"

#import "RedExampleSectionGroup.h"
#import "YellowExampleSectionGroup.h"
#import "BlueExampleSectionGroup.h"


#define tableView_sectionGroup_red 0
#define tableView_sectionGroup_switchTopLevel 1
#define tableView_sectionGroup_blue 2
#define tableView_sectionGroupCount 3


@implementation ExampleC

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
            else if (sectionGroupIndex==tableView_sectionGroup_switchTopLevel)
            {
                sectionGroupDataSource=[[SwitchToggledExampleSectionGroup alloc] initWithTableView:[self tableView] innerSectionGroup:[[YellowExampleSectionGroup alloc] initWithTableView:[self tableView]] isInitiallyActive:NO];
                
            }
            else if (sectionGroupIndex==tableView_sectionGroup_blue)
            {
                sectionGroupDataSource=[[BlueExampleSectionGroup alloc] initWithTableView:[self tableView]];
                ////
                
                [sectionGroupDataSource setInnerSectionGroup:[[SwitchToggledExampleSectionGroup alloc] initWithTableView:[self tableView] innerSectionGroup:[[YellowExampleSectionGroup alloc] initWithTableView:[self tableView]] isInitiallyActive:YES] forRowAtNonSubsectionIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] isInitiallyActive:YES];
                
            }
            
            [self appendSectionGroupToNewDataSource:sectionGroupDataSource];
            
        }
        
    }
    
    return self;
    
}

@end
