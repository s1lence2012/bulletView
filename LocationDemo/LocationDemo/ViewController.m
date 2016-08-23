//
//  ViewController.m
//  LocationDemo
//
//  Created by 刘凡 on 16/8/4.
//  Copyright © 2016年 刘凡. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>


//弹幕演练
#import "BulletView.h"
#import "BulletManager.h"

@interface ViewController ()
{
    CLLocationManager *locationManager;
}
@property (nonatomic, strong) BulletManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = [UIColor redColor];
    locationManager = [[CLLocationManager alloc] init];
    //定位精度
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 8.0) {
        [locationManager requestAlwaysAuthorization];//后台执行定位
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        locationManager.allowsBackgroundLocationUpdates = YES;
    }
    [locationManager startUpdatingLocation];
    
    
    self.manager = [[BulletManager alloc] init];
    
    __weak typeof(self) myself = self;
    self.manager.generateViewBlock = ^(BulletView *view)
    {
        [myself addBulletView:view];
    };
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blueColor] forState:0];
    [btn setTitle:@"start" forState:0];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blueColor] forState:0];
    [btn setTitle:@"stop" forState:0];
    btn.frame = CGRectMake(200, 100, 100, 40);
    [btn addTarget:self action:@selector(clickStopBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)addBulletView:(BulletView *)view
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    view.frame = CGRectMake(width, 300+ view.trajectory * 40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    
    [view startAnimation];
}

- (void)clickBtn
{
    [self.manager start];
}

- (void)clickStopBtn
{
    [self.manager stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
