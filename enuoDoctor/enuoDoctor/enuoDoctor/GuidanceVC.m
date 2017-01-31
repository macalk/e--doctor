//
//  GuidanceVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "GuidanceVC.h"
#define NUM 3
#define kWidth_Page 100

@interface GuidanceVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *FirstLaunchView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *page;
@property (nonatomic, strong) NSArray *array;



@end

@implementation GuidanceVC
- (NSArray *)array{
    if (!_array) {
        self.array = @[@"1.jpg",@"2.jpg",@"3.jpg"];
    }return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createView];
}

#pragma mark ---引导页


- (void)createView {
    //布局滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds] ;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * NUM, kScreenHeigth);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    //布局图片
    for (int i = 0; i < NUM; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeigth)];
        imageView.image = [UIImage imageNamed:self.array[i]];
        [self.scrollView addSubview:imageView];
        
        
        if (i == NUM - 1) {
            //布局进入按钮
            imageView.userInteractionEnabled = YES;
            UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            enterBtn.frame = CGRectMake(0, kScreenHeigth - 125,kScreenWidth, 64);
            [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [enterBtn addTarget:self action:@selector(handleEnter:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:enterBtn];
        }
    }
    //布局分页索引
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth - kWidth_Page) / 2, kScreenHeigth - 80, kWidth_Page, 40)] ;
    _page.numberOfPages = 3;
    _page.currentPageIndicatorTintColor = [UIColor brownColor];
    _page.pageIndicatorTintColor = [UIColor grayColor];
    [_page addTarget:self action:@selector(handlePage) forControlEvents:UIControlEventValueChanged];
    [self.FirstLaunchView addSubview:_page];
}

- (void)handlePage {
    CGFloat x = self.page.currentPage * kScreenWidth;
    self.scrollView.contentOffset = CGPointMake(x, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.page.currentPage = scrollView.contentOffset.x / kScreenWidth;
}

- (void)handleEnter:(UIButton *)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [LoginVC new];
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
