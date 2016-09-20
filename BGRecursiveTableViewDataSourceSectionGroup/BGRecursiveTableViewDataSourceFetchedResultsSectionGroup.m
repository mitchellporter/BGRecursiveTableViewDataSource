//
//  BGRecursiveTableViewDataSourceFetchedResultsSectionGroup.m
//  BGRecursiveTableViewDataSource
//
//  Created by Ben Guild on 4/2/16.
//  Copyright © 2016 Ben Guild. All rights reserved.
//

#import "BGRecursiveTableViewDataSourceFetchedResultsSectionGroup.h"


@interface BGRecursiveTableViewDataSourceFetchedResultsSectionGroup ()

@property (assign, nonatomic) BOOL isUpdating;


@end


@implementation BGRecursiveTableViewDataSourceFetchedResultsSectionGroup

- (instancetype)initWithTableView:(UITableView *)tableView fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    if (self=[super initWithTableView:tableView])
    {
        [self replaceFetchedResultsController:fetchedResultsController];
        
    }
    
    return self;
    
}

- (void)replaceFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    _fetchedResultsController=fetchedResultsController;
    [_fetchedResultsController setDelegate:self];
    
}

- (BOOL)updateCellAtIndexPathWithoutReloading:(NSIndexPath *)indexPath indexPathForFetchedResultControllerIfDifferent:(NSIndexPath *)newIndexPath becauseDidChangeObject:(id)anObject
{
    return NO;
    
}

- (BOOL)checkForTableViewDeallocationAndStopFetch
{
    if (![self tableView]) // Was the `UITableView` deallocated?
    {
        _fetchedResultsController=nil;
        
        return YES;
        
    }
    
    return NO;
    
}

#pragma mark <NSFetchedResultsControllerDelegate>

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([self checkForTableViewDeallocationAndStopFetch])
    {
        return;
        
    }
    ////
    
    [self endUpdatesForSectionGroups:[NSSet setWithObject:self]];
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // Do nothing. This is called when updates are actually triggered, if necessary. The reason for this is that beginUpdates()/endUpdates() can affect the scroll position/cell animation of rows and other table components, so we only want to enter/leave that state when actually necessary.
    
    /*
    if ([self checkForTableViewDeallocationAndStopFetch])
    {
        return;
        
    }
    ////
    
    [self beginUpdates];
    */
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if ([self checkForTableViewDeallocationAndStopFetch])
    {
        return;
        
    }
    ////
    
    if (type!=NSFetchedResultsChangeUpdate)
    {
        [self beginUpdatesForSectionGroups:nil];
        
    }
    ////
    
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [self insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeDelete:
            [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            if (![self updateCellAtIndexPathWithoutReloading:indexPath indexPathForFetchedResultControllerIfDifferent:(newIndexPath ?: indexPath) becauseDidChangeObject:anObject]) // NOTE: iOS 10 always provides "newIndexPath", but iOS 9 and below do not unless different.
            {
                [self beginUpdatesForSectionGroups:nil];
                ////
                
                [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
            break;
            
        case NSFetchedResultsChangeMove:
            if ([indexPath compare:newIndexPath]!=NSOrderedSame)
            {
                [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
            break;
            
    }
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if ([self checkForTableViewDeallocationAndStopFetch])
    {
        return;
        
    }
    ////
    
    [self beginUpdatesForSectionGroups:nil];
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        
        case NSFetchedResultsChangeDelete:
            [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
            
    }
    
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fetchedResultsController sections] count];
    
    // NOTE: We had to abandon the cool "section drop" strategy below because it was too buggy. However, with the inner sections... it's possible to do that sort of thing a different way, I guess.
    
    // return [super numberOfSectionsInTableView:tableView]+([[_fetchedResultsController sections] count]==1 && ![[[_fetchedResultsController sections] objectAtIndex:0] numberOfObjects] ? 0 : [[_fetchedResultsController sections] count]);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section]+([[_fetchedResultsController sections] count] ? [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects] : 0);
    
}

@end
