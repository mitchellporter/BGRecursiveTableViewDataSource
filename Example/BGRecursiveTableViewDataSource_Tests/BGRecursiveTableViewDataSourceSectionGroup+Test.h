//
//  BGRecursiveTableViewDataSourceSectionGroup+Test.h
//  BGRecursiveTableViewDataSource Example
//
//  Created by Ben Guild on 2016/10/05.
//  Copyright © 2016年 Ben Guild. All rights reserved.
//

#import "BGRecursiveTableViewDataSourceSectionGroup.h"

@interface BGRecursiveTableViewDataSourceSectionGroup (Test)

@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *> *activeInnerSectionGroups;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSMutableDictionary<NSNumber *, BGRecursiveTableViewDataSourceSectionGroup *> *> *inactiveInnerSectionGroups;

- (void)shiftAllInnerSectionGroupIndexPathAssociationsByOffset:(NSIndexPath *)offset atIndexPath:(NSIndexPath *)indexPath;


@end
