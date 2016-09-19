//
//  RedExampleSectionGroup.m
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/19.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "RedExampleSectionGroup.h"

@implementation RedExampleSectionGroup

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Red Section #%ld", section+1];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
        
    }
    
    [[cell textLabel] setText:NSStringFromClass([self class])];
    [cell setBackgroundColor:[UIColor redColor]];
    
    return cell;
    
}

@end
