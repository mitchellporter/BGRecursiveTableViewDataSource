//
//  YellowExampleSectionGroup.m
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/20.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "YellowExampleSectionGroup.h"
////

#import "BlueExampleSectionGroup.h"


@implementation YellowExampleSectionGroup

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView]+1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section]+3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
        
    }
    
    [[cell textLabel] setText:([[self parentSectionGroup] isKindOfClass:[BlueExampleSectionGroup class]]  ? @"... Without modifying parent!" : @"Subsection at `indexPath`!") /* NSStringFromClass([self class]) */];
    [cell setBackgroundColor:[UIColor yellowColor]];
    
    return cell;
    
}

@end
