//
//  BulletManager.m
//  LocationDemo
//
//  Created by 刘凡 on 16/8/12.
//  Copyright © 2016年 刘凡. All rights reserved.
//

//NSObject Model类 管理初始化数据 使用bulletView，将bulletView放入视图数组中

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager()

//弹幕的数据来源
@property (nonatomic, strong) NSMutableArray *dataSource;
//弹幕使用过程中的数组变量
@property (nonatomic, strong) NSMutableArray *bulletCommets;
//存储弹幕view的数组变量
@property (nonatomic, strong) NSMutableArray *bulletViews;

//控制暂停
@property (nonatomic, assign) BOOL bStopAnimation;
@end

@implementation BulletManager

- (instancetype)init
{
    if (self = [super init]) {
        self.bStopAnimation = YES;
    }
    return self;
}

- (void)start
{
    if (!self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = NO;
    [self.bulletCommets removeAllObjects];
    [self.bulletCommets addObjectsFromArray:self.dataSource];
    
    [self initBulletComment];
}

- (void)stop
{
    if (self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

//初始化弹幕，随机分配弹幕轨迹
- (void)initBulletComment{
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0), @(1), @(2)]];
    for (int i = 0; i < 3; i++) {
        if (self.bulletCommets.count > 0) {
        //通过随机数获取到弹幕的轨迹
        NSInteger index = arc4random()%trajectorys.count;
        int trajectory = [[trajectorys objectAtIndex:index] intValue];
        [trajectorys removeObjectAtIndex:index];
        
        //从弹幕数组中逐一取出弹幕数据
        NSString *comment = [self.bulletCommets firstObject];
        [self.bulletCommets removeObjectAtIndex:0];
        
        //创建弹幕View
        [self createBulletView:comment trajectory:trajectory];
        }
    }
}

- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory
{
    if (self.bStopAnimation) {
        return;
    }
    
    BulletView *view = [[BulletView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof (view) weakview = view;
    __weak typeof(self) myself = self;
    NSLog(@"comment == %@", comment);
    view.moveStatusBlock = ^(MoveStatus status){
        if (self.bStopAnimation) {
            return ;
        }
        switch (status) {
            case Start:
                NSLog(@"countself == %ld", myself.bulletViews.count);
                NSLog(@"countweakself = %ld", self.bulletViews.count);
                //弹幕开始进入屏幕，将view加入弹幕管理的变量中bulletviews
                [myself.bulletViews addObject:weakview];
                break;
            case Enter:{
                //弹幕完全进入屏幕，判断是否还有其他内容，如果有则在该弹幕中创建一个弹幕
                NSString *comment = [myself nextComment];
                if (comment) {//如果还有留言 递归该方法创建一个view
                    [myself createBulletView:comment trajectory:trajectory];
                }
                break;
            }
            case End:{
                //弹幕飞出屏幕后从bulletviews中删除，释放资源
                if ([myself.bulletViews containsObject:weakview]) {
                    [weakview stopAnimation];
                    [myself.bulletViews removeObject:weakview];
                }
                
                if (myself.bulletViews.count == 0) {
                    //说明屏幕上已经没有弹幕了，开始循环滚动
                    self.bStopAnimation = YES;
                    [myself start];
                }
                break;
            }
            default:
                break;
        }
//        
//      //移除屏幕后销毁弹幕避过释放资源
//        [weakview stopAnimation];
//        [myself.bulletViews removeObject:weakview];
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

- (NSString *)nextComment
{
    if (self.bulletCommets.count == 0) {
        return nil;
    }
    NSString *comment =  [self.bulletCommets firstObject];
    if (comment) {
        [self.bulletCommets removeObjectAtIndex:0];
    }
    return comment;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1~~~~~~", @"弹幕2！@#！@#@！#12", @"弹幕312312312312",@"弹幕1~~~~~~", @"弹幕2！@#！@#@！#12", @"弹幕312312312312",@"弹幕1~~~~~~", @"弹幕2！@#！@#@！#12", @"弹幕312312312312"]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletCommets
{
    if (!_bulletCommets) {
        _bulletCommets = [NSMutableArray array];
    }
    return _bulletCommets;
}

- (NSMutableArray *)bulletViews
{
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end
