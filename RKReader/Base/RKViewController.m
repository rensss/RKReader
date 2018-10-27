//
//  RKViewController.m
//  RKReader
//
//  Created by MBP on 2018/9/3.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKViewController.h"
#import "AppDelegate.h"

@interface RKViewController ()

@end

@implementation RKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc {
    RKLog(@"---> %@ 销毁",[self class])
}

#pragma mark - 函数
/**
 设置是否强制转屏
 @param allowRotation 是否强制横屏 yes 横屏 no 竖屏
 */
- (void)setOrientation:(BOOL)allowRotation {
    
    // 返回手势
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.navigationController.interactivePopGestureRecognizer.enabled = !allowRotation;
    //    }
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (allowRotation) {//允许转成横屏
        //调用横屏代码
        appDelegate.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
        [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    }else {//关闭横屏仅允许竖屏
        //切换到竖屏
        appDelegate.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
        [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    }
}

#pragma mark - 重写系统方法
- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated {
    
    if(viewController == self){
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        
        //系统相册继承自 UINavigationController 这个不能隐藏 所有就直接return
        if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
            return;
        }
        
        //不在本页时，显示真正的navbar
        [navigationController setNavigationBarHidden:NO animated:YES];
        //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
        //之前将这段代码放在viewDidDisappear和dealloc中，这两种情况可能已经被pop了，self.navigationController为nil，这里采用手动持有navigationController的引用来解决
        if(navigationController.delegate == self){
            //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
            navigationController.delegate = nil;
        }
    }
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
