//
//  HRPhotoDetailController.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRPhotoDetailController.h"
#import "HRPhotoModel.h"
#import "HRPhotoDetailModel.h"
#import "HRPhotoScrollView.h"
#import "HRPhotoDescView.h"
#import "HRBottomView.h"

#import "JZNavigationExtension.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "JT3DScrollView.h"
#import "MBProgressHUD.h"
@interface HRPhotoDetailController () <UIScrollViewDelegate>
@property (nonatomic, strong) HRPhotoModel *photoModel;
@property (nonatomic, assign) NSInteger currentPage;
// UI
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) JT3DScrollView *imageScrollView;
@property (nonatomic, strong) HRPhotoDescView *photoDescView;
@property (nonatomic, strong) HRBottomView *bottomView;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) BOOL isDisappear;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation HRPhotoDetailController
- (instancetype)initWithPhotosetID:(NSString *)photosetID
{
    self = [super init];
    if (self) {
        [HRPhotoModel photoModelWithPhotosetID:(NSString *)photosetID complection:^(HRPhotoModel *photoModel) {
            self.photoModel = photoModel;
        }];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.174 green:0.174 blue:0.164 alpha:1.000];
    self.navigationController.fullScreenInteractivePopGestureRecognizer = YES;
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.bottomView];

}
/** 模型初始化后，开始搭建需要网络加载后才显示的UI。 */
- (void)setPhotoModel:(HRPhotoModel *)photoModel
{
    _photoModel = photoModel;
    [self.view insertSubview:self.imageScrollView belowSubview:self.backButton];
    //
    [self addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setValue:@(_imageScrollView.currentPage) forKey:@"currentPage"];
}


#pragma mark - KVO
static int temp = -1;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // 获取新旧索引
    //	int oldIndex = [change[@"old"] intValue]; // 暂时没用到，想用来写图片大小恢复的。
    int newIndex = [change[@"new"] intValue];
    
    // 防止玩命赋值，只有发生变化了才进行下一步操作。
    if (temp == newIndex) {
        return;
    } else {
        temp = newIndex;
        // 记录一下，供别处使用
        _currentIndex = newIndex;
    }
    
    // 如果已经消失了，就不展现描述文本了。
    if (_isDisappear == YES) {return;}
    HRPhotoDetailModel *detailModel = _photoModel.photos[newIndex];
    // 先remove
    [_photoDescView removeFromSuperview];
    // 再加入
    _photoDescView = [[HRPhotoDescView alloc] initWithTitle:_photoModel.setname
                                                       desc:detailModel.note
                                                      index:newIndex
                                                 totalCount:_photoModel.photos.count];
    [self.view insertSubview:_photoDescView belowSubview:self.bottomView];
}


#pragma mark - getter
- (UIButton *)backButton
{
    if (_backButton == nil) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 25, 40, 40)];
        [_backButton setImage:[UIImage imageNamed:@"imageset_back_live"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"imageset_back"] forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}


- (JT3DScrollView *)imageScrollView
{
    if (_imageScrollView == nil) {
        // 设置大ScrollView  40:适当提高下imageView的高度，否则上面显得太空洞
        _imageScrollView = [[JT3DScrollView alloc] initWithFrame:CGRectMake(0, 0, ScrW, ScrH - 40)];
        _imageScrollView.contentSize = CGSizeMake(_photoModel.photos.count * ScrW, ScrH - 40);
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.effect = arc4random_uniform(3) + 1; // 切换的动画效果,随机枚举中的1，2，3三种效果。
        _imageScrollView.clipsToBounds = YES;
        _imageScrollView.delegate = self;
        
        // 设置小ScrollView（装载imageView的scrollView）
        for (int i = 0; i < self.photoModel.photos.count; i++) {
            HRPhotoDetailModel *detailModel = self.photoModel.photos[i];
            HRPhotoScrollView *photoScrollView = [[HRPhotoScrollView alloc] initWithFrame:CGRectMake(ScrW * i, 0, ScrW, ScrH - 40) urlString:detailModel.imgurl];
            // singleTapBlock回调：让所有UI，除了图片，全部消失
            __weak typeof(self) weakSelf = self;
            photoScrollView.singleTapBlock = ^{
                NSLog(@"tap~");
                // 如果已经消失，就出现
                if (weakSelf.isDisappear == YES) {
                    [weakSelf.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![obj isKindOfClass:[JT3DScrollView class]]) {
                            [UIView animateWithDuration:0.5 animations:^{
                                obj.alpha = 1;
                                weakSelf.view.backgroundColor = [UIColor colorWithRed:0.174 green:0.174 blue:0.164 alpha:1.000];
                            } completion:^(BOOL finished) {
                                obj.userInteractionEnabled = YES;
                            }];
                        }
                    }];
                    weakSelf.isDisappear = NO;
                } else { // 消失
                    [weakSelf.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![obj isKindOfClass:[JT3DScrollView class]]) {
                            [UIView animateWithDuration:0.5 animations:^{
                                obj.alpha = 0;
                                weakSelf.view.backgroundColor = [UIColor blackColor];
                            } completion:^(BOOL finished) {
                                obj.userInteractionEnabled = NO;
                            }];
                        }
                    }];
                    weakSelf.isDisappear = YES;
                }
                
            };
            [_imageScrollView addSubview:photoScrollView];
        }
    }
    return _imageScrollView;
}

- (HRBottomView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"HRBottomView" owner:nil options:nil].lastObject;
        _bottomView.frame = CGRectMake(0, ScrH - 40, ScrW, 40);
        
        [_bottomView.commentCount setTitle:[NSString stringWithFormat:@" %zd", self.replyCount] forState:UIControlStateNormal];
        
        __weak typeof(self) weakSelf = self;
        // 返回回调
        _bottomView.backBtnBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        // 跟帖数回调
        _bottomView.commentCountBlock = ^{
            NSLog(@"跟帖数");
        };
        
        // 评论回调
        _bottomView.writeBlock = ^{
            NSLog(@"写评论");
        };
        
        //收藏回调
        _bottomView.collectBlock = ^(UIButton *button){
            HRLog(@"收藏 button.selected = %zd", button.selected);
            button.selected = !button.selected;
            if (button.selected) {
                weakSelf.hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                weakSelf.hud.mode = MBProgressHUDModeText;
                weakSelf.hud.label.text = @"收藏成功！";
                [weakSelf.hud hideAnimated:YES afterDelay:1];
            } else {
                weakSelf.hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                weakSelf.hud.mode = MBProgressHUDModeText;
                weakSelf.hud.label.text = @"取消收藏！";
                [weakSelf.hud hideAnimated:YES afterDelay:1];
            }
        };
        
        // 保存到相册回调
        _bottomView.downloadBlock = ^{
            weakSelf.hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            // 先获取图片
            HRPhotoScrollView *scrollView = weakSelf.imageScrollView.subviews[weakSelf.currentIndex];
            UIImageWriteToSavedPhotosAlbum(scrollView.imageView.image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        };
        
    }
    return _bottomView;
}

#pragma mark -
- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 成功保存图片到相册中, 必须调用此方法, 否则会报参数越界错误
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        HRLog(@"error");
        _hud.mode = MBProgressHUDModeText;
        _hud.label.text = @"图片已保存至相册！";
        [_hud hideAnimated:YES afterDelay:1];
    } else {
        _hud.mode = MBProgressHUDModeText;
        _hud.label.text = @"保存失败！";
        [_hud hideAnimated:YES afterDelay:1];
    }
}

- (void)dealloc
{
    temp = -1;
    [self removeObserver:self forKeyPath:@"currentPage"];
}


@end
