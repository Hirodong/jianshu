//
//  HRChannelModel.h
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRChannelModel : NSObject
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy, readonly) NSString *urlString;

+ (instancetype)channelWithDict:(NSDictionary *)dict;
+ (NSArray *)channels;
@end
