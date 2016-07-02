//
//  HRNewsDetailController.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRNewsDetailController.h"

@interface HRNewsDetailController ()<UIWebViewDelegate>

@end

@implementation HRNewsDetailController
- (instancetype)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:webView];
        NSURL *url = [NSURL URLWithString:urlString];
        [webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10]];
        webView.delegate = self;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
