//
//  HRPhotoDetailModel.h
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRPhotoDetailModel : NSObject
/** 单个图片urlString */
@property (nonatomic, copy) NSString *imgurl;
/** 单个图片的简介 */
@property (nonatomic, copy) NSString *note;

@property (nonatomic, copy) NSString *photoid;

@property (nonatomic, copy) NSString *timgurl;

@property (nonatomic, copy) NSString *simgurl;

@property (nonatomic, copy) NSString *imgtitle;

@property (nonatomic, copy) NSString *newsurl;

@property (nonatomic, copy) NSString *photohtml;

@property (nonatomic, copy) NSString *squareimgurl;

@property (nonatomic, copy) NSString *cimgurl;




+ (instancetype)photoDetailModelWithDict:(NSDictionary *)dict;


@end
