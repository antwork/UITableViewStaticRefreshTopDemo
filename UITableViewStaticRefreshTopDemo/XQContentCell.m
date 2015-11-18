//
//  XQContentCell.m
//  UITableViewStaticRefreshTopDemo
//
//  Created by Bill on 15/11/17.
//  Copyright © 2015年 XQ. All rights reserved.
//

#import "XQContentCell.h"

@implementation XQContentCell

- (void)awakeFromNib {
    self.valueField.font = [UIFont systemFontOfSize:16.0f];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
