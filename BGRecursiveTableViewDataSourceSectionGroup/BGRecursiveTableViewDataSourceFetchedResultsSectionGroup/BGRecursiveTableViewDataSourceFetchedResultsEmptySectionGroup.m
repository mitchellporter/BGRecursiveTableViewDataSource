//
//  BGRecursiveTableViewDataSourceFetchedResultsEmptySectionGroup.m
//  BGRecursiveTableViewDataSource
//
//  Created by Ben Guild on 2016/09/15.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "BGRecursiveTableViewDataSourceFetchedResultsEmptySectionGroup.h"

@implementation BGRecursiveTableViewDataSourceFetchedResultsEmptySectionGroup

- (BOOL)displayEmptySectionsForFetchedResultsControllerObjects
{
    return NO;
    
}

#pragma mark <NSFetchedResultsControllerDelegate>

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if ([self displayEmptySectionsForFetchedResultsControllerObjects])
    {
        return; // Do nothing. We don't ever actually insert or delete any of these cells.
        
    }
    ////
    
    [super controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    
}

#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([super tableView:tableView numberOfRowsInSection:section]-([self displayEmptySectionsForFetchedResultsControllerObjects] ? [[[[self fetchedResultsController] sections] objectAtIndex:section] numberOfObjects] : 0));
    
}

@end
