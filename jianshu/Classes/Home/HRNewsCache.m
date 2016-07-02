//
//  HRNewsCache.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRNewsCache.h"

@implementation HRNewsCache
+(instancetype)sharedInstance {
    static id _instance;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance =[NSMutableArray array];
    });
    return  _instance;
}
@end
