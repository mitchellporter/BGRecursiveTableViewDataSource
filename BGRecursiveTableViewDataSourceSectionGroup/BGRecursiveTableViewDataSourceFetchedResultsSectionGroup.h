//
//  BGRecursiveTableViewDataSourceFetchedResultsSectionGroup.h
//  BGRecursiveTableViewDataSource
//
//  Created by Ben Guild on 4/2/16.
//  Copyright © 2016 Ben Guild. All rights reserved.
//

#import "BGRecursiveTableViewDataSourceSectionGroup.h"


@import CoreData;


@interface BGRecursiveTableViewDataSourceFetchedResultsSectionGroup : BGRecursiveTableViewDataSourceSectionGroup <NSFetchedResultsControllerDelegate>

@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (instancetype)initWithTableView:(UITableView *)tableView fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;

- (void)replaceFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController; // It's OK to pass this `nil` if you want to dynamically disable/enable this functionality.

- (BOOL)updateCellAtIndexPathWithoutReloading:(NSIndexPath *)indexPath indexPathForFetchedResultControllerIfDifferent:(NSIndexPath *)newIndexPath becauseDidChangeObject:(id)anObject; // This function returns "YES" if the cell at the `NSIndexPath` can be updated WITHOUT reloading it entirely. You can subclass this method to return "YES" if a successful row update has occurred. — If "NO" is returned, it WILL reload the cell. So, if the cell type must change for that row, you must return "NO" so that a standard reload can occur. // NOTE (2016-08-16): See note about newIndexPath here: http://stackoverflow.com/a/18136925/963901


@end
