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
@property (nonatomic,strong) AudioPlayer    *audioPlayer;
@property (nonatomic,strong) NSMutableArray *deviceUids;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initSetupUI];
//    [self initNaviTools];
    [self setupUI];
//    [self setCameras];
    _audioPlayer = [[AudioPlayer alloc] init];
    [_audioPlayer IOTC_Init];
    _deviceUids = [[NSMutableArray alloc]init];
}

- (void)IOTCtest{
    
}

#pragma mark - Setter & Getter
- (void)setupUI {
    [self setMyNavBar];
    self.titleLabel.text = @"摄像机列表";
    [self showRightButton];
    [self.rightButton setTitle:@"" forState:UIControlStateNormal];
//    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.myTableView];
//    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, lScreenWidth, lScreenHeight-64)];
//    _scrollView.backgroundColor = [UIColor clearColor];
//    _scrollView.contentSize = CGSizeMake(lScreenWidth, _scrollView.frame.size.height);
//    [self.view addSubview:_scrollView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(lScreenWidth-12-24, 30, 24, 24)];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button setTitle:@"二维码" forState:UIControlStateNormal];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    button.titleLabel.font = [UIFont systemFontOfSize:13];
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
    //获取在线设备
    NSString *str = [_audioPlayer SearchAndConnect];
    [self.deviceUids removeAllObjects];
    [self.deviceUids addObject:str];
    //获取数据
    self.dataSource = [NSMutableArray arrayWithArray:[[CameraManager sharedInstance] findAllObjects]];
    //刷新界面
    if (self.dataSource.count != 0) {
        [self.myTableView reloadData];
    }
}

- (void)setCameras {
    for(int i=0;i<4;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10, 30+90*i, lScreenWidth-20, 60);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"UNDEFINED..." forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        [_scrollView addSubview:button];
    }
    
    _setButton = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30+90*4, lScreenWidth-20, 40)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setButton:)];
    [_setButton addGestureRecognizer:tap];
    _setButton.userInteractionEnabled = YES;
    _setButton.image = [UIImage imageNamed:@"pull_down"];
    _setButton.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_setButton];
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
    if (buttonIndex == 0) {
        return;//取消
    } else {
        //确认
        [[CameraManager sharedInstance]deleteObject:self.dataSource[alertView.tag - 9999]];
        [self.dataSource removeObjectAtIndex:alertView.tag - 9999];
        [self.myTableView reloadData];
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
    BOOL on = false;
    for (NSString *str in self.deviceUids) {
        if ([object.uid isEqualToString:str]) {
            on = true;
            break;
        }
    }
    [cell setOnlineStatus:on];
    [cell setCell:object];
    cell.lComplection = ^(NSInteger m){
        CameraViewController *cameraVC = [[CameraViewController alloc]initWithUid:object.uid password:object.password];
        self.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cameraVC animated:YES];
    };
    cell.rComplection = ^(NSInteger n){
        EditCameraTableViewController *vc = (EditCameraTableViewController *)[self StoryboardWithIdentifier:@"Settings" Identifier:@"EditCamera"];
        vc.hidesBottomBarWhenPushed = true;
        vc.cameraObj = object;
//        [self presentViewController:vc animated:true completion:nil];
        [self.navigationController pushViewController:vc animated:true];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CameraObject *object = self.dataSource[indexPath.row];
    CameraViewController *cameraVC = [[CameraViewController alloc]initWithUid:object.uid password:object.password];
    [self.navigationController pushViewController:cameraVC animated:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar endEditing:YES];
}
@end
