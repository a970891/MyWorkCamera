//
//  MainViewController.m
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "MainViewController.h"
#import "CameraViewController.h"
#import "SetViewController.h"
#import "MainTableViewCell.h"
#import "TutkP2PClient.h"
//#import "Client.h"
#import "CameraObject.h"
#import "CameraManager.h"
#import "ViewController.h"
#import "IOTCAPIs.h"
#import "P2PCamera-Swift.h"
#import "AudioPlayer.h"

static NSString *const mainCell = @"mainCell";
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIScrollView   *scrollView;
@property (nonatomic,strong) UIImageView    *setButton;

@property (nonatomic,strong) UITableView    *myTableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UISearchBar    *searchBar;
@property (nonatomic,strong) UIView         *lineView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)IOTCtest{
    
}

#pragma mark - Setter & Getter
- (void)setupUI {
    [self setMyNavBar];
    self.titleLabel.text = @"摄像机列表";
    if ([Myself getCurrentLanguage]){
        self.titleLabel.text = @"CameraList";
    }
    [self showRightButton];
    [self.rightButton setTitle:@"" forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.myTableView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(lScreenWidth-12-24, 30, 24, 24)];
    [button setImage:[UIImage imageNamed:@"icon_set"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)popAction {
    MainSettingViewController *vc = [[MainSettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //清除数据源
    [self.dataSource removeAllObjects];
    //获取数据
    self.dataSource = [NSMutableArray arrayWithArray:[[CameraManager sharedInstance] findAllObjects]];
    //刷新界面
    if (self.dataSource.count != 0) {
        [self.myTableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //尝试连接
    for (int i = 0;i<self.dataSource.count;i++){
        CameraObject *object = self.dataSource[i];
        object.tutkManager = [[Myself sharedInstance] findManagerWithUID:object.uid];
        object.tutkManager.UID = object.uid;
        object.tutkManager.password = object.password;
        object.tutkManager.name = object.name;
        object.tutkManager.push = object.push;
        [object.tutkManager connectsuccess:^{} fail:^{}];
    }
}

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64*AUTO_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64*AUTO_HEIGHT-49) style:UITableViewStylePlain];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        [_myTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:mainCell];
    }
    return _myTableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource ) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64*AUTO_HEIGHT, SCREEN_WIDTH, 20*AUTO_HEIGHT)];
        _searchBar.searchBarStyle = UISearchBarStyleProminent;
    }
    return _searchBar;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 84.5*AUTO_HEIGHT, SCREEN_WIDTH, 0.5*AUTO_HEIGHT)];
        _lineView.backgroundColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0];
    }
    return _lineView;
}
#pragma mark - Action
- (void)buttonClicked:(UIButton *)button {
    [self.navigationController pushViewController:[[CameraViewController alloc] init] animated:YES];
}

- (void)setButton:(UITapGestureRecognizer *)tap {
    [self.navigationController pushViewController:[[SetViewController alloc] init] animated:YES];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
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
                    for (int i = 0; i < self.dataSource.count; i++) {
                        CameraObject *obj = self.dataSource[i];
                        if ([obj.uid isEqualToString:textField1.text]) {
                            self.dataSource[i] = object;
                        }
                    }
                    [_myTableView reloadData];
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
            [self.myTableView reloadData];
        }
    }
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*AUTO_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCell forIndexPath:indexPath];

    CameraObject *object = self.dataSource[indexPath.row];
    
    //判断是否在线
//    [cell setOnlineStatus:on name:object.name];
    [cell setCell:object];
    cell.lComplection = ^(NSInteger m){
        if (object.password == NULL || [object.password isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请设置摄像头密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag = 102;
            [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            UITextField *textField1 = [alert textFieldAtIndex:0];
            UITextField *textField2 = [alert textFieldAtIndex:1];
            textField1.text = object.uid;
            textField2.placeholder = @"请输入密码";
            textField1.enabled = false;
            [alert show];
            return;
        }
        CameraViewController *cameraVC = [[CameraViewController alloc]initWithObject:object];
        self.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cameraVC animated:YES];
    };
    cell.rComplection = ^(NSInteger n){
        EditCameraTableViewController *vc = (EditCameraTableViewController *)[self StoryboardWithIdentifier:@"Settings" Identifier:@"EditCamera"];
        vc.hidesBottomBarWhenPushed = true;
        vc.cameraObj = object;
        [self.navigationController pushViewController:vc animated:true];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CameraObject *object = self.dataSource[indexPath.row];
    CameraViewController *cameraVC = [[CameraViewController alloc]initWithObject:object];
    [self.navigationController pushViewController:cameraVC animated:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar endEditing:YES];
}
@end
