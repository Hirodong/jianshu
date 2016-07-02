//
//  HRNetworkTool.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRNetworkTool.h"

@implementation HRNetworkTool
+(instancetype)ToolWithNewsBaseUrl {
    static HRNetworkTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"http://c.m.163.com/nc/"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        instance =[[self alloc]initWithBaseURL:url sessionConfiguration:config];
        //加入text/HTML解析
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
        
    });
    return instance;
}
+(instancetype)sharedTool {
    static HRNetworkTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@""];
        NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
        instance =[[self alloc]initWithBaseURL:url sessionConfiguration:config];
        //加入text/html解析
        instance.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    });
    return instance;
}
@end
