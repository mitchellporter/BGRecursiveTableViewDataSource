//
//  BGRecursiveTableViewDataSource.h
//  BGRecursiveTableViewDataSource
//
//  Created by Ben Guild on 2/11/16.
//  Copyright © 2016 Ben Guild. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BGRecursiveTableViewDataSourceSectionGroup;


@interface BGRecursiveTableViewDataSource : NSObject <UITableViewDataSource>

@property (readonly, weak, nonatomic) UITableView *tableView;

- (instancetype)initWithTableView:(UITableView *)tableView;

- (void)appendSectionGroupToNewDataSource:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup; // This method is for initial configuration of a new data source only. (ie. before the `UITableView` has loaded its data)

- (void)beginUpdatesForSectionGroups:(NSSet <BGRecursiveTableViewDataSourceSectionGroup *>*)sectionGroups; // Use these internally instead of calling `UITableView` beginUpdates/endUpdates() methods.
- (void)endUpdatesForSectionGroups:(NSSet <BGRecursiveTableViewDataSourceSectionGroup *>*)sectionGroups;

- (NSOrderedSet<BGRecursiveTableViewDataSourceSectionGroup *> *)sectionGroups;


#pragma mark - Add/remove "section groups" after initialization

- (void)insertSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup atIndexForSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroupForIndex insertAfter:(BOOL)insertAfter;

- (void)removeSectionGroupAndItsDisplayedSections:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup;


#pragma mark - "Section group" operation support

- (NSIndexPath *)translateInternalIndexPathToTopLevel:(NSIndexPath *)indexPath forTopLevelSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup;

- (id)resolveSectionGroupAndInnerIndexPathForTopLevelIndexPath:(NSIndexPath *)indexPath matchBlock:(id (^)(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSIndexPath *innerIndexPath))matchBlock;


@end
