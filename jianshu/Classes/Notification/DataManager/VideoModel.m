//
//  VideoModel.m
//  jianshu
//
//  Created by Hiro on 16/5/19.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.descriptionDe = value;
    }
}
@end
