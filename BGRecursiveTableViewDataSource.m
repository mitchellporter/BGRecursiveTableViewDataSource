//
//  BGRecursiveTableViewDataSource.m
//  BGRecursiveTableViewDataSource
//
//  Created by Ben Guild on 2/11/16.
//  Copyright © 2016 Ben Guild. All rights reserved.
//

#import "BGRecursiveTableViewDataSource.h"
////

#import "BGRecursiveTableViewDataSourceSectionGroup.h"


@interface BGRecursiveTableViewDataSource ()

@property (strong, nonatomic) NSMutableOrderedSet<BGRecursiveTableViewDataSourceSectionGroup *> *sectionGroups;
@property (strong, nonatomic) NSMutableSet *sectionGroupsUpdating;


@end


@implementation BGRecursiveTableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView
{
    if (self=[super init])
    {
        _tableView=tableView;
        ////
        
        _sectionGroups=[NSMutableOrderedSet new];
        _sectionGroupsUpdating=[NSMutableSet new];
        
    }
    
    return self;
    
}

- (void)appendSectionGroupToNewDataSource:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup
{
    [_sectionGroups addObject:sectionGroup];
    
}

- (void)beginUpdatesForSectionGroups:(NSSet <BGRecursiveTableViewDataSourceSectionGroup *>*)sectionGroups
{
    if (![_sectionGroupsUpdating count])
    {
        [[self tableView] beginUpdates];
        
    }
    
    [_sectionGroupsUpdating addObjectsFromArray:[sectionGroups allObjects]];
    
}

- (void)endUpdatesForSectionGroups:(NSSet <BGRecursiveTableViewDataSourceSectionGroup *>*)sectionGroups
{
    if ([_sectionGroupsUpdating count])
    {
        [sectionGroups enumerateObjectsUsingBlock:^(BGRecursiveTableViewDataSourceSectionGroup * _Nonnull sectionGroup, BOOL * _Nonnull stop)
        {
            [_sectionGroupsUpdating removeObject:sectionGroup];
            ////
            
            if (![_sectionGroupsUpdating count])
            {
                *stop=YES;
                
            }
            
        } ];
        ////
        
        if (![_sectionGroupsUpdating count])
        {
            [[self tableView] endUpdates];
            
        }
        
    }
    
}

- (NSOrderedSet *)sectionGroups
{
    return [_sectionGroups copy];
    
}

- (void)throwExceptionForSectionGroupNotFound
{
    [NSException raise:[NSString stringWithFormat:@"%@-%@", NSStringFromClass([self class]), @"SectionNotPartOfDataSource"] format:@"Internal error. `%@` does not have this section group as part of its configuration.", NSStringFromClass([self class])];
    
}

- (NSRange)actualSectionIndexRangeForSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup;
{
    NSUInteger priorSectionCount=0;
    
    for (BGRecursiveTableViewDataSourceSectionGroup *sectionGroupToCheck in _sectionGroups)
    {
        NSUInteger numberOfSectionsInThisGroup=[sectionGroupToCheck numberOfSectionsInTableView:[self tableView]];
        
        if (sectionGroupToCheck==sectionGroup)
        {
            return NSMakeRange(priorSectionCount, numberOfSectionsInThisGroup);
            
        }
        ////
        
        priorSectionCount+=numberOfSectionsInThisGroup;
        
    }
    
    [self throwExceptionForSectionGroupNotFound];
    
    return NSMakeRange(NSNotFound, 0);
    
}

- (NSIndexSet *)actualSectionIndexesForSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup;
{
    NSRange rangeOfIndexes=[self actualSectionIndexRangeForSectionGroup:sectionGroup];
    
    return (rangeOfIndexes.length==0 ? nil : [[NSIndexSet alloc] initWithIndexesInRange:rangeOfIndexes]);
    
}

- (void)removeSectionGroupAndItsDisplayedSections:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup
{
    NSIndexSet *sectionIndexes=[self actualSectionIndexesForSectionGroup:sectionGroup];
    [_sectionGroups removeObject:sectionGroup];
    
    [[self tableView] deleteSections:sectionIndexes withRowAnimation:UITableViewRowAnimationFade];
    
}

- (id)innerSectionIndexforTopLevelSectionIndex:(NSInteger)section matchBlock:(id (^)(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSUInteger innerSectionIndex))matchBlock
{
    NSUInteger priorSectionCount=0;
    
    for (BGRecursiveTableViewDataSourceSectionGroup *sectionGroup in _sectionGroups)
    {
        NSUInteger numberOfSectionsInThisGroup=[sectionGroup numberOfSectionsInTableView:[self tableView]];
        
        if (section<priorSectionCount+numberOfSectionsInThisGroup)
        {
            return matchBlock(sectionGroup, section-priorSectionCount);
            
        }
        ////
        
        priorSectionCount+=numberOfSectionsInThisGroup;
        
    }
    
    [self throwExceptionForSectionGroupNotFound];
    
    return @(NSNotFound);
    
}

- (void)insertSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup atIndexForSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroupForIndex insertAfter:(BOOL)insertAfter
{
    NSRange sectionIndexRangeForThisSectionGroup=[self actualSectionIndexRangeForSectionGroup:sectionGroupForIndex]; // NOTE: This function doesn't need to throw an exception because `actualSectionIndexRangeForSectionGroup` throws one. :)
    
    [_sectionGroups insertObject:sectionGroup atIndex:[_sectionGroups indexOfObject:sectionGroupForIndex]+insertAfter];
    
    [[self tableView] insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange((insertAfter ? sectionIndexRangeForThisSectionGroup.location+sectionIndexRangeForThisSectionGroup.length : sectionIndexRangeForThisSectionGroup.location), [sectionGroup numberOfSectionsInTableView:[self tableView]])] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (id)resolveSectionGroupAndInnerIndexPathForTopLevelIndexPath:(NSIndexPath *)indexPath matchBlock:(id (^)(BGRecursiveTableViewDataSourceSectionGroup *, NSIndexPath *))matchBlock
{
    return [self innerSectionIndexforTopLevelSectionIndex:[indexPath section] matchBlock:^id(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSUInteger innerSectionIndex)
    {
        __block BGRecursiveTableViewDataSourceSectionGroup *sectionGroupToReturn;
        __block NSIndexPath *indexPathForCellInSectionGroup;
        
        [sectionGroup nonSubsectionIndexPathForIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:innerSectionIndex] matchBlock:^id(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSIndexPath *innerIndexPath)
        {
            sectionGroupToReturn=sectionGroup;
            indexPathForCellInSectionGroup=innerIndexPath;
            
            return nil;
            
        } ];
        
        if (!sectionGroupToReturn)
        {
            sectionGroupToReturn=sectionGroup;
            
        }
        
        if (!indexPathForCellInSectionGroup)
        {
            indexPathForCellInSectionGroup=[NSIndexPath indexPathForRow:[indexPath row] inSection:innerSectionIndex];
            
        }
        ////
        
        return matchBlock(sectionGroupToReturn, indexPathForCellInSectionGroup);
        
    } ];
    
}

- (NSIndexPath *)translateInternalIndexPathToTopLevel:(NSIndexPath *)indexPath forTopLevelSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup;
{
    return [NSIndexPath indexPathForRow:[indexPath row] inSection:[self actualSectionIndexRangeForSectionGroup:sectionGroup].location+[indexPath section]];
    
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger sectionCount=0;
    
    for (BGRecursiveTableViewDataSourceSectionGroup *sectionGroup in  _sectionGroups)
    {
        sectionCount+=[sectionGroup numberOfSectionsInTableView:tableView];
        
    }
    
    return sectionCount;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self innerSectionIndexforTopLevelSectionIndex:section matchBlock:^id(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSUInteger innerSectionIndex)
    {
        return @([sectionGroup tableView:tableView numberOfRowsInSection:innerSectionIndex]);
        
    } ] integerValue];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self innerSectionIndexforTopLevelSectionIndex:section matchBlock:^id(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSUInteger innerSectionIndex)
    {
        return ([sectionGroup respondsToSelector:@selector(tableView:titleForHeaderInSection:)] ? [sectionGroup tableView:tableView titleForHeaderInSection:innerSectionIndex] : nil);
        
    } ];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [self innerSectionIndexforTopLevelSectionIndex:section matchBlock:^id(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSUInteger innerSectionIndex)
    {
        return ([sectionGroup respondsToSelector:@selector(tableView:titleForFooterInSection:)] ? [sectionGroup tableView:tableView titleForFooterInSection:innerSectionIndex] : nil);
        
    } ];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self resolveSectionGroupAndInnerIndexPathForTopLevelIndexPath:indexPath matchBlock:^id(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSIndexPath *innerIndexPath)
    {
        return [sectionGroup tableView:tableView cellForRowAtIndexPath:innerIndexPath];
        
    } ];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self resolveSectionGroupAndInnerIndexPathForTopLevelIndexPath:indexPath matchBlock:^id(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSIndexPath *innerIndexPath)
    {
        return @(([sectionGroup respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)] ? [sectionGroup tableView:tableView canEditRowAtIndexPath:innerIndexPath] : false));
        
    } ] boolValue];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resolveSectionGroupAndInnerIndexPathForTopLevelIndexPath:indexPath matchBlock:^id(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSIndexPath *innerIndexPath)
    {
        if ([sectionGroup respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
        {
            [sectionGroup tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:innerIndexPath];
            
        }
        
        return nil;
        
    } ];
    
}

@end
