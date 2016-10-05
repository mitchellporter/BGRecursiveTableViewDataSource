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
        BGRecursiveTableViewDataSourceSectionGroup *(^randomSectionGroup)(void) = ^BGRecursiveTableViewDataSourceSectionGroup *
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

@end
