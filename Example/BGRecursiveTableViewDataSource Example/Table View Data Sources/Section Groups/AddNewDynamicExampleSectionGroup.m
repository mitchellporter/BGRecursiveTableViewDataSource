//
//  AddNewDynamicExampleSectionGroup.m
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/20.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "AddNewDynamicExampleSectionGroup.h"

@implementation AddNewDynamicExampleSectionGroup

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView]+1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Orange Section #%ld", section+1];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section]+1+_addedRows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
        
    }
    
    [[cell textLabel] setText:@"Tap to add rows" /* NSStringFromClass([self class]) */];
    [cell setBackgroundColor:[UIColor orangeColor]];
    
    return cell;
    
}

@end
