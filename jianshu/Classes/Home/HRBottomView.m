//
//  HRBottomView.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRBottomView.h"
@interface HRBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@end
@implementation HRBottomView

- (void)awakeFromNib
{
    //	[self.commentCount setTitle:@" 23148" forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"comment_ collect"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"comment_ collect_selected"] forState:UIControlStateSelected];
}

- (IBAction)backBtn:(id)sender
{
    if (self.backBtnBlock) {
        self.backBtnBlock();
    }
}

- (IBAction)commentCountClick:(id)sender
{
    if (self.commentCountBlock) {
        self.commentCountBlock();
    }
}

- (IBAction)writeClick:(UIButton *)sender
{
    if (self.writeBlock) {
        self.writeBlock();
    }
}

- (IBAction)collecClick:(id)sender
{
    if (self.collectBlock) {
        self.collectBlock(sender);
    }
}

- (IBAction)downloadClick:(id)sender
{
    if (self.downloadBlock) {
        self.downloadBlock();
    }
}

@end
