//
//  HRDetailReadModel.m
//  jianshu
//
//  Created by Hiro on 16/5/23.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRDetailReadModel.h"
#import "HRDetailController.h"
@implementation HRDetailReadModel

+(instancetype)modelWithDic:(NSDictionary*)dict {
    return [[self alloc]initWithDic:dict];
}
-(instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {

        self.hp_title = [dic objectForKey:@"hp_title"];
        self.hp_author = [dic objectForKey:@"hp_author"];
        self.hp_content = [dic objectForKey:@"hp_content"];
        self.auth_it = [dic objectForKey:@"auth_it"];
        
    }
    return self;
}
-(CGFloat)cellHeight {
    if (!_cellHeight) {
        CGSize maxSize =CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
        CGFloat textH= [self.hp_content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
      
        _cellHeight =textH+1000;
        NSLog(@"%f",_cellHeight);
    }
    return _cellHeight;
}
@end
