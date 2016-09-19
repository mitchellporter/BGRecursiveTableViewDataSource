//
//  SwitchToggledExampleSectionGroup.h
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/09/19.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "BGRecursiveTableViewDataSourceSectionGroup.h"

@interface SwitchToggledExampleSectionGroup : BGRecursiveTableViewDataSourceSectionGroup

@property (readonly, strong, nonatomic) BGRecursiveTableViewDataSourceSectionGroup *innerSectionGroup;

- (instancetype)initWithTableView:(UITableView *)tableView innerSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)innerSectionGroup isInitiallyActive:(BOOL)isInitiallyActive;


@end
