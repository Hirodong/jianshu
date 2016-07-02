//
//  HRChannelCell.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRChannelCell.h"
#import "HRNewsTVC.h"
#import "UIView+Extension.h"
@implementation HRChannelCell
-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        HRLogFunc;
    }
    return self;
}
-(void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"HRNewsTVC" bundle:nil];
    _newsTVC = [sb instantiateInitialViewController];
    _newsTVC.view.frame = self.bounds;
    _newsTVC.urlString = urlString;
    [self addSubview:_newsTVC.view];
    
}
@end
