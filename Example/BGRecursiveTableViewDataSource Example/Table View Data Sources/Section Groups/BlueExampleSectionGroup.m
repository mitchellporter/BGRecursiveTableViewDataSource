//
//  BlueExampleSectionGroup.m
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/19.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "BlueExampleSectionGroup.h"

@implementation BlueExampleSectionGroup

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Blue Section #%ld", section+1];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
        
    }
    
    [[cell textLabel] setText:NSStringFromClass([self class])];
    [cell setBackgroundColor:[UIColor cyanColor]];
    
    return cell;
    
}

@end
