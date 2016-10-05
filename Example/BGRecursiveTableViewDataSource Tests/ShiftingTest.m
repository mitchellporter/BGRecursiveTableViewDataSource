//
//  ShiftingTest.m
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/10/05.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import <XCTest/XCTest.h>
////

#import "BGRecursiveTableViewDataSource.h"
#import "BGRecursiveTableViewDataSourceSectionGroup+Test.h"

#import "RedExampleSectionGroup.h"
#import "GreenExampleSectionGroup.h"
#import "BlueExampleSectionGroup.h"

#import "TestingMutableSectionGroup.h"


@interface ShiftingTest : XCTestCase

@property (strong, nonatomic) BGRecursiveTableViewDataSource *dataSource;
@property (strong, nonatomic) NSMutableOrderedSet<BGRecursiveTableViewDataSourceSectionGroup *> *sectionGroups;


@end


@implementation ShiftingTest

- (void)tearDown
{
    [super tearDown];
    ////
    
    XCTAssert(_dataSource!=nil);
    XCTAssert(_sectionGroups!=nil);
    
    XCTAssert([_sectionGroups isEqualToOrderedSet:[_dataSource sectionGroups]]);
    ////
    
    while ([_sectionGroups count])
    {
        NSUInteger index=arc4random_uniform((uint32_t)[_sectionGroups count]);
        
        [_dataSource removeSectionGroupAndItsDisplayedSections:[_sectionGroups objectAtIndex:index]];
        [_sectionGroups removeObjectAtIndex:index];
        
        XCTAssert([_sectionGroups isEqualToOrderedSet:[_dataSource sectionGroups]]);
        
    }
    
}

- (void)testBasicComposition
{
    UITableView *tableView=[UITableView new];
    
    _dataSource=[[BGRecursiveTableViewDataSource alloc] initWithTableView:tableView];
    [tableView setDataSource:_dataSource];
    ////
    
    _sectionGroups=[NSMutableOrderedSet new];
    NSMutableOrderedSet<BGRecursiveTableViewDataSourceSectionGroup *> *subSectionGroups=[NSMutableOrderedSet new];
    
    NSOrderedSet<Class> *classesForSectionGroups=[NSOrderedSet orderedSetWithObjects:[RedExampleSectionGroup class], [GreenExampleSectionGroup class], [BlueExampleSectionGroup class], nil];
    
    for (NSUInteger i=0; i<42; i++)
    {
        BGRecursiveTableViewDataSourceSectionGroup *(^randomSectionGroup)(void)=^BGRecursiveTableViewDataSourceSectionGroup *
        {
            return [[classesForSectionGroups objectAtIndex:arc4random_uniform((uint32_t)[classesForSectionGroups count])] new];;
            
        };
        
        BGRecursiveTableViewDataSourceSectionGroup *sectionGroup=randomSectionGroup();
        [_sectionGroups addObject:sectionGroup];
        ////
        
        BGRecursiveTableViewDataSourceSectionGroup *subSectionGroup=randomSectionGroup();
        [subSectionGroups addObject:subSectionGroup];
        
        [sectionGroup setInnerSectionGroup:subSectionGroup forRowAtNonSubsectionIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] isInitiallyActive:YES];
        ////
        
        [_dataSource appendSectionGroupToNewDataSource:sectionGroup];
        
    }
    
    [tableView reloadData];
    
}

- (void)testSubSectionRowShifting
{
    UITableView *tableView=[UITableView new];
    
    _dataSource=[[BGRecursiveTableViewDataSource alloc] initWithTableView:tableView];
    [tableView setDataSource:_dataSource];
    ////
    
    TestingMutableSectionGroup *(^newSubSectionGroup)(void)=^TestingMutableSectionGroup *
    {
        TestingMutableSectionGroup *subSectionGroup=[TestingMutableSectionGroup new];
        [subSectionGroup setSectionCount:1];
        [subSectionGroup setFirstSectionRowCount:arc4random_uniform(42)];
        
        return subSectionGroup;
        
    };
    
    _sectionGroups=[NSMutableOrderedSet new];
    NSMutableOrderedSet<NSMutableDictionary<NSNumber *, NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *>*> *subSectionGroupsForSectionGroups=[NSMutableOrderedSet new];
    
    for (NSUInteger sectionGroupLoop=0; sectionGroupLoop<42; sectionGroupLoop++)
    {
        TestingMutableSectionGroup *sectionGroup=[TestingMutableSectionGroup new];
        [sectionGroup setSectionCount:(sectionGroupLoop==2 ? 3 : arc4random_uniform(42))];
        
        [_sectionGroups addObject:sectionGroup];
        ////
        
        NSMutableDictionary<NSNumber *, NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *> *subSectionGroups=[NSMutableDictionary new];
        
        for (NSUInteger subSectionGroupLoop=0; subSectionGroupLoop<[sectionGroup sectionCount]; subSectionGroupLoop++)
        {
            TestingMutableSectionGroup *subSectionGroup=newSubSectionGroup();
            
            NSUInteger rowIndex=0;
            [sectionGroup setInnerSectionGroup:subSectionGroup forRowAtNonSubsectionIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:subSectionGroupLoop] isInitiallyActive:YES];
            
            [subSectionGroups setObject:(NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *)@{ @(rowIndex): subSectionGroup } forKey:@(subSectionGroupLoop)];
            
        }
        
        [subSectionGroupsForSectionGroups addObject:subSectionGroups];
        ////
        
        [_dataSource appendSectionGroupToNewDataSource:sectionGroup];
        
    }
    
    [tableView reloadData];
    
    XCTAssert([_sectionGroups isEqualToOrderedSet:[_dataSource sectionGroups]]);
    ////
    
    ^{
        NSUInteger fixedSectionGroupIndex=2;
        ////
        
        NSMutableDictionary<NSNumber *, NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *>*subSectionGroups=[subSectionGroupsForSectionGroups objectAtIndex:fixedSectionGroupIndex];
        
        void (^testSections)(void)=^
        {
            for (NSUInteger sectionTestLoop=0; sectionTestLoop<[subSectionGroups count]; sectionTestLoop++)
            {
                XCTAssert([[subSectionGroups objectForKey:@(sectionTestLoop)] isEqualToDictionary:[[[_sectionGroups objectAtIndex:fixedSectionGroupIndex] activeInnerSectionGroups] objectForKey:@(sectionTestLoop)]]);
                
            }
            
        };
        
        testSections();
        ////
        
        TestingMutableSectionGroup *sectionGroup=(TestingMutableSectionGroup *)[_sectionGroups objectAtIndex:fixedSectionGroupIndex];
        
        NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *(^insertSectionAtIndex)(NSUInteger)=^NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *(NSUInteger sectionIndex)
        {
            [sectionGroup insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            [sectionGroup setSectionCount:[sectionGroup sectionCount]+1];
            ////
            
            TestingMutableSectionGroup *subSectionGroup=newSubSectionGroup();
            
            NSUInteger rowIndex=0;
            [sectionGroup setInnerSectionGroup:subSectionGroup forRowAtNonSubsectionIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex] isInitiallyActive:YES];
            
            return (NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *)@{ @(rowIndex): subSectionGroup };
            
        };
        
        void (^deleteSectionAtIndex)(NSUInteger)=^(NSUInteger sectionIndex)
        {
            [sectionGroup deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            [sectionGroup setSectionCount:[sectionGroup sectionCount]-1];
            
        };
        ////
        
        ^{
            [subSectionGroups setObject:[subSectionGroups objectForKey:@(2)] forKey:@(3)];
            [subSectionGroups setObject:[subSectionGroups objectForKey:@(1)] forKey:@(2)];
            [subSectionGroups setObject:[subSectionGroups objectForKey:@(0)] forKey:@(1)];
            [subSectionGroups setObject:insertSectionAtIndex(0) forKey:@(0)];
            
            testSections();
            
        }();
        
        ^{
            [subSectionGroups setObject:[subSectionGroups objectForKey:@(3)] forKey:@(4)];
            [subSectionGroups setObject:[subSectionGroups objectForKey:@(2)] forKey:@(3)];
            [subSectionGroups setObject:insertSectionAtIndex(2) forKey:@(2)];
            
            testSections();
            
        }();
        
        ^{
            [subSectionGroups setObject:[subSectionGroups objectForKey:@(4)] forKey:@(5)];
            [subSectionGroups setObject:[subSectionGroups objectForKey:@(3)] forKey:@(4)];
            [subSectionGroups setObject:[subSectionGroups objectForKey:@(2)] forKey:@(3)];
            [subSectionGroups setObject:[subSectionGroups objectForKey:@(1)] forKey:@(2)];
            [subSectionGroups setObject:insertSectionAtIndex(1) forKey:@(1)];
            
            testSections();
            
        }();
        ////
        
        /*
        deleteSectionAtIndex(0);
        deleteSectionAtIndex(2);
        deleteSectionAtIndex(1);
        
        testSections();
        */
        
    }();
    
    
    
}

@end
