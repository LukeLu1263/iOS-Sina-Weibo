//
//  FriendshipsTableView.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-16.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "FriendshipsTableView.h"
#import "FriendshipsCell.h"

@implementation FriendshipsTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"FriendshipsCell";
    FriendshipsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[FriendshipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *array = [self.data objectAtIndex:indexPath.row];
    cell.data = array;
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

@end
