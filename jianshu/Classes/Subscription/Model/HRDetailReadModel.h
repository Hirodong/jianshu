//
//  HRDetailReadModel.h
//  jianshu
//
//  Created by Hiro on 16/5/23.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRDetailReadModel : NSObject
/**<#注释#>*/
@property (nonatomic,strong) NSString  *auth_it;
/**<#注释#>*/
@property (nonatomic,strong) NSString *hp_author;
/**<#注释#>*/
@property (nonatomic,strong) NSString *web_url;
/**<#注释#>*/
@property (nonatomic,strong) NSString *hp_title;
/**<#注释#>*/
@property (nonatomic,strong) NSString *hp_content;

@property(nonatomic,assign) CGFloat cellHeight;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
