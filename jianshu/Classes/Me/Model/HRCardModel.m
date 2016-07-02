//
//  HRCardModel.m
//  jianshu
//
//  Created by Hiro on 16/5/24.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRCardModel.h"

@implementation HRCardModel
+(instancetype)modelWithDic:(NSDictionary*)dict {
    return [[self alloc]initWithDic:dict];
}
-(instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        
        self.hp_img_url = [dic objectForKey:@"hp_img_url"];
        self.hp_author = [dic objectForKey:@"hp_author"];
        self.hp_content = [dic objectForKey:@"hp_content"];
        
        
    }
    return self;
}

@end
