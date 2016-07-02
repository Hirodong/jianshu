//
//  HRDetailController.m
//  jianshu
//
//  Created by Hiro on 16/5/23.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRDetailController.h"
#import "AFNetworking.h"
#import "HRDetailReadModel.h"
#import "HRDetailReadCell.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface HRDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *_detailArray;
}
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) BOOL isDisappear;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation HRDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    _detailArray =[[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds ];
    _tableView.contentInset =UIEdgeInsetsMake(0, 0, 50, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight =44.0;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"HRDetailReadCell" bundle:nil] forCellReuseIdentifier:@"detail"];
    [self downLoadData];
    
}

-(void)downLoadData {
    //HUD提示
    [MBProgressHUD showMessageWithRefresh:@"文章准备中" toView:self.view delay:1.0];

    //刷新表格
    [_tableView reloadData];
    NSString *path =[NSString stringWithFormat:@"http://v3.wufazhuce.com:8000/api/essay/%@",self.content_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
        
        
        NSDictionary *dataDic = [dic objectForKey:@"data"];


        NSMutableArray *Array = [[NSMutableArray alloc]init];
        HRDetailReadModel *model  = [[HRDetailReadModel alloc]initWithDic:dataDic];
        model.web_url = self.web_url;
        [Array addObject:model];
        _detailArray =Array;

     
        //刷新表格
        [_tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        HRLog(@"请求失败：%@",error);
    }];

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return _detailArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HRDetailReadCell *cell =[tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HRDetailReadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detail"];
    }
    HRDetailReadModel *model = _detailArray[indexPath.row];
    cell.detailModel = model;
    
    return cell;

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HRDetailReadModel *model = _detailArray[indexPath.row];
    return model.cellHeight;
    
    
}
@end
