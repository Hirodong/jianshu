//
//  HRReadListCell.m
//  jianshu
//
//  Created by Hiro on 16/5/21.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRReadListCell.h"

@implementation HRReadListCell
-(void)setReadListModel:(HRReadListModel *)readListModel{
    _readListModel = readListModel;
    self.hp_titleLabel.text = readListModel.hp_title;
    self.guide_wordLabel.text = readListModel.guide_word;
    self.user_nameLabel.text =[NSString stringWithFormat:@"作者：%@",readListModel.user_name];
//    self.user_nameLabel.text =readListModel.user_name;

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HRReadListCell" owner:nil options:nil].lastObject;
    }
    return self;
}







- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
