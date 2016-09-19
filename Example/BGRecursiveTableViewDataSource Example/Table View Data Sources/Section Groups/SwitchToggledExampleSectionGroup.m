//
//  SwitchToggledExampleSectionGroup.m
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/19.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "SwitchToggledExampleSectionGroup.h"


@interface SwitchToggledExampleSectionGroup ()

@property (weak, nonatomic) UISwitch *definitionSwitch;
@property (assign, nonatomic) BOOL isOn;


@end


@implementation SwitchToggledExampleSectionGroup

- (instancetype)initWithTableView:(UITableView *)tableView innerSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)innerSectionGroup isInitiallyActive:(BOOL)isInitiallyActive
{
    if (self=[super initWithTableView:tableView])
    {
        _innerSectionGroup=innerSectionGroup;
        _isOn=isInitiallyActive;
        
        [self setInnerSectionGroup:innerSectionGroup forRowAtNonSubsectionIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] isInitiallyActive:isInitiallyActive];
        
    }
    
    return self;
    
}

#pragma mark - Section toggling

- (void)sectionToggleSwitchWasChanged:(id)sender
{
    _isOn=[sender isOn];
    
    [self insertOrRemoveRowsAndSetInnerSectionGroupAtNonSubsectionIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] isActive:[sender isOn]];
    
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView]+1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section]+(!section ? 1 : 0);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[super tableView:tableView cellForRowAtIndexPath:indexPath];
    ////
    
    if (![indexPath section] && ![indexPath row])
    {
        if (!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
            
        }
        
        [[cell textLabel] setText:NSStringFromClass([self class])];
        [cell setBackgroundColor:[UIColor purpleColor]];
        ////
        
        UISwitch *switchForCell=[UISwitch new];
        [switchForCell setOn:_isOn];
        
        [switchForCell removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
        [switchForCell addTarget:self action:@selector(sectionToggleSwitchWasChanged:) forControlEvents:UIControlEventValueChanged];
        
        [cell setAccessoryView:switchForCell];
        
    }
    
    return cell;
    
}

@end
