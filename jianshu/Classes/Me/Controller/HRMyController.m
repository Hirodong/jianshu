//
//  HRMyController.m
//  jianshu
//
//  Created by Hiro on 16/5/17.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRMyController.h"
#import "HRDraggableCardContainer.h"
#import "CardView.h"
#import "AFNetworking.h"
#import "HRCardModel.h"
#import "UIImageView+WebCache.h"
#define RGB(r, g, b)	 [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha : 1]
@interface HRMyController ()<HRDraggableCardContainerDelegate, HRDraggableCardContainerDataSource>{
    NSMutableArray *Array;
}
@property (nonatomic, strong) HRDraggableCardContainer *container;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation HRMyController
//-(void)loadView {
//    [self downloadData];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HRGlobalBg;
    
    
    _container = [[HRDraggableCardContainer alloc]init];
    _container.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _container.backgroundColor = [UIColor clearColor];
    _container.dataSource = self;
    _container.delegate = self;
    _container.canDraggableDirection = HRDraggableDirectionLeft | HRDraggableDirectionRight | HRDraggableDirectionUp;
    [self.view addSubview:_container];
    
    for (int i = 0; i < 4; i++) {
        
        UIView *view = [[UIView alloc]init];
        CGFloat size = self.view.frame.size.width / 4;
        view.frame = CGRectMake(size * i, self.view.frame.size.height - 150, size, size);
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        
       
    }
    [self downloadData];
    
    [self loadData];
    
    [_container reloadCardContainer];
   }

- (void)downloadData {
    //刷新表格
    [_container reloadInputViews];
    NSString *path =@"http://v3.wufazhuce.com:8000/api/hp/more/0";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
        
        
        NSArray *dataArray = [dic objectForKey:@"data"];
        NSLog(@"%@",dataArray);
        
        
        //刷新
        [_container reloadInputViews];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        HRLog(@"请求失败：%@",error);
    }];

}
- (void)loadData
{

    _datas = [NSMutableArray array];
    
    for (int i = 0; i < 7; i++) {
        NSDictionary *dict = @{@"image" : [NSString stringWithFormat:@"photo_sample_0%d",i + 1],
                               @"name" : @"YSLDraggableCardContainer Demo"};
        [_datas addObject:dict];
    }
    
    
    
    
}

#pragma mark -- HRDraggableCardContainer DataSource
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index
{
    NSLog(@"----------------");
   
    NSDictionary *dict = _datas[index];
    NSLog(@"%@",dict);
    CardView *view = [[CardView alloc]initWithFrame:CGRectMake(10, 64, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    view.backgroundColor = [UIColor whiteColor];
    view.imageView.image = [UIImage imageNamed:dict[@"image"]];
    view.label.text = [NSString stringWithFormat:@"%@  %ld",dict[@"name"],(long)index];
    return view;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index
{
    return _datas.count;
}

#pragma mark -- YSLDraggableCardContainer Delegate
- (void)cardContainerView:(HRDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(HRDraggableDirection)draggableDirection
{
    if (draggableDirection == HRDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == HRDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == HRDraggableDirectionUp) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
}

- (void)cardContainderView:(HRDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(HRDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio
{
    CardView *view = (CardView *)draggableView;
    
    if (draggableDirection == HRDraggableDirectionDefault) {
        view.selectedView.alpha = 0;
    }
    
    if (draggableDirection == HRDraggableDirectionLeft) {
        view.selectedView.backgroundColor = RGB(215, 104, 91);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (draggableDirection == HRDraggableDirectionRight) {
        view.selectedView.backgroundColor = RGB(114, 209, 142);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (draggableDirection == HRDraggableDirectionUp) {
        view.selectedView.backgroundColor = RGB(66, 172, 225);
        view.selectedView.alpha = heightRatio > 0.8 ? 0.8 : heightRatio;
    }
}

- (void)cardContainerViewDidCompleteAll:(HRDraggableCardContainer *)container;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [container reloadCardContainer];
    });
}

- (void)cardContainerView:(HRDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView
{
    NSLog(@"++ index : %ld",(long)index);
}

@end
