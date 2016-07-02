//
//  HRNewsModel.h
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRNewsModel : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 摘要 */
@property (nonatomic, copy) NSString *digest;
/** 图片链接 */
@property (nonatomic, copy) NSString *imgsrc;
/** 跟贴数 */
@property (nonatomic, assign) int replyCount;
/** 多张配图 */
@property (nonatomic, strong) NSArray *imgextra;
/** 大图标记 */
@property (nonatomic, assign) BOOL imgType;
@property (nonatomic, copy) NSArray *ads;
/** 进入后是图片详情 */
@property (nonatomic, copy) NSString *photosetID;
/** 进入后是新闻web详情 */
@property (nonatomic, copy) NSString *url;
/** 新闻ID */
@property (nonatomic,copy) NSString *docid;
@property (nonatomic,copy) NSString *boardid;
+ (void)newsDataListWithUrlString:(NSString *)urlString complection:(void (^)(NSMutableArray *array))complection;
@end
