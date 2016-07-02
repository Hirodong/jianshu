//
//  HRNetworkTool.h
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface HRNetworkTool : AFHTTPSessionManager
+ (instancetype)ToolWithNewsBaseUrl;
+ (instancetype)sharedTool;
@end
