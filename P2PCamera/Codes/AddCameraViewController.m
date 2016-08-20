//
//  AddCameraViewController.m
//  P2PCamera
//
//  Created by Raindy on 16/3/1.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "AddCameraViewController.h"
#import "AddDetailViewController.h"
//#import "QRViewController.h"
#import "AudioPlayer.h"
#import "CameraObject.h"
#import "CameraManager.h"
#import "BBCell.h"
#import "SVProgressHUD.h"
#import "P2PCamera-Swift.h"

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
    //获取数据
    [self searchCamera];
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

#pragma mark - TableViewCell Delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

//删除按钮点击事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认要删除该摄像机吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 9999+indexPath.row;
    [alertView show];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//}

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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CameraObject *object = self.dataSource[indexPath.row];
    [cell setCell:indexPath.row camera:object];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.row);
    CameraObject *object = self.dataSource[indexPath.row];
    if([object.password isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请设置摄像头" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 102;
        [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        UITextField *textField1 = [alert textFieldAtIndex:0];
        UITextField *textField2 = [alert textFieldAtIndex:1];
        textField1.placeholder = @"请输入名字";
        textField1.uid = object.uid;
        textField2.placeholder = @"请输入密码";
        [alert show];
    } else {
        return;
    }
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
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"名字或密码不能为空" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
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
    } else
    if (alertView.tag == 102){
        if (buttonIndex == 1) {
            UITextField *textField1 = [alertView textFieldAtIndex:0];
            UITextField *textField2 = [alertView textFieldAtIndex:1];
            if ([textField2.text length] == 0 || [textField1.text length] == 0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"名字或密码不能为空" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                CameraObject *object = [[CameraObject alloc]init];
                object.uid = textField1.uid;
                object.name = textField1.text;
                object.password = textField2.text;
                
                if ([[CameraManager sharedInstance] insertObject:object]) {
                    for (int i = 0; i < self.dataSource.count; i++) {
                        CameraObject *obj = self.dataSource[i];
                        if ([obj.uid isEqualToString:textField1.uid]) {
                            self.dataSource[i] = object;
                        }
                    }
                    [self.tableView reloadData];
                }
            }
        }
    } else {
        if (buttonIndex == 0) {
            return;//取消
        } else {
            //确认
            [[CameraManager sharedInstance]deleteObject:self.dataSource[alertView.tag - 9999]];
            [self.dataSource removeObjectAtIndex:alertView.tag - 9999];
            [self.tableView reloadData];
        }
    }
}

- (void)rightButtonAction:(UIButton *)button{
    [self searchCamera];
}

- (void)searchCamera{
    [self.dataSource removeAllObjects];
    [_audioPlayer SearchAndConnect:^(NSString *str) {
        if ([str isEqualToString:@""] || str == NULL){
            [SVProgressHUD showErrorWithStatus:@"未找到摄像头"];
        } else {
            
            NSArray *arr = [[CameraManager sharedInstance] findAllObjects];
            for (CameraObject *obj in arr) {
                if ([obj.uid isEqualToString:str]) {
                    [self.dataSource addObject:obj];
                    NSLog(@"%@",obj.name);
                    [self.tableView reloadData];
                    return;
                }
            }
            CameraObject *obj = [[CameraObject alloc]init];
            obj.uid = str;
            obj.password = @"";
            obj.name = @"";
            [self.dataSource addObject:obj];
            [self.tableView reloadData];
            [[CameraManager sharedInstance] insertObject:obj];
        }
    }];
}



- (void)scanBtnClicked:(UIButton *)btn{

#warning 设备登陆测试
    
    QRViewController *qrVC = [[QRViewController alloc]init];
    [self.navigationController pushViewController:qrVC animated:YES];
}
@end
