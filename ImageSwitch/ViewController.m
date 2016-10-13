//
//  ViewController.m
//  ImageSwitch
//
//  Created by shenzhenshihua on 16/10/12.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import "LZImageSwith.h"

#define Screen_Width     [[UIScreen mainScreen] bounds].size.width
#define Screen_Height    [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * urlArr = @[@"http://pic1.win4000.com/wallpaper/2/57ec7798da967.jpg",@"http://pic1.win4000.com/wallpaper/0/57ec76bf556c1.jpg",@"http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/02/03/ChMkJ1bKxoyIQcgDACv_-0pBvKMAALHmwMrI2gALAAT761.jpg",@"http://pic15.nipic.com/20110620/6465749_141657320145_2.jpg",@"http://img1.qunarzz.com/sight/p0/1412/32/2ece3cb6c002696bc8802c62e96e7986.water.jpg_710x360_8718fa55.jpg"];
    
    UIScrollView * scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.view addSubview:scroller];
    [scroller setContentSize:CGSizeMake(0, 1000)];
    
    [LZImageSwith lzImageSwithWithFrame:CGRectMake(0, 0, Screen_Width, 300) andInstallView:scroller andImagelinkArr:urlArr andSwitchtime:5.0 andTouchBlock:^(LZImageSwith *lzImageSwith, NSInteger Number) {
        
        NSLog(@"%@---%ld",lzImageSwith,(long)Number);
        
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
