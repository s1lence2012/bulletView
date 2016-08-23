//
//  BulletManager.h
//  LocationDemo
//
//  Created by 刘凡 on 16/8/12.
//  Copyright © 2016年 刘凡. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;

@interface BulletManager : NSObject

@property (nonatomic, copy) void(^generateViewBlock)(BulletView *view);

//弹幕开始执行
- (void)start;

//弹幕停止执行
- (void)stop;

@end
