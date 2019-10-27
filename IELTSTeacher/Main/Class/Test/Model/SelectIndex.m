//
//  SelectIndex.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/18.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "SelectIndex.h"
#import "IETextTableViewCell.h"
@implementation SelectIndex
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    if (_selectedIndex >= self.items.count) {
        _selectedIndex = 0;
    }
    
    // 遍历当前组所有的模型
    for (int i = 0; i < self.items.count; i++) {
        // 取出遍历到得模型
      IETextTableViewCell *cell  = self.items[i];
        if (i == _selectedIndex) {
            if ([cell.selectImage.image isEqual:[UIImage imageNamed:@"allSubmit_xuanzgibf"]]) {
                [cell.selectImage setImage:[UIImage imageNamed:@""]];
            }else{
        
                [cell.selectImage setImage:[UIImage imageNamed:@"allSubmit_xuanzgibf"]];
            }
            
        }else
        {
//            item.check = NO;
        }
    }
}
- (void)setItems:(NSArray *)items{

    self.selectedIndex = _selectedIndex;
}
@end
