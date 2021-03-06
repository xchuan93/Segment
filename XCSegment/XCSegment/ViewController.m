//
//  ViewController.m
//  XCSegment
//
//  Created by Apple on 2018/10/23.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "UIImage+Color.h"
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define COLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
@interface ViewController (){
     NSMutableDictionary *listDic;
}

@property(nonatomic, strong) OneViewController *oneVC;
@property(nonatomic, strong) TwoViewController *twoVC;
@property(nonatomic, strong) ThreeViewController *threeVC;

@property (nonatomic ,strong) UIViewController *currentVC;

@end

@implementation ViewController

-(OneViewController *)oneVC{
    if (_oneVC == nil) {
        _oneVC = [[OneViewController alloc] init];
    }
    return _oneVC;
}


-(TwoViewController *)twoVC{
    if (_twoVC == nil) {
        _twoVC = [[TwoViewController alloc] init];
    }
    return _twoVC;
}


-(ThreeViewController *)threeVC{
    if (_threeVC == nil) {
        _threeVC = [[ThreeViewController alloc] init];
    }
    return _threeVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listDic = [NSMutableDictionary dictionary];
    
    NSArray * _titles = @[@"消息", @"好友"];
    UISegmentedControl * _segmentedControl = [[UISegmentedControl alloc] initWithItems:_titles];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segmentedControl setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [_segmentedControl setDividerImage:[UIImage imageWithColor:[UIColor whiteColor]] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segmentedControl setDividerImage:[UIImage imageWithColor:[UIColor whiteColor]] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    _segmentedControl.layer.masksToBounds = YES;               //    默认为no，不设置则下面一句无效
    
    _segmentedControl.layer.cornerRadius = 5;               //    设置圆角大小，同UIView
    
    _segmentedControl.layer.borderWidth = 1;
    _segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //修改字体的默认颜色与选中颜色
    //选择后的字体颜色（在NSDictionary中 可以添加背景颜色和字体的背景颜色）
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],
                         NSForegroundColorAttributeName,
                         [UIFont systemFontOfSize:16],
                         NSFontAttributeName,nil];
    
    [ _segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    //默认字体颜色
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xffffff),
                          NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:16],
                          NSFontAttributeName,nil];
    
    [ _segmentedControl setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    
    [_segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _segmentedControl.frame = CGRectMake(100, 20, 200.0, 29.0);
    [self.view addSubview:_segmentedControl];
    self.view.backgroundColor = [UIColor blackColor];
    
    //将默认的页面添加进去
    [self addChildViewController:self.oneVC];
    self.oneVC.view.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 49);
    self.twoVC.view.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 49);
    self.threeVC.view.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 49);
    [self.view addSubview:self.oneVC.view];
    //设置当前显示的VC是哪个
    self.currentVC = _oneVC;
    
    
}

//按钮点击事件
-(void)segmentValueChanged:(UISegmentedControl *)seg{
    NSLog(@"seg.tag-->%ld",seg.selectedSegmentIndex);
    switch (seg.selectedSegmentIndex) {
        case 0:
            [self replaceController:self.currentVC newController:self.oneVC];
            break;
        case 1:
            [self replaceController:self.currentVC newController:self.twoVC];
            break;
        case 2:
            [self replaceController:self.currentVC newController:self.threeVC];
            break;
            
        default:
            break;
    }
    
    //NSArray *sub = self.childViewControllers;
    //NSLog(@"sub-->%@",sub);
}


//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间
     *  options                 动画效果
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            
            self.currentVC = oldController;
            
        }
    }];
}

@end
