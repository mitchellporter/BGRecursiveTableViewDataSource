//
//  BGRecursiveTableViewDataSourceFetchedResultsEmptySectionGroup.h
//  BGRecursiveTableViewDataSource
//
//  Created by Ben Guild on 2016/09/15.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "BGRecursiveTableViewDataSourceFetchedResultsSectionGroup.h"

@interface BGRecursiveTableViewDataSourceFetchedResultsEmptySectionGroup : BGRecursiveTableViewDataSourceFetchedResultsSectionGroup

- (BOOL)displayEmptySectionsForFetchedResultsControllerObjects; // If a subclass returns "YES" for this method, the section will subtract the amount of fetched results from each section to return empty sections instead. — This is useful in the event that you wish to use the fetched results to control creation of the sections and provide a basic linked data source, but you would rather control your own row counts and creation. This design will still enable subsections to work properly.


@end
