//
//  HRReadListModel.h
//  jianshu
//
//  Created by Hiro on 16/5/21.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRReadListModel : NSObject
/**<#注释#>*/
@property (nonatomic,strong) NSString *hp_title;
/**<#注释#>*/
@property (nonatomic,strong) NSString *guide_word;
/**<#注释#>*/
@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,strong) NSArray *author;
@property (nonatomic,strong) NSString *content_id;
@property (nonatomic,strong) NSString *web_url;
- (instancetype)initWithDic:(NSDictionary *)dic;


@end
