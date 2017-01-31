//
//  RootTabBarViewController.m
//  enuoNew
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RootTabBarViewController.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatViewController];

}

- (void)creatViewController{
    OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc]init];
    UINavigationController *orderDetailNC = [[UINavigationController alloc]initWithRootViewController:orderDetailVC];
    
    orderDetailNC.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"订单详情" image:[[UIImage imageNamed:@"订单详情"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"订单详情-s"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    ReservationManageVC *manageVC = [[ReservationManageVC alloc]init];
    UINavigationController *manageNC = [[UINavigationController alloc]initWithRootViewController:manageVC];
    
    manageNC.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"预约管理" image:[[UIImage imageNamed:@"预约管理"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"预约管理-s"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
 
    
    PersonalCenterVC *personalCenterVC = [[PersonalCenterVC alloc]init];
    UINavigationController *personalCenterNC = [[UINavigationController alloc]initWithRootViewController:personalCenterVC];
    
    personalCenterNC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"个人中心" image:[[UIImage imageNamed:@"个人中心"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"个人中心-s"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.viewControllers = @[orderDetailNC,manageNC,personalCenterNC];
    self.selectedIndex = 1;
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
