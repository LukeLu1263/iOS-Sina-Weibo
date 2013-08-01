//
//  CommentTableView.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-9.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"
#import "CommentModel.h"

@implementation CommentTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
    }
    return self;
}


#pragma mark - UITableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"CommentCell"; // 需要与xib里的 identify一样
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
    }
    
    CommentModel *commentModel = [self.data objectAtIndex:indexPath.row];
    cell.commentModel = commentModel;
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *commentModel = [self.data objectAtIndex:indexPath.row];
    float h = [CommentCell getCommentCellHeight:commentModel];
    return h+40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)]; //只有协议方法才能指定高度
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *commentCount = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    commentCount.backgroundColor = [UIColor clearColor];
    commentCount.font = [UIFont boldSystemFontOfSize:16.0f];
    commentCount.textColor = [UIColor blueColor];
    
    NSNumber *total = [self.commentDic objectForKey:@"total_number"];
    commentCount.text = [NSString stringWithFormat:@"评论:%@", total];
    [view addSubview:commentCount];
    [commentCount release];
    
    UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, tableView.width, 1)];
    separatorView.image = [UIImage imageNamed:@"userinfo_header_separator.png"];
    [view addSubview:separatorView];
    [separatorView release];
    
    return [view autorelease];
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

@end
