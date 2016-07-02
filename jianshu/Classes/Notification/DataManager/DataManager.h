//
//  DataManager.h
//  jianshu
//
//  Created by Hiro on 16/5/19.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^onSuccess)(NSArray *sidArray,NSArray *videoArray);
typedef void(^onFailed)(NSError *error);

@interface DataManager : NSObject

@property(nonatomic,copy)NSArray *sidArray;
@property(nonatomic,copy)NSArray *videoArray;



+(DataManager *)shareManager;
- (void)getSIDArrayWithURLString:(NSString *)URLString success:(onSuccess)success failed:(onFailed)failed;

- (void)getVideoListWithURLString:(NSString *)URLString ListID:(NSString *)ID success:(onSuccess)success failed:(onFailed)failed;
@end
