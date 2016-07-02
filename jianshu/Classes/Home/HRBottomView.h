//
//  HRBottomView.h
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *commentCount;
/** 返回按钮Block回调 */
@property (nonatomic, copy) void(^backBtnBlock)();
/** commentCount按钮Block回调 */
@property (nonatomic, copy) void(^commentCountBlock)();
/** write按钮Block回调 */
@property (nonatomic, copy) void(^writeBlock)();
/** 收藏按钮Block回调 */
@property (nonatomic, copy) void(^collectBlock)(UIButton *button);
/** download按钮Block回调 */
@property (nonatomic, copy) void(^downloadBlock)();
@end
