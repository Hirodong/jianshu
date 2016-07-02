//
//  HRCardModel.h
//  jianshu
//
//  Created by Hiro on 16/5/24.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRCardModel : NSObject
/***/
@property (nonatomic,strong) NSString *hp_img_url;
@property (nonatomic,strong) NSString *hp_content;
/**<#注释#>*/
@property (nonatomic,strong) NSString *hp_author;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
