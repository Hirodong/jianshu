//
//  HRNewsTVC.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRNewsTVC.h"
#import "HRNewsModel.h"
#import "HRNewsCell.h"
#import "HRNewsCache.h"
#import "HRNewsDetailController.h"
#import "HRPhotoDetailController.h"
#import "MJRefresh.h"
#import "JZNavigationExtension.h"
#import "UIView+Extension.h"
@interface HRNewsTVC ()
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation HRNewsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载菊花
    self.tableView.contentInset =UIEdgeInsetsMake(0, 0, 50, 0);
    __weak typeof (self) weakSelf =self;
    [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

    // 去除刷新前的横线
    UIView*view = [UIView new];
    view.backgroundColor= [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    //进入后台通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)setUrlString:(NSString *)urlString {
    _urlString =urlString;
    [HRNewsModel newsDataListWithUrlString:urlString complection:^(NSMutableArray *array) {
        _dataList=array;
        [self.tableView reloadData];//刷新表格
    }];
    if ([[HRNewsCache sharedInstance]containsObject:urlString]) {
        return;
    }else {
        [[HRNewsCache sharedInstance] addObject:urlString];
        [self.tableView.mj_header beginRefreshing];
    }
}
#pragma mark -下拉刷新
-(void)refreshData {
    //获取tid拼接urlString
    NSString *tid = [self.urlString substringWithRange:NSMakeRange(17, 14)];
    NSString *urlString = [NSString stringWithFormat:@"article/headline/%@/0-20.html" ,tid];
    [HRNewsModel newsDataListWithUrlString:urlString complection:^(NSMutableArray *array) {
        self.dataList =array;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    }];
}
#pragma mark-上拉加载
-(void)loadMoreData {
    // 获取tid来拼接urlString
    NSString *tid = [self.urlString substringWithRange:NSMakeRange(17, 14)];
    // 让前面的数字是20的整数倍，多出来的 减去 模剩下的，正好是20的整数倍。
    NSString *urlString = [NSString stringWithFormat:@"article/headline/%@/%zd-20.html" ,tid, self.dataList.count - self.dataList.count % 20];
    [HRNewsModel newsDataListWithUrlString:urlString complection:^(NSArray *array) {
        [self.dataList addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];

}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HRNewsModel *newsModel = self.dataList[indexPath.row];
    HRNewsCell *cell =[tableView dequeueReusableCellWithIdentifier:[HRNewsCell cellReuseID:newsModel] forIndexPath:indexPath];
    cell.newsModel = newsModel;
    [self setupCycleImageClickWithCell:cell newsModel:newsModel];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRNewsModel *newsModel = self.dataList[indexPath.row];
    return [HRNewsCell cellForHeight:newsModel];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HRNewsCell  *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor =[UIColor lightGrayColor];
    [[HRNewsCache sharedInstance]addObject:cell.titleLabel.text];
    
    HRNewsModel *newsModel = self.dataList[indexPath.row];
    if (newsModel.photosetID) {
        HRPhotoDetailController *photoVC = [[HRPhotoDetailController alloc]initWithPhotosetID:newsModel.photosetID];
        photoVC.replyCount = newsModel.replyCount;
        photoVC.wantsNavigationBarVisible = NO;
        photoVC.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:photoVC animated:YES];
        
    }else {
        HRNewsDetailController *NewsDetailC = [[HRNewsDetailController alloc]initWithUrlString:newsModel.url];
        NewsDetailC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:NewsDetailC animated:YES];
    }
}
- (void)enterBackGround
{
    [[HRNewsCache sharedInstance] removeAllObjects];
}
/** 轮播点击事件 */
- (void)setupCycleImageClickWithCell:(HRNewsCell *)cell newsModel:(HRNewsModel *)newsModel{
    cell.cycleImageClickBlock = ^(NSInteger idx){
        // 进入后是图片详情："tag": "photoset", "url": "00AJ0003|591287"
        // 进入后是新闻详情："tag": "doc",      "url": "BH7H123N00094P0U"
        NSString *tag = newsModel.ads[idx][@"tag"];
        NSString *url = newsModel.ads[idx][@"url"];
        if ([tag isEqualToString:@"photoset"]) {
            HRPhotoDetailController *photoVC = [[HRPhotoDetailController alloc] initWithPhotosetID:url];
            photoVC.replyCount = newsModel.replyCount;
            photoVC.wantsNavigationBarVisible = NO;
            photoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:photoVC animated:YES];
            
        }else {
            // 16位 + ".html" = 21位，将newsModel.url总长度-21，获取直到/及前面的所有字符
            NSString *str = [newsModel.url substringToIndex:newsModel.url.length - 21];
            NSString *finalStr = [NSString stringWithFormat:@"%@%@.html", str, url]; // 拼接完成
            HRNewsDetailController *NewsDetailC = [[HRNewsDetailController alloc] initWithUrlString:finalStr];
            NewsDetailC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:NewsDetailC animated:YES];
        }
    };
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
