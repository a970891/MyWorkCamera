//
//  ActionViewController.m
//  P2PCamera
//
//  Created by Raindy on 16/3/1.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "ActionViewController.h"
#import "P2PCamera-Swift.h"

static NSString *const Acell = @"Acell";
@interface ActionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView    *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setupUI{
    [self setMyNavBar];
    self.titleLabel.text = NSLocalizedString(@"title_event", @"");
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64*AUTO_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64*AUTO_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Acell];
    }
    return _tableView;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*AUTO_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Acell forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
