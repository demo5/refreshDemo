//
//  ViewController.m
//  refreshDemo
//
//  Created by Zach on 15/7/22.
//  Copyright (c) 2015年 Zack. All rights reserved.
//

#import "ViewController.h"
//导入头文件
#import "MJRefresh.h"
#define ZGRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]
static const CGFloat MJDuration = 2.0;

@interface ViewController ()
@property (nonatomic , strong) NSMutableArray *data;
@end

@implementation ViewController


//懒加载
-(NSMutableArray *) data {

    if (!_data) {
        self.data = [NSMutableArray array];
    }
    return _data;
}



- (void)viewDidLoad {
  
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 加载一个tableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //使用自定义的delegate和dataSource；
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //MJrefresh
    __weak __typeof (self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{[weakSelf loadNewData];}];
    [self.tableView.header beginRefreshing];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{[weakSelf loadMoreData];}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifire = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", @"周哥添加test", self.data[indexPath.row]];
    
    return cell;
}


#pragma mark 加载更新数据
- (void)loadMoreData
{
    //周哥添加-------------------begin--------------------------
    // 1.添加假数据：上拉加载更多的时候会自动调用这个方法，通过一个5次的循环将前面定义的YGRandomData产生的随机数添加到data数组中，然后通过[self.tableView reloadData];这句代码刷新表格，加载更多的数据就显示出来了，最后通过这句代码[self.tableView.footer endRefreshing];结束刷新
    for (int i = 0; i<5; i++) {
        [self.data insertObject:ZGRandomData atIndex:0];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.footer endRefreshing];
    });
    //周哥添加--------------------end------------------------------
}
- (void)loadNewData
{
    //周哥添加-------------------begin--------------------------
    // 1.添加假数据：将随机产生的新数据插入到data数组最前面，用的这个insertObject:YGRandomData atIndex:0，这样是模拟了加载最新数据的业务场景，然后刷新表格——>结束刷新，更加载更多一样的道理
    for (int i = 0; i<5; i++) {
        [self.data insertObject:ZGRandomData atIndex:0];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.header endRefreshing];
    });
    //周哥添加--------------------end------------------------------
}





@end
