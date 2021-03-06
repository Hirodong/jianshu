//
//  HRPhotoDetailModel.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRPhotoDetailModel.h"
#import <objc/runtime.h>
@implementation HRPhotoDetailModel
+ (instancetype)photoDetailModelWithDict:(NSDictionary *)dict
{
    id obj = [[self alloc] init];
    
    //	[obj setValuesForKeysWithDictionary:dict];
    for (NSString *key in [self properties]) {
        if (dict[key]) {
            [obj setValue:dict[key] forKey:key];
        }
    }
    
    return obj;
}

+ (NSArray *)properties
{
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:outCount];
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [arrayM addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    
    return arrayM;
}

@end
