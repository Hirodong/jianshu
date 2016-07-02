//
//  HRReadController.m
//  jianshu
//
//  Created by Hiro on 16/5/21.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRReadController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "HRReadListModel.h"
#import "HRReadListCell.h"
#import "HRDetailController.h"
#import "HRDetailReadModel.h"

@interface HRReadController () <SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_adsArray;
    UIView *cycleImageView;
    UITableView *_tableView;
    NSMutableArray *_readListArray;
}

@end

@implementation HRReadController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数组
    _adsArray =[[NSMutableArray alloc]init];
    _readListArray =[[NSMutableArray alloc]init];
    cycleImageView =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.frame.size.width, 200)];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cycleImageView.frame)+5, self.view.frame.size.width, self.view.frame.size.height-cycleImageView.frame.size.height)style:UITableViewStylePlain];
    _tableView.contentInset =UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
    _tableView.delegate=self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"HRReadListCell" bundle:nil] forCellReuseIdentifier:@"readList"];
    
    
//    self.navigationItem.title=@"阅读";
    self.view.backgroundColor =HRGlobalBg;
    //添加导航栏左侧按钮
    self.navigationItem.leftBarButtonItem =[UIBarButtonItem itemWithImage:@"friendsRecommentIcon-click" highImag:nil target:self action:@selector(leftTagButtonClick)];
    //添加导航栏右侧按钮
    self.navigationItem.rightBarButtonItem =[UIBarButtonItem itemWithImage:@"mine-setting-icon" highImag:@"mine-setting-icon-click" target:self action:@selector(rightTagButtonClick)];
    
    [self adsDownloadData];
    [self.view addSubview:cycleImageView];
    [self readListDownloadData];
    
}
-(void)readListDownloadData {
    //刷新表格
    [_tableView reloadData];
    NSString *path =@"http://v3.wufazhuce.com:8000/api/reading/index";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
        
        
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        
       
        NSArray *essayArray = [dataDic objectForKey:@"essay"];
        
        
        NSMutableArray *readArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic  in essayArray) {
            HRReadListModel * model = [[HRReadListModel alloc ]initWithDic:dic];
//            NSLog(@"%@",dic);
            [readArray addObject:model];
            
        }
        
        _readListArray=readArray;
        
        //刷新表格
        [_tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        HRLog(@"请求失败：%@",error);
    }];
}
#pragma mark - tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%ld",_readListArray.count);
    return _readListArray.count;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HRReadListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"readList" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HRReadListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"readList"];
    }
    HRReadListModel *model = _readListArray[indexPath.row];
    cell.readListModel = model;
    return cell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    HRDetailController * detailVC =[[HRDetailController alloc]init];
      HRReadListModel *model = _readListArray[indexPath.row];
    detailVC.content_id = model.content_id;
    
    detailVC.web_url = model.web_url;
 
    [self.navigationController pushViewController:detailVC animated:YES];
    

    
}
-(void)adsDownloadData {
    
        NSString *path = @"http://v3.wufazhuce.com:8000/api/reading/carousel";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            _adsArray= [dic objectForKey:@"data"];
            [self setupCycleImage];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
   
}
//设置轮播图
-(void)setupCycleImage {
    //网络加载
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:cycleImageView.bounds delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder_big"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor =[UIColor orangeColor];
    
    cycleScrollView.imageURLStringsGroup = ({
        NSMutableArray *urlArrayM = [NSMutableArray array];
        
        for (int i = 0; i <_adsArray.count; i++) {
            [urlArrayM addObject:_adsArray[i][@"cover"]];
        }
        urlArrayM;
    });
    [cycleImageView addSubview:cycleScrollView];
    cycleScrollView.delegate= self;
}
-(void)leftTagButtonClick {
   
    HRLogFunc;
}
-(void)rightTagButtonClick {
    HRLogFunc;
    
}


@end
