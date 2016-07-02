//
//  HRPhotoModel.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRPhotoModel.h"
#include "HRPhotoDetailModel.h"
#import <objc/runtime.h>
#import "HRNetworkTool.h"
@implementation HRPhotoModel
+ (void)photoModelWithPhotosetID:(NSString *)photosetID complection:(void (^)(HRPhotoModel *))complection
{
    //	NSLog(@"有则正确 %@", photosetID); // 00AP0001|107920
    NSString *str = [photosetID substringFromIndex:4]; // 0001|107920
    NSArray *arr = [str componentsSeparatedByString:@"|"]; // @[@"0001", @"107920"]
    NSString *urlString = [NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/%@/%@.json", arr[0], arr[1]];
    //	NSLog(@"urlString = %@", urlString);
    [[HRNetworkTool sharedTool] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        HRPhotoModel *photoModel = [self photoModelWithDict:responseObject];
        complection(photoModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"DDPhotoDetailModel.m %@", error);
    }];
}

+ (instancetype)photoModelWithDict:(NSDictionary *)dict
{
    HRPhotoModel *obj = [[self alloc] init];
    
    //	[obj setValuesForKeysWithDictionary:dict];
    for (NSString *key in [self properties]) {
        if (dict[key]) {
            [obj setValue:dict[key] forKey:key];
        }
    }
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:obj.photos.count];
    for (NSDictionary *dict in obj.photos) {
        [arrayM addObject:[HRPhotoDetailModel photoDetailModelWithDict:dict]];
    }
    obj.photos = arrayM.copy;
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
