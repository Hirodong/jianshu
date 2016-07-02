//
//  HRNewsModel.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRNewsModel.h"
#import "HRNetworkTool.h"
#import <objc/runtime.h>
@implementation HRNewsModel
+(void)newsDataListWithUrlString:(NSString *)urlString complection:(void (^)(NSMutableArray *))complection {
    [[HRNetworkTool ToolWithNewsBaseUrl]GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        HRLog(@"%@",responseObject);
        NSArray *array = responseObject[responseObject.keyEnumerator.nextObject];
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            [arrayM addObject:[self newsModelWithDict:dict]];
        }
        complection(arrayM);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HRLog(@"error =%@",error);
    }];
}
+ (instancetype)newsModelWithDict :(NSDictionary *)dict {
    id obj = [[self alloc]init];
    for (NSString *key in [self properties]) {
        if (dict[key]) {
            [obj setValue:dict[key] forKey:key];
        }
    }
    return obj;
    
}
+ (NSArray *)properties {
    unsigned int outCount = 0;
    objc_property_t *properties =class_copyPropertyList([self class], &outCount);
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:outCount];
    for (int i = 0 ; i<outCount; i++) {
        objc_property_t property =properties[i];
        const char *name = property_getName(property);
        [arrayM addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return arrayM;
}
@end
