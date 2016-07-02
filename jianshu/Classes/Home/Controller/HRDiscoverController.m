//
//  HRDiscoverController.m
//  jianshu
//
//  Created by Hiro on 16/5/17.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRDiscoverController.h"
#import "HRSortView.h"
#import "HRChannelCell.h"
#import "HRChannelModel.h"
#import "HRSortView.h"
#import "HRChannelLabel.h"
#import "UIView+Extension.h"
#define AppColor [UIColor colorWithRed:0.00392 green:0.576 blue:0.871 alpha:1]

static NSString * const reuseID  = @"DDChannelCell";
@interface HRDiscoverController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/**频道数据模型*/
@property (nonatomic,strong) NSArray *channelList;
/**当前要展示的频道*/
@property (nonatomic,strong) NSMutableArray *list_now;//待完善
/**已删除的频道*/
@property (nonatomic,strong) NSMutableArray *list_del;//待完善

/**频道滚动列表*/
@property (nonatomic,strong) UIScrollView *smallScrollView;
/**新闻滚动试图*/
@property (nonatomic,strong) UICollectionView *bigCollectionView;
/**选中频道下划线*/
@property (nonatomic,strong) UIView *underline;
/**频道添加排序按钮*/
@property (nonatomic,strong) UIButton *sortButton;
/**分类排序界面*/
@property (nonatomic,strong) HRSortView *sortView;
@end

@implementation HRDiscoverController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[UINavigationBar appearance] setBarTintColor:AppColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HRGlobalBg;
    //设置导航栏左边按钮
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImag:@"MainTagSubIconClick" target:self action:@selector(leftTagButtonClick)];
    //设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"add" highImag:@"add" target:self action:@selector(rightTagButtonClick)];
    //添加频道滚动视图
    [self.view addSubview:self.smallScrollView];
    //添加新闻滚动试图
    [self.view addSubview:self.bigCollectionView];
    //添加频道排序按钮
//    [self.view addSubview:self.sortButton];
    
}

#pragma mark -UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _list_now.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HRChannelCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    HRChannelModel *channel = _list_now[indexPath.row];
    cell.urlString = channel.urlString;
    //加入响应这链，利用NavController进行push等操作
    [self addChildViewController:(UIViewController *)cell.newsTVC];
    return cell;
    
}
#pragma mark - UICollectionViewDelegate
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat value = scrollView.contentOffset.x/scrollView.frame.size.width;
    if (value<0) {
        return;//防止最左侧下划线位置偏移
    }
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex+1;
    if (rightIndex>=[self getLabelArrayFromSubviews].count) { // 防止滑到最右，再滑，数组越界崩溃

        rightIndex = [self getLabelArrayFromSubviews].count - 1;
    }
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft  = 1 - scaleRight;
    HRChannelLabel *labelLeft  = [self getLabelArrayFromSubviews][leftIndex];
    HRChannelLabel *labelRight = [self getLabelArrayFromSubviews][rightIndex];
    
    labelLeft.scale  = scaleLeft;
    labelRight.scale = scaleRight;
    // 点击label会调用此方法1次，会导致【scrollViewDidEndScrollingAnimation】方法中的动画失效，这时直接return。
    if (scaleLeft == 1 && scaleRight == 0) {
        return;
    }
    // 下划线动态跟随滚动
    _underline.centerX = labelLeft.centerX   + (labelRight.centerX   - labelLeft.centerX)   * scaleRight;
    _underline.width   = labelLeft.textWidth + (labelRight.textWidth - labelLeft.textWidth) * scaleRight;
    

    

}




-(void)leftTagButtonClick {
    HRLogFunc;
}
                                            
                                             
                                             
-(void)rightTagButtonClick {
       HRLogFunc;
//    UIViewController *vc = [[UIViewController alloc]init];
//    vc.view.backgroundColor =[UIColor redColor];
//    [self.navigationController pushViewController:vc animated:YES];
    [self sortButtonClick];
   }

/** 手指滑动BigCollectionView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.bigCollectionView]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}
/** 手指点击smallScrollView */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigCollectionView.width;
    // 滚动标题栏到中间位置
    HRChannelLabel *titleLable = [self getLabelArrayFromSubviews][index];
    CGFloat offsetx   =  titleLable.center.x - _smallScrollView.width * 0.5;
    CGFloat offsetMax = _smallScrollView.contentSize.width - _smallScrollView.width;
    // 在最左和最右时，标签没必要滚动到中间位置。
    if (offsetx < 0)		 {offsetx = 0;}
    if (offsetx > offsetMax) {offsetx = offsetMax;}
    [_smallScrollView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
    
    // 先把之前着色的去色：（快速滑动会导致有些文字颜色深浅不一，点击label会导致之前的标题不变回黑色）
    for (HRChannelLabel *label in [self getLabelArrayFromSubviews]) {
        label.textColor = [UIColor blackColor];
    }
    // 下划线滚动并着色
    [UIView animateWithDuration:0.5 animations:^{
        _underline.width = titleLable.textWidth;
        _underline.centerX = titleLable.centerX;
        titleLable.textColor = AppColor;
    }];
}





#pragma mark - getter
- (NSArray *)channelList
{
    if (_channelList == nil) {
        _channelList = [HRChannelModel channels];
    }
    return _channelList;
}

- (UIScrollView *)smallScrollView
{
    if (_smallScrollView == nil) {
        _smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScrW, 44)];
        _smallScrollView.backgroundColor = [UIColor whiteColor];
        _smallScrollView.showsHorizontalScrollIndicator = NO;
        // 设置频道
        _list_now = self.channelList.mutableCopy;
        [self setupChannelLabel];
        // 设置下划线
        [_smallScrollView addSubview:({
            HRChannelLabel *firstLabel = [self getLabelArrayFromSubviews][0];
            firstLabel.textColor = AppColor;
            // smallScrollView高度44，取下面4个点的高度为下划线的高度。
            _underline = [[UIView alloc] initWithFrame:CGRectMake(0, 40, firstLabel.textWidth, 4)];
            _underline.centerX = firstLabel.centerX;
            _underline.backgroundColor = AppColor;
            _underline;
        })];
    }
    return _smallScrollView;
}

- (UICollectionView *)bigCollectionView
{
    if (_bigCollectionView == nil) {
        // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
        CGFloat h = ScrH - 64 - self.smallScrollView.height ;
        CGRect frame = CGRectMake(0, self.smallScrollView.maxY, ScrW, h);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _bigCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _bigCollectionView.backgroundColor = [UIColor whiteColor];
        _bigCollectionView.delegate = self;
        
        _bigCollectionView.dataSource = self;
        [_bigCollectionView registerClass:[HRChannelCell class] forCellWithReuseIdentifier:reuseID];
        
        // 设置cell的大小和细节
        flowLayout.itemSize = _bigCollectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _bigCollectionView.pagingEnabled = YES;
        _bigCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _bigCollectionView;
}

- (UIButton *)sortButton
{
    if (_sortButton == nil) {
        _sortButton = [[UIButton alloc] initWithFrame:CGRectMake(ScrW-44, 64, 44, 44)];
        [_sortButton setImage:[UIImage imageNamed:@"ks_home_plus"] forState:UIControlStateNormal];
        _sortButton.backgroundColor = [UIColor whiteColor];
        _sortButton.layer.shadowColor = [UIColor whiteColor].CGColor;
        _sortButton.layer.shadowOpacity = 1;
        _sortButton.layer.shadowRadius = 5;
        _sortButton.layer.shadowOffset = CGSizeMake(-10, 0);
        
        [_sortButton addTarget:self action:@selector(sortButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton;
}

- (HRSortView *)sortView
{
    if (_sortView == nil) {
        _sortView = [[HRSortView alloc] initWithFrame:CGRectMake(_smallScrollView.x,
         _smallScrollView.y,ScrW,_smallScrollView.height + _bigCollectionView.height)
        channelList:_list_now];
        __block typeof(self) weakSelf = self;
        // 箭头点击回调
        _sortView.arrowBtnClickBlock = ^{
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.sortView.y = -ScrH;
                weakSelf.tabBarController.tabBar.y = ScrH - 49; // 这么写防止用户多次点击label和排序按钮，造成tabbar错乱
            } completion:^(BOOL finished) {
                [weakSelf.sortView removeFromSuperview];
            }];
        };
        // 排序完成回调
        _sortView.sortCompletedBlock = ^(NSMutableArray *channelList){
            weakSelf.list_now = channelList;
            // 去除旧的排序
            for (HRChannelLabel *label in [weakSelf getLabelArrayFromSubviews]) {
                [label removeFromSuperview];
            }
            // 加入新的排序
            [weakSelf setupChannelLabel];
            // 滚到第一个频道！offset、下划线、着色，都去第一个. 直接模拟第一个label被点击：
            HRChannelLabel *label = [weakSelf getLabelArrayFromSubviews][0];
            UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
            [tap setValue:label forKey:@"view"];
            [weakSelf labelClick:tap];
        };
        // cell按钮点击回调
        _sortView.cellButtonClick = ^(UIButton *button){
            // 模拟label被点击
            for (HRChannelLabel *label in [weakSelf getLabelArrayFromSubviews]) {
                if ([label.text isEqualToString:button.titleLabel.text]) {
                    weakSelf.sortView.arrowBtnClickBlock(); // 关闭sortView
                    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
                    [tap setValue:label forKey:@"view"];
                    [weakSelf labelClick:tap];
                }
            }
        };
    }
    return _sortView;
}


#pragma mark -
/** 设置频道标题 */
- (void)setupChannelLabel
{
    CGFloat margin = 20.0;
    CGFloat x = 8;
    CGFloat h = _smallScrollView.bounds.size.height;
    int i = 0;
    for (HRChannelModel *channel in _list_now) {
       HRChannelLabel *label = [HRChannelLabel channelLabelWithTitle:channel.tname];
        label.frame = CGRectMake(x, 0, label.width + margin, h);
        [_smallScrollView addSubview:label];
        
        x += label.bounds.size.width;
        label.tag = i++;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    _smallScrollView.contentSize = CGSizeMake(x + margin + self.sortButton.width, 0);
}

/** 频道Label点击事件 */
- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    HRChannelLabel *label = (HRChannelLabel *)recognizer.view;
    // 点击label后，让bigCollectionView滚到对应位置。
    [_bigCollectionView setContentOffset:CGPointMake(label.tag * _bigCollectionView.frame.size.width, 0)];
    // 重新调用一下滚定停止方法，让label的着色和下划线到正确的位置。
    [self scrollViewDidEndScrollingAnimation:self.bigCollectionView];
}

/** 获取smallScrollView中所有的DDChannelLabel，合成一个数组，因为smallScrollView.subViews中有其他非Label元素 */
- (NSArray *)getLabelArrayFromSubviews
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (HRChannelLabel *label in _smallScrollView.subviews) {
        if ([label isKindOfClass:[HRChannelLabel class]]) {
            [arrayM addObject:label];
        }
    }
    return arrayM.copy;
}

/** 排序按钮点击事件 */
- (void)sortButtonClick
{
    [self.view addSubview:self.sortView];
    _sortView.y = -ScrH;
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.y += 49;
        _sortView.y = _smallScrollView.y;
    }];
}


                                            
                                             
                                             
@end
