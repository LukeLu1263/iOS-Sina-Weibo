//
//  FriendshipsCell.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-16.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "FriendshipsCell.h"
#import "UserGridView.h"

@implementation FriendshipsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews {
    for (int i=0; i<3; i++) {
        UserGridView *gridView = [[UserGridView alloc] initWithFrame:CGRectZero];
        gridView.tag = 2013+i;
        [self.contentView addSubview:gridView];
        [gridView release];
    }
}

- (void)setData:(NSArray *)data {
    if (_data != data) {
        [_data release];
        _data = [data retain];
    }
    
    for (int i=0; i < 3; i++) {
        int tag = 2013+i;
        UserGridView *gridView = (UserGridView *)[self.contentView viewWithTag:tag];
        gridView.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i=0; i<self.data.count; i++) {
        UserModel *userModel = [self.data objectAtIndex:i];
        int tag = 2013+i;
        UserGridView *gridView = (UserGridView *)[self.contentView viewWithTag:tag];
        gridView.frame = CGRectMake(100*i+12, 10, 96, 96);
        gridView.userModel = userModel;
        gridView.hidden = NO;
        
        // 让gridView 异步调用layoutSubviews
        [gridView setNeedsLayout];
    }

}

@end
