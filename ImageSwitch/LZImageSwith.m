//
//  LZImageSwith.m
//  ImageSwitch
//
//  Created by shenzhenshihua on 16/10/12.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "LZImageSwith.h"
#import "UIImageView+WebCache.h"
#define LZImageBaseTag  99999

@interface LZImageSwith ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSArray *urlArray;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,copy)NSString *times;

@property(nonatomic)NSInteger tempNum;

@property(nonatomic,strong)NSTimer * subTime;


@end

@implementation LZImageSwith


+(id)lzImageSwithWithFrame:(CGRect)frame andInstallView:(UIView *)view andImagelinkArr:(NSArray *)array andSwitchtime:(float)seconds andTouchBlock:(void(^)(LZImageSwith * lzImageSwith,NSInteger Number))lzImageBlock{
    LZImageSwith * lzImageSwith = [[LZImageSwith alloc] initWithFrame:frame];
    lzImageSwith.scrollView = [lzImageSwith createScrollViewWithUrlArr:array];
    [lzImageSwith createPageControl];
    [lzImageSwith createTime:seconds];
    [lzImageSwith createSubtime];
    
    [view addSubview:lzImageSwith];
    
    lzImageSwith.LZImageSwithBlock = lzImageBlock;
    

    return lzImageSwith;
}

- (NSMutableArray *)chickImageLinkwithArr:(NSArray *)array{
    NSMutableArray * muArr = [[NSMutableArray alloc] init];
    for (NSString * string in array) {
        if ([string isKindOfClass:[NSURL class]]) {
            [muArr addObject:string];
        }else{
            [muArr addObject:[NSURL URLWithString:string]];
        }
        
    }
    return muArr;
}

- (UIScrollView *)createScrollViewWithUrlArr:(NSArray *)urlArr{
    self.urlArray = [self chickImageLinkwithArr:urlArr];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(self.bounds.size.width*(urlArr.count+2), 0)];
    
    for (int i = 0; i < _urlArray.count+2; i++) {
        UIImageView * ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width*i, 0, self.bounds.size.width, self.bounds.size.height)];
        ImageView.tag = LZImageBaseTag+i;
        if (i==0) {
            [ImageView sd_setImageWithURL:_urlArray[self.urlArray.count-1]];
        }else if (i==_urlArray.count+1){
            [ImageView sd_setImageWithURL:_urlArray[0]];
        }else{
            [ImageView sd_setImageWithURL:_urlArray[i-1]];
        }
        
        [scrollView addSubview:ImageView];
        ImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
        [ImageView addGestureRecognizer:tap];
        
    }
    [scrollView setContentOffset:CGPointMake(0,0)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    

    return scrollView;
}

- (void)imageTapAction:(UITapGestureRecognizer *)tap{
    NSInteger num = tap.view.tag-LZImageBaseTag;
    NSInteger tureNum;
    if (num==0) {
        tureNum = self.urlArray.count-1;
    }else if (num==self.urlArray.count+1){
        tureNum = 0;
    }else{
        tureNum = num-1;
    }
   
    //发送block事件
    
    NSLog(@"%ld",(long)tureNum);
    
    if (self.LZImageSwithBlock) {
        self.LZImageSwithBlock(self,tureNum);
    }
    
    
    
    
    
}


- (NSTimer *)createTime:(CGFloat)flort{

    self.times = [NSString stringWithFormat:@"%f",flort+1];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:flort target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    self.timer.fireDate = [NSDate distantPast];
    
    return timer;
}


- (void)timerAction:(NSTimer *)timer{

    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), 0) animated:YES];

}

#pragma mark scrollViewdelegate
//动的过程
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = scrollView.bounds.size.width;
    NSInteger count = self.urlArray.count;
    CGFloat X = scrollView.contentOffset.x;
    if (X<width*(count+1)+20 && X>width*(count+1)-20) {
        [self.scrollView setContentOffset:CGPointMake(scrollView.frame.size.width,0) animated:NO];
        self.pageControl.currentPage = 0;
    }else if (X>-20 && X<20){
        [self.scrollView setContentOffset:CGPointMake(scrollView.frame.size.width*self.urlArray.count,0) animated:NO];
        self.pageControl.currentPage = self.urlArray.count;
    }

//    NSLog(@"%f",X);
    

}
//将要推动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.timer.fireDate = [NSDate distantFuture];
    
}

- (void)createSubtime{
    _subTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(subtimeAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_subTime forMode:NSRunLoopCommonModes];
    self.subTime.fireDate = [NSDate distantFuture];

    
}

- (void)subtimeAction{
    _tempNum--;
    NSLog(@"%ld",(long)_tempNum);
    if (_tempNum==0) {
        self.timer.fireDate = [NSDate distantPast];
        self.subTime.fireDate = [NSDate distantFuture];
    }

}


// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging  -  End of Scrolling.");

    self.subTime.fireDate = [NSDate distantPast];
    self.tempNum = self.times.integerValue;

}

//减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [self aboutPage:scrollView];
    
}

//手动滑动时减速完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self aboutPage:scrollView];

}

- (void)aboutPage:(UIScrollView *)scrollView {
    NSLog(@"%@",self.timer.fireDate);

    NSInteger page = scrollView.contentOffset.x/scrollView.bounds.size.width;
    NSLog(@"%ld",(long)page);
    if (page==0) {
        self.pageControl.currentPage = self.urlArray.count-1;
    }else if (page==self.urlArray.count+1){
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = page-1;
    }

}
- (UIPageControl *)createPageControl{
    UIPageControl * pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20)];
//    pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl = pageControl;

    [self addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.urlArray.count;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    return pageControl;
}


- (void)dealloc{
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer=nil;
    }
    
    if ([self.subTime isValid]) {
        [self.subTime invalidate];
        self.subTime=nil;
    }
    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
