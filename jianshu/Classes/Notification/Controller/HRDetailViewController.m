//
//  HRDetailViewController.m
//  jianshu
//
//  Created by Hiro on 16/5/19.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRDetailViewController.h"
#import "UIViewExt.h"
@interface HRDetailViewController ()

@end

@implementation HRDetailViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 140)];
    _videoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_videoView];
}

- (void)addObserver
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:kHTPlayerFinishedPlayNotificationKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:)  name:kHTPlayerFullScreenBtnNotificationKey object:nil];
}

- (void)reloadData
{
    [self addObserver];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_htPlayer) {
        [self toDetial];
    }else{
        [self startPlayVideo:nil];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)videoDidFinished:(NSNotification *)notice{
    
    if (_htPlayer.screenType == UIHTPlayerSizeFullScreenType){
        
        [self toCell];//先变回cell
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _htPlayer.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_htPlayer removeFromSuperview];
        [self releaseWMPlayer];
    }];
    
}

-(void)fullScreenBtnClick:(NSNotification *)notice{
    
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self toCell];
    }
}

-(void)toCell{
    
    [_htPlayer toDetailScreen:_videoView];
}

-(void)toDetial{
    
    [_htPlayer toDetailScreen:_videoView];
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [_htPlayer toFullScreenWithInterfaceOrientation:interfaceOrientation];
}

//开始播放
-(void)startPlayVideo:(UIButton *)sender{
    
    if (_htPlayer) {
        [_htPlayer removeFromSuperview];
        [_htPlayer setVideoURLStr:_model.mp4_url];
        
    }else{
        _htPlayer = [[HRHTPlayer alloc]initWithFrame:self.videoView.bounds videoURLStr:_model.mp4_url];
    }
    
    _htPlayer.screenType = UIHTPlayerSizeDetailScreenType;
    
    [_htPlayer setPlayTitle:_model.title];
    
    [self.videoView addSubview:_htPlayer];
    [self.videoView bringSubviewToFront:_htPlayer];
    
    if (_htPlayer.screenType == UIHTPlayerSizeSmallScreenType) {
        [_htPlayer reductionWithInterfaceOrientation:self.videoView];
    }
}

-(void)releaseWMPlayer{
    
    [_htPlayer releaseWMPlayer];
    _htPlayer = nil;
}

-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [self releaseWMPlayer];
}
@end
