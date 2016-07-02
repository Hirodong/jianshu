//
//  HRReadListModel.m
//  jianshu
//
//  Created by Hiro on 16/5/21.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRReadListModel.h"

@implementation HRReadListModel
+(instancetype)modelWithDic:(NSDictionary *)dict {
    
    return [[self alloc]initWithDic:dict];
}

-(instancetype)initWithDic:(NSDictionary *)dic {
    if (self =[super init]) {
        self.hp_title=[dic objectForKey:@"hp_title"];
        
        self.guide_word=[dic objectForKey:@"guide_word"];
        
        self.author = [dic objectForKey:@"author"];
        self.user_name =[self.author[0] objectForKey:@"user_name"];
        self.content_id =[dic objectForKey:@"content_id"];
        self.web_url = [self.author[0] objectForKey:@"web_url"];
        
    }
    return self;
}

@end
