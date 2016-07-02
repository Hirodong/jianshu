//
//  HRPhotoDetailController.h
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRPhotoDetailController : UIViewController
- (instancetype)initWithPhotosetID:(NSString *)photosetID;
/** 跟贴数 */
@property (nonatomic, assign) int replyCount;
@end
