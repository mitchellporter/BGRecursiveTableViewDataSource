//
//  BGRecursiveTableViewDataSourceSectionGroup.m
//  BGRecursiveTableViewDataSource
//
//  Created by Ben Guild on 2/11/16.
//  Copyright © 2016 Ben Guild. All rights reserved.
//

#import "BGRecursiveTableViewDataSourceSectionGroup.h"
////

#import "BGRecursiveTableViewDataSource.h"


@interface BGRecursiveTableViewDataSourceSectionGroup ()

@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *> *activeInnerSectionGroups;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *> *inactiveInnerSectionGroups;

@property (strong, nonatomic) NSMutableSet<BGRecursiveTableViewDataSourceSectionGroup *> *sectionGroups;


@end


@implementation BGRecursiveTableViewDataSourceSectionGroup

- (instancetype)initWithTableView:(UITableView *)tableView
{
    if (self=[super init])
    {
        _tableView=tableView;
        
    }
    
    return self;
    
}

- (NSIndexPath *)translateInternalIndexPathToTopLevel:(NSIndexPath *)indexPath
{
    return (_parentSectionGroup ? [_parentSectionGroup translateSubsectionIndexPathToTopLevel:indexPath forSubsection:self] : [(BGRecursiveTableViewDataSource *)[[self tableView] dataSource] translateInternalIndexPathToTopLevel:indexPath forTopLevelSectionGroup:self]);
    
}

- (NSIndexPath *)translateSubsectionIndexPathToTopLevel:(NSIndexPath *)indexPath forSubsection:(BGRecursiveTableViewDataSourceSectionGroup *)subsectionGroup
{
    NSIndexPath *(^checkDictionaryForBaseIndexPath)(NSDictionary <NSNumber *, NSDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *> *) = ^NSIndexPath *(NSDictionary <NSNumber *, NSDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *> *dictionary)
    {
        __block NSIndexPath *baseIndexPath;
        
        [dictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull sectionIndex, NSDictionary<NSNumber *,BGRecursiveTableViewDataSourceSectionGroup *> * _Nonnull innerDictionary, BOOL * _Nonnull stop)
        {
            [innerDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull rowIndex, BGRecursiveTableViewDataSourceSectionGroup * _Nonnull sectionGroup, BOOL * _Nonnull stop)
            {
                if (sectionGroup==subsectionGroup)
                {
                    baseIndexPath=[NSIndexPath indexPathForRow:[rowIndex integerValue] inSection:[sectionIndex integerValue]];
                    ////
                    
                    *stop=YES;
                    
                }
                
            } ];
            
            if (baseIndexPath)
            {
                *stop=YES;
                
            }
            
        } ];
        
        return baseIndexPath;
        
    };
    ////
    
    NSIndexPath *sectionGroupIndexPath=checkDictionaryForBaseIndexPath(_activeInnerSectionGroups);
    
    if (!sectionGroupIndexPath)
    {
        sectionGroupIndexPath=checkDictionaryForBaseIndexPath(_inactiveInnerSectionGroups);
        
    }
    ////
    
    NSIndexPath *returnIndexPath;
    
    if (sectionGroupIndexPath)
    {
        returnIndexPath=[self translateInternalIndexPathToTopLevel:[NSIndexPath indexPathForRow:[sectionGroupIndexPath row]+[indexPath row]+1 inSection:[sectionGroupIndexPath section]+[indexPath section]]]; // The +1 is because it's "pinned" to that row, and therefore appears 1 row below it to start.
        
    }
    
    return returnIndexPath;
    
}

- (NSSet<BGRecursiveTableViewDataSourceSectionGroup *> *)sectionGroups
{
    return [_sectionGroups copy];
    
}

- (NSDictionary<NSNumber *,BGRecursiveTableViewDataSourceSectionGroup *> *)activeInnerSectionGroupsForNonSubsectionSectionIndex:(NSUInteger)sectionIndex
{
    NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *dictionary=[_activeInnerSectionGroups objectForKey:@(sectionIndex)];
    
    return (dictionary ? [dictionary copy] : nil);
    
}

- (NSDictionary<NSNumber *,BGRecursiveTableViewDataSourceSectionGroup *> *)inactiveInnerSectionGroupsForNonSubsectionSectionIndex:(NSUInteger)sectionIndex
{
    NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *dictionary=[_inactiveInnerSectionGroups objectForKey:@(sectionIndex)];
    
    return (dictionary ? [dictionary copy] : nil);
    
}

#pragma mark - Row + section insertion/deletion (Use these convenience methods instead of the UITableView's).

- (void)beginUpdatesForSectionGroups:(NSSet<BGRecursiveTableViewDataSourceSectionGroup *> *)priorSectionGroups
{
    NSMutableSet *appendedSectionGroups=(priorSectionGroups ? [priorSectionGroups mutableCopy] : [NSMutableSet new]);
    [appendedSectionGroups addObject:self];
    
    return (_parentSectionGroup ? [_parentSectionGroup beginUpdatesForSectionGroups:appendedSectionGroups] : [(BGRecursiveTableViewDataSource *)[[self tableView] dataSource] beginUpdatesForSectionGroups:appendedSectionGroups]);
    
}

- (void)endUpdatesForSectionGroups:(NSSet<BGRecursiveTableViewDataSourceSectionGroup *> *)priorSectionGroups
{
    NSMutableSet *appendedSectionGroups=(priorSectionGroups ? [priorSectionGroups mutableCopy] : [NSMutableSet new]);
    [appendedSectionGroups addObject:self];
    
    return (_parentSectionGroup ? [_parentSectionGroup endUpdatesForSectionGroups:appendedSectionGroups] : [(BGRecursiveTableViewDataSource *)[[self tableView] dataSource] endUpdatesForSectionGroups:appendedSectionGroups]);
    
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:idx];
        NSIndexPath *translatedIndexPath=[self translateInternalIndexPathToTopLevel:indexPath];
        
        [self shiftAllInnerSectionGroupIndexPathAssociationsByOffset:[NSIndexPath indexPathForRow:0 inSection:1] atIndexPath:indexPath];
        [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:[translatedIndexPath section]] withRowAnimation:animation];
        
    } ];
    
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:idx];
        NSIndexPath *translatedIndexPath=[self translateInternalIndexPathToTopLevel:indexPath];
        
        [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:[translatedIndexPath section]] withRowAnimation:animation];
        
        [_activeInnerSectionGroups removeObjectForKey:@([indexPath section])];
        [_inactiveInnerSectionGroups removeObjectForKey:@([indexPath section])];
        
        [self shiftAllInnerSectionGroupIndexPathAssociationsByOffset:[NSIndexPath indexPathForRow:0 inSection:-1] atIndexPath:indexPath];
        
    } ];
    
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableIndexSet *translatedSectionIndexes=[NSMutableIndexSet new];
    
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:idx];
        NSIndexPath *translatedIndexPath=[self translateInternalIndexPathToTopLevel:indexPath];
        
        [translatedSectionIndexes addIndex:[translatedIndexPath section]];
        
    } ];
    ////
    
    [[self tableView] reloadSections:translatedSectionIndexes withRowAnimation:animation];
    
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [self shiftAllInnerSectionGroupIndexPathAssociationsByOffset:[NSIndexPath indexPathForRow:1 inSection:0] atIndexPath:indexPath];
        [[self tableView] insertRowsAtIndexPaths:@[[self translateInternalIndexPathToTopLevel:indexPath]] withRowAnimation:animation];
        
    } ];
    
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [[self tableView] deleteRowsAtIndexPaths:@[[self translateInternalIndexPathToTopLevel:indexPath]] withRowAnimation:animation];
        
        [[_activeInnerSectionGroups objectForKey:@([indexPath section])] removeObjectForKey:@([indexPath row])];
        [[_inactiveInnerSectionGroups objectForKey:@([indexPath section])] removeObjectForKey:@([indexPath row])];
        
        [self shiftAllInnerSectionGroupIndexPathAssociationsByOffset:[NSIndexPath indexPathForRow:-1 inSection:0] atIndexPath:indexPath];
        
    } ];
    
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableSet <NSIndexPath *>*translatedIndexPaths=[NSMutableSet new];
    
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [translatedIndexPaths addObject:[self translateInternalIndexPathToTopLevel:indexPath]];
        
    } ];
    ////
    
    [[self tableView] reloadRowsAtIndexPaths:[translatedIndexPaths allObjects] withRowAnimation:animation];
    
}

#pragma mark - Add/remove inner "section groups"

- (void)initiateInnerSectionGroupSetsIfNecessary
{
    if (!_activeInnerSectionGroups)
    {
        _activeInnerSectionGroups=[NSMutableDictionary new];
        _inactiveInnerSectionGroups=[NSMutableDictionary new];
        
    }
    
}

- (void)setInnerSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)innerSectionGroup forRowAtNonSubsectionIndexPath:(NSIndexPath *)indexPath isInitiallyActive:(BOOL)active
{
    [self initiateInnerSectionGroupSetsIfNecessary];
    ////
    
    NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *innerBlocksForSection=[(active ? _activeInnerSectionGroups : _inactiveInnerSectionGroups) objectForKey:@([indexPath section])];
    
    if (!innerBlocksForSection)
    {
        innerBlocksForSection=[NSMutableDictionary new];
        ////
        
        [(active ? _activeInnerSectionGroups : _inactiveInnerSectionGroups) setObject:innerBlocksForSection forKey:@([indexPath section])];
        
    }
    ////
    
    [innerSectionGroup setParentSectionGroup:self];
    
    [innerBlocksForSection setObject:innerSectionGroup forKey:@([indexPath row])];
    [_sectionGroups addObject:innerSectionGroup];
    
}

- (void)removeInnerSectionGroupForRowAtNonSubsectionIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *activeInnerSectionGroupsForSection=[_activeInnerSectionGroups objectForKey:@([indexPath section])];
    NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *inactiveInnerSectionGroupsForSection=[_inactiveInnerSectionGroups objectForKey:@([indexPath section])];
    
    BGRecursiveTableViewDataSourceSectionGroup *activeInnerSectionGroup=[activeInnerSectionGroupsForSection objectForKey:@([indexPath row])];
    BGRecursiveTableViewDataSourceSectionGroup *inactiveInnerSectionGroup=[inactiveInnerSectionGroupsForSection objectForKey:@([indexPath row])];
    
    if (activeInnerSectionGroup)
    {
        [activeInnerSectionGroupsForSection removeObjectForKey:@([indexPath row])];
        [_sectionGroups removeObject:activeInnerSectionGroup];
        
    }
    
    if (inactiveInnerSectionGroup)
    {
        [inactiveInnerSectionGroupsForSection removeObjectForKey:@([indexPath row])];
        [_sectionGroups removeObject:inactiveInnerSectionGroup];
        
    }
    
}

- (void)insertOrRemoveRowsForInnerSectionGroupAtNonSubsectionIndexPath:(NSIndexPath *)indexPath isActive:(BOOL)active
{
    [self initiateInnerSectionGroupSetsIfNecessary];
    ////
    
    NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *activeInnerSectionGroupsForSection=[_activeInnerSectionGroups objectForKey:@([indexPath section])];
    NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *inactiveInnerSectionGroupsForSection=[_inactiveInnerSectionGroups objectForKey:@([indexPath section])];
    
    BGRecursiveTableViewDataSourceSectionGroup *activeInnerSectionGroup=[activeInnerSectionGroupsForSection objectForKey:@([indexPath row])];
    BGRecursiveTableViewDataSourceSectionGroup *inactiveInnerSectionGroup=[inactiveInnerSectionGroupsForSection objectForKey:@([indexPath row])];
    
    BGRecursiveTableViewDataSourceSectionGroup *insertOrRemoveInnerSectionGroup=nil;
    
    if (active && inactiveInnerSectionGroup)
    {
        [inactiveInnerSectionGroupsForSection removeObjectForKey:@([indexPath row])];
        
        [self setInnerSectionGroup:inactiveInnerSectionGroup forRowAtNonSubsectionIndexPath:indexPath isInitiallyActive:YES];
        ////
        
        insertOrRemoveInnerSectionGroup=inactiveInnerSectionGroup;
        
    }
    else if (!active && activeInnerSectionGroup)
    {
        [activeInnerSectionGroupsForSection removeObjectForKey:@([indexPath row])];
        
        [self setInnerSectionGroup:activeInnerSectionGroup forRowAtNonSubsectionIndexPath:indexPath isInitiallyActive:NO];
        ////
        
        insertOrRemoveInnerSectionGroup=activeInnerSectionGroup;
        
    }
    ////
    
    if (insertOrRemoveInnerSectionGroup)
    {
        NSIndexPath *externalIndexPathOffset=[self translateInternalIndexPathToTopLevel:indexPath];
        ////
        
        NSUInteger rowOffset=0;
        NSUInteger nonSubsectionIndexPathRow=0;
        
        for (NSUInteger i=0; i<=[indexPath row]; i++) // We know that the lesser nonSubsectionIndexPath(s) cannot be higher than this row's index... even if there are no subsections configured.
        {
            rowOffset++;
            nonSubsectionIndexPathRow++;
            ////
            
            if (nonSubsectionIndexPathRow>[indexPath row])
            {
                break;
                
            }
            
            BGRecursiveTableViewDataSourceSectionGroup *innerSectionGroup=[activeInnerSectionGroupsForSection objectForKey:@(i)];
            
            if (innerSectionGroup)
            {
                for (NSUInteger j=0; j<[innerSectionGroup numberOfSectionsInTableView:[self tableView]]; j++)
                {
                    rowOffset+=[innerSectionGroup tableView:[self tableView] numberOfRowsInSection:j];
                    
                    if (nonSubsectionIndexPathRow>[indexPath row])
                    {
                        break;
                        
                    }
                    
                }
                
            }
            
            if (nonSubsectionIndexPathRow>[indexPath row])
            {
                break;
                
            }
            
        }
        ////
        
        NSMutableArray *indexPaths=[NSMutableArray new];
        
        for (NSUInteger i=0; i<[insertOrRemoveInnerSectionGroup numberOfSectionsInTableView:[self tableView]]; i++)
        {
            for (NSUInteger j=0; j<[insertOrRemoveInnerSectionGroup tableView:[self tableView] numberOfRowsInSection:i]; j++)
            {
                [indexPaths addObject:[NSIndexPath indexPathForRow:[externalIndexPathOffset row]+rowOffset+j inSection:[externalIndexPathOffset section]]];
                
            }
            
        }
        
        if (active)
        {
            [[self tableView] insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
        }
        else
        {
            [[self tableView] deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
    }
    
}

- (void)shiftAllInnerSectionGroupIndexPathAssociationsByOffset:(NSIndexPath *)offset atIndexPath:(NSIndexPath *)indexPath
{
    if (!_activeInnerSectionGroups)
    {
        return;
        
    }
    ////
    
    void (^shiftDictionaryKeys)(NSMutableDictionary *, NSInteger, NSUInteger)=^(NSMutableDictionary *dictionary, NSInteger offset, NSUInteger indexTarget)
    {
        for (NSNumber *key in (offset>0 ? [[[dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] : [[dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)]))
        {
            NSInteger newKey=NSNotFound;
            
            if ([key integerValue]>=indexTarget)
            {
                newKey=[key integerValue]+offset;
                
            }
            
            if (newKey!=NSNotFound)
            {
                [dictionary setObject:[dictionary objectForKey:key] forKey:@(newKey)];
                [dictionary removeObjectForKey:key];
                
            }
            
        }
        
    };
    ////
    
    for (NSMutableDictionary *dictionary in @[_activeInnerSectionGroups, _inactiveInnerSectionGroups])
    {
        if ([offset row]!=0)
        {
            shiftDictionaryKeys([dictionary objectForKey:@([indexPath section])], [offset row], [indexPath row]);
        
        }
        
        if ([offset section]!=0)
        {
            shiftDictionaryKeys(dictionary, [offset section], [indexPath section]);
            
        }
        
    }
    
}

#pragma mark - Inner "section groups" operation support

- (id)nonSubsectionIndexPathForIndexPath:(NSIndexPath *)indexPath matchBlock:(id (^)(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSIndexPath *innerIndexPath))matchBlock
{
    if ([_activeInnerSectionGroups count])
    {
        NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *activeInnerSectionGroupsForSection=[_activeInnerSectionGroups objectForKey:@([indexPath section])];
        
        NSInteger remainingRowIndexOffset=[indexPath row];
        
        BGRecursiveTableViewDataSourceSectionGroup *sectionGroupThatMatched;
        NSUInteger innerIndexPathSection=[indexPath section]; // NOTE (2016/09/12): This fixes the bug with the toggleable section BEFORE the non-toggleable section.
        NSUInteger innerIndexPathRow=0;
        
        for (NSUInteger i=0; i<=[indexPath row]; i++) // We know that the lesser nonSubsectionIndexPath(s) cannot be higher than this row's index... even if there are no subsections configured.
        {
            remainingRowIndexOffset--;
            ////
            
            if (remainingRowIndexOffset<0)
            {
                break;
                
            }
            
            BGRecursiveTableViewDataSourceSectionGroup *innerSectionGroup=[activeInnerSectionGroupsForSection objectForKey:@(i)];
            
            if (innerSectionGroup)
            {
                for (NSUInteger j=0; j<[innerSectionGroup numberOfSectionsInTableView:[self tableView]]; j++)
                {
                    NSInteger preSubstractionRemainingRowIndexOffset=remainingRowIndexOffset;
                    remainingRowIndexOffset-=[innerSectionGroup tableView:[self tableView] numberOfRowsInSection:j];
                    
                    if (remainingRowIndexOffset<=0)
                    {
                        innerIndexPathSection=j; // NOTE (2016/09/12): These was moved into here as a precaution while debugging something else. Has not been investigated in depth, but seemed like a worthwhile guard.
                        innerIndexPathRow=preSubstractionRemainingRowIndexOffset;
                        
                        break;
                        
                    }
                    
                }
                
            }
            
            if (remainingRowIndexOffset<0)
            {
                sectionGroupThatMatched=innerSectionGroup;
                break;
                
            }
            
        }
        ////
        
        __block BGRecursiveTableViewDataSourceSectionGroup *returnSectionGroup=sectionGroupThatMatched;
        __block NSIndexPath *returnIndexPath=[NSIndexPath indexPathForRow:innerIndexPathRow inSection:innerIndexPathSection];
        
        [returnSectionGroup nonSubsectionIndexPathForIndexPath:returnIndexPath matchBlock:^id(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSIndexPath *innerIndexPath)
        {
            if (sectionGroup)
            {
                returnSectionGroup=sectionGroup;
                
            }
            ////
            
            returnIndexPath=innerIndexPath;
            
            return nil;
            
        } ];
        
        return matchBlock(returnSectionGroup, returnIndexPath);
        
    }
    
    return @(NSNotFound);
    
}

- (BOOL)innerSectionGroupAtNonSubsectionIndexPathIsActive:(NSIndexPath *)indexPath
{
    if (!_activeInnerSectionGroups)
    {
        return NO;
        
    }
    ////
    
    NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *innerBlocksForSection=[_activeInnerSectionGroups objectForKey:@([indexPath section])];
    
    return !(![innerBlocksForSection objectForKey:@([indexPath row])]);
    
}

#pragma mark - Internal methods

- (void)setParentSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)parentSectionGroup
{
    _parentSectionGroup=parentSectionGroup;
    
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count=0;
    
    if ([_activeInnerSectionGroups count])
    {
        NSDictionary *activeInnerSectionGroupsForSection=[_activeInnerSectionGroups objectForKey:@(section)];
        
        for (NSNumber *row in [[activeInnerSectionGroupsForSection allKeys] sortedArrayUsingSelector:@selector(compare:)])
        {
            BGRecursiveTableViewDataSourceSectionGroup *innerSectionGroup=[activeInnerSectionGroupsForSection objectForKey:row];
            
            for (NSUInteger i=0; i<[innerSectionGroup numberOfSectionsInTableView:tableView]; i++)
            {
                count+=[innerSectionGroup tableView:tableView numberOfRowsInSection:i];
                
            }
            
        }
        
    }
    
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
    
}

@end
