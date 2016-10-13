//
//  LZImageSwith.h
//  ImageSwitch
//
//  Created by shenzhenshihua on 16/10/12.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZImageSwith : UIView

@property(nonatomic,copy)void(^LZImageSwithBlock)(LZImageSwith*lzImageSwith,NSInteger Number);

+(id)lzImageSwithWithFrame:(CGRect)frame andInstallView:(UIView *)view andImagelinkArr:(NSArray *)array andSwitchtime:(float)seconds andTouchBlock:(void(^)(LZImageSwith * lzImageSwith,NSInteger Number))lzImageBlock;

@end
