//
//  BGRecursiveTableViewDataSourceSectionGroup.h
//  BGRecursiveTableViewDataSource
//
//  Created by Ben Guild on 2/11/16.
//  Copyright © 2016 Ben Guild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGRecursiveTableViewDataSourceSectionGroup : NSObject <UITableViewDataSource>

@property (readonly, weak, nonatomic) BGRecursiveTableViewDataSourceSectionGroup *parentSectionGroup;
@property (readonly, weak, nonatomic) UITableView *tableView;

- (instancetype)initWithTableView:(UITableView *)tableView;

- (NSIndexPath *)translateInternalIndexPathToTopLevel:(NSIndexPath *)indexPath; // NOTE: You shouldn't need this method unless you need to manually get the actual "indexPath" for the actual cell... such as to make changes to it directly if it already exists. (updates without reloading, etc.) — The convenience methods below are better suited for inserting/deleting/reloading cells and sections.
- (NSIndexPath *)translateSubsectionIndexPathToTopLevel:(NSIndexPath *)indexPath forSubsection:(BGRecursiveTableViewDataSourceSectionGroup *)subsectionGroup; // NOTE: This method should probably only be called by inner `BGRecursiveTableViewDataSourceSectionGroup` subsections.

- (NSSet *)sectionGroups;


#pragma mark - Row + section insertion/deletion (Use these convenience methods instead of the UITableView's).

- (void)beginUpdatesForSectionGroups:(NSSet <BGRecursiveTableViewDataSourceSectionGroup *>*)priorSectionGroups; // Use these internally instead of calling `UITableView` beginUpdates/endUpdates() methods.
- (void)endUpdatesForSectionGroups:(NSSet <BGRecursiveTableViewDataSourceSectionGroup *>*)priorSectionGroups;

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;


#pragma mark - Add/remove inner "section groups"

- (void)setInnerSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)innerSectionGroup forRowAtNonSubsectionIndexPath:(NSIndexPath *)indexPath isInitiallyActive:(BOOL)active; // Assign a subsection to appear/disappear below a parent row. — NOTE: Subsection rows are not factored into this NSIndexPath.
- (void)removeInnerSectionGroupForRowAtNonSubsectionIndexPath:(NSIndexPath *)indexPath; // NOTE: Be sure to remove rows using the method below if the entire section isn't or hasn't been removed.

- (void)insertOrRemoveRowsForInnerSectionGroupAtNonSubsectionIndexPath:(NSIndexPath *)indexPath isActive:(BOOL)active;


#pragma mark - Inner "section groups" operation support

- (id)nonSubsectionIndexPathForIndexPath:(NSIndexPath *)indexPath matchBlock:(id (^)(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSIndexPath *innerIndexPath))matchBlock; // You can use this function to access the subsection blocks, recursively, for rows via their relevant NSIndexPath(s). This function returns to its caller what your specified matchBlock() function returns if there is a matched row/block. If there is not a matched row/block (ie. if the number of rows/sections is exceeded), @(NSNotFound) is returned and the matchBlock() is not called. — NOTE: If the NSIndexPath passed to this function corresponds to a row that is not part of a subsection, the function is called without a "sectionGroup" but with a corrected "innerIndexPath" non-inclusive of the rows from any subsections also included in the NSIndexPath's section.

- (BOOL)innerSectionGroupAtNonSubsectionIndexPathIsActive:(NSIndexPath *)indexPath;


#pragma mark - Internal methods

- (void)setParentSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)parentSectionGroup;


@end
