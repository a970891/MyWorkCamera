//
//  AddCameraViewController.m
//  P2PCamera
//
//  Created by Raindy on 16/3/1.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "AddCameraViewController.h"
#import "AddDetailViewController.h"
#import "QRViewController.h"
#import "AudioPlayer.h"
#import "CameraObject.h"
#import "CameraManager.h"
#import "BBCell.h"
#import "SVProgressHUD.h"

static NSString *const Bcell = @"Bcell";
static NSString *const Ccell = @"Ccell";
@interface AddCameraViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong)UIButton *scanBtn;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSArray *remoteMovies;
@property (nonatomic,strong)AudioPlayer *audioPlayer;

@end

@implementation AddCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    _audioPlayer = [[AudioPlayer alloc] init];
    [_audioPlayer IOTC_Init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //清除数据源
    [self.dataSource removeAllObjects];
    //获取数据
    self.dataSource = [NSMutableArray arrayWithArray:[[CameraManager sharedInstance] findAllObjects]];
    //刷新界面
    if (self.dataSource.count != 0) {
        [self.tableView reloadData];
    }
}

- (void)setupUI{
    [self setMyNavBar];
    self.titleLabel.text = @"添加摄影机";
    self.view.backgroundColor = [UIColor whiteColor];
    [self showRightButton];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.scanBtn];
    [self.view addSubview:self.tableView];
}

#pragma mark - 按钮响应事件

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(50*AUTO_WIDTH, 90*AUTO_HEIGHT, 60*AUTO_WIDTH, 20*AUTO_HEIGHT);
        [_addBtn setTitle:@"新增" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.frame = CGRectMake(210*AUTO_WIDTH, 90*AUTO_HEIGHT, 60*AUTO_WIDTH, 20*AUTO_HEIGHT);
        [_scanBtn setTitle:@"QRCode" forState:UIControlStateNormal];
        [_scanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _scanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_scanBtn addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanBtn;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 130*AUTO_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[BBCell class] forCellReuseIdentifier:Bcell];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:Ccell];
    }
    return _tableView;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*AUTO_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BBCell *cell = [tableView dequeueReusableCellWithIdentifier:Bcell forIndexPath:indexPath];
    CameraObject *object = self.dataSource[indexPath.row];
    [cell setCell:indexPath.row camera:object];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20*AUTO_HEIGHT;
}

//组头部复用
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:Ccell];
    if (self.label==nil) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(10*AUTO_WIDTH, 0, 160*AUTO_WIDTH, 20*AUTO_HEIGHT)];
        self.label.text = [NSString stringWithFormat:@"找到%lu个摄像机",(unsigned long)[self.dataSource count]];
        self.label.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:self.label];
    }
    
    return headerView;
}
//- (void)updataHeaderFooterView:(int)number{
//    self.label.text = [NSString stringWithFormat:@"找到%d个摄影机!",number];
//}

- (void)addBtnClicked:(UIButton *)btn{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入摄像头uid和密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    alert.tag = 101;
    UITextField *textField1 = [alert textFieldAtIndex:0];
    UITextField *textField2 = [alert textFieldAtIndex:1];
    
    textField1.placeholder = @"请输入uid";
    textField2.placeholder = @"请输入连接密码";
    
    [alert show];
}

// alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101){
        if (buttonIndex == 1) {
            UITextField *textField1 = [alertView textFieldAtIndex:0];
            UITextField *textField2 = [alertView textFieldAtIndex:1];
            if ([textField1.text length] == 0 || [textField2.text length] == 0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"uid或密码不能为空" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                CameraObject *object = [[CameraObject alloc]init];
                object.uid = textField1.text;
                object.password = textField2.text;
                
                if ([[CameraManager sharedInstance] insertObject:object]) {
                    [self.dataSource addObject:object];
                    [self.tableView reloadData];
                }
            }
        }
    }
    if (alertView.tag == 102){
        if (buttonIndex == 1) {
            UITextField *textField1 = [alertView textFieldAtIndex:0];
            UITextField *textField2 = [alertView textFieldAtIndex:1];
            if ([textField2.text length] == 0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能为空" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                CameraObject *object = [[CameraObject alloc]init];
                object.uid = textField1.text;
                object.password = textField2.text;
                
                if ([[CameraManager sharedInstance] insertObject:object]) {
                    [self.dataSource addObject:object];
                    [self.tableView reloadData];
                }
            }
        }
    }
}

- (void)rightButtonAction:(UIButton *)button{
    [self searchCamera];
}

- (void)searchCamera{
    NSString *str = [_audioPlayer SearchAndConnect];
    if ([str isEqualToString:@""] || str == NULL){
        [SVProgressHUD showErrorWithStatus:@"未找到摄像头"];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"找到一个摄像机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 102;
        NSLog(@"%@",str);
        [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        UITextField *textField1 = [alert textFieldAtIndex:0];
        UITextField *textField2 = [alert textFieldAtIndex:1];
        textField1.text = str;
        textField2.placeholder = @"请输入密码";
        textField1.enabled = false;
        [alert show];
    }
    [self.tableView reloadData];
}



- (void)scanBtnClicked:(UIButton *)btn{

#warning 设备登陆测试
    
    QRViewController *qrVC = [[QRViewController alloc]init];
    [self.navigationController pushViewController:qrVC animated:YES];
}
@end
