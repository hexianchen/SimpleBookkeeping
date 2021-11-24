//
//  SortManagementVC.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/13.
//

#import "SortManagementVC.h"
#import "TypeCollectionViewCell.h"
#import "RecordModel.h"
#import "SortManagementHeaderView.h"
#import <Masonry/Masonry.h>

@interface SortManagementVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>{
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
    UIView *backView;
    UIView *addView;
    UIButton *addButn;
    UILabel *attentionLable;
    UITextField *textFieldType;
    RecordTypeModel *choseEditModel;
}
@property (nonatomic, strong) TypeCollectionViewCell *dragingCell;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *typeArray;


@end

@implementation SortManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.typeArray = [self getTyprData:self.recordType];
    [self createCollectView];
}
- (void) createCollectView{
    //创建布局对象
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    //设置滚动方向为垂直滚动，说明方块是从左上到右下的布局排列方式
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//     //设置顶部视图和底部视图的大小，当滚动方向为垂直时，设置宽度无效，当滚动方向为水平时，设置高度无效
//     layout.headerReferenceSize = CGSizeMake(100, 40);
//
//     layout.footerReferenceSize = CGSizeMake(100, 40);
    //创建容器视图
    CGRect frame =CGRectMake(0, 0, k_Frame_Width, k_Frame_Height);
     _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];//设置背景，默认为黑色
    
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TypeCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TypeCollectionViewCellID"];

    [_collectionView registerNib:[UINib nibWithNibName:@"SortManagementHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SortManagementHeaderViewID"];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressModel:)];
    longPress.minimumPressDuration = 0.3f;
    [_collectionView  addGestureRecognizer:longPress];
    
    _dragingCell = [[TypeCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, _collectionView.frame.size.width/4, 100)];
    _dragingCell.hidden = YES;
    [_collectionView addSubview:_dragingCell];
}
-(void) longpressModel:(UILongPressGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegan:gesture];
            //开始
            break;
        case UIGestureRecognizerStateChanged:
    
            //改变
            [self dragChanged:gesture];
            break;
        case UIGestureRecognizerStateEnded:
            //结束
            [self dragEnd:gesture];
            break;
        default:
            break;
    }
}
-(void) dragBegan:(UILongPressGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:_collectionView];
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {
        return;
        
    }
    [_collectionView bringSubviewToFront:_dragingCell];
    //更新被拖拽的cell
    _dragingCell.frame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
   
    _dragingCell.hidden = false;
    __weak typeof(self) weakself =  self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakself.dragingCell setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    }];
}
-(void)dragChanged:(UILongPressGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:_collectionView];
    _dragingCell.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    if (_targetIndexPath && _dragingIndexPath) {
        if (_targetIndexPath.row == self.typeArray.count) {
            //不能移动最后一个
            return;
        }
        [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        NSLog(@"%ld---------%ld",_dragingIndexPath.row,_targetIndexPath.row);
        [self.typeArray exchangeObjectAtIndex:_dragingIndexPath.row withObjectAtIndex:_targetIndexPath.row];
        
        _dragingIndexPath = _targetIndexPath;
        [_collectionView reloadData];
    }
}

-(void)dragEnd:(UILongPressGestureRecognizer*)gesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameNotification" object:self userInfo:@{@"typeArray":self.typeArray}];
    NSLog(@"拖拽结束");
    if (!_dragingIndexPath) {
        return;
        
    }
    ;
    CGRect endFrame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    __weak typeof(self) weakself =  self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakself.dragingCell setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        weakself.dragingCell.frame = endFrame;
    }completion:^(BOOL finished) {
        weakself.dragingCell.hidden = true;
    }];
}



//获取被拖动IndexPath的方法
-(NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point
{
    
    NSIndexPath* dragingIndexPath = nil;
    //遍历所有屏幕上的cell
    for (NSIndexPath *indexPath in [_collectionView indexPathsForVisibleItems]) {
        
        //判断cell是否包含这个点
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            NSLog(@"被拖动:    %ld-%ld",dragingIndexPath.row,indexPath.row);
            dragingIndexPath = indexPath;
            break;
        }
    }
    return dragingIndexPath;
}
//获取目标IndexPath的方法
-(NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point
{
    NSIndexPath *targetIndexPath = nil;
    //遍历所有屏幕上的cell
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //避免和当前拖拽的cell重复
        if ([indexPath isEqual:_dragingIndexPath]) {continue;}
        //判断是否包含这个点
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            NSLog(@"//获取目标:  %ld-   %ld",targetIndexPath.row,indexPath.row);
            targetIndexPath = indexPath;
            
        }
    }
    return targetIndexPath;
}



#pragma mark - UICollectionViewDelegateFlowLayout

/* 设置各个方块的大小尺寸 */
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
 

    CGFloat width = (collectionView.frame.size.width-50)/4;

    CGFloat height = 100;

    return CGSizeMake(width, height);

}

/* 设置每一组的上下左右间距 */

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout

insetForSectionAtIndex:(NSInteger)section

{

    return UIEdgeInsetsMake(10, 10, 10, 10);

}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.typeArray.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TypeCollectionViewCellID" forIndexPath:indexPath];
    if (self.typeArray.count == indexPath.row) {
        cell.imgView.image = [UIImage imageNamed:@"add"];
        cell.typeNameLable.text = @"添加";
    }else{
        RecordTypeModel *temp = self.typeArray[indexPath.row];
        
        cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Select",temp.iconImg]];
        cell.typeNameLable.text = temp.typeName;
    }
    return cell;
}
/* 设置顶部视图和底部视图 */

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        SortManagementHeaderView *view = (SortManagementHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SortManagementHeaderViewID" forIndexPath:indexPath];
        view.recordType = self.recordType;
        __weak typeof(self) weakSelf = self;
        view.tapButton = ^(BOOL type) {
            weakSelf.recordType = type;
            weakSelf.typeArray = [weakSelf getTyprData:weakSelf.recordType];
            [weakSelf.collectionView reloadData];
        };
        return view;
    }
    return nil;
}
// 设置Header的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 170);
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.typeArray.count == indexPath.row) {
        [self creatAdddView:1];
    }else{
        choseEditModel = self.typeArray[indexPath.row];
        [self creatAdddView:2];

    }
}
//type:1为添加，2为删除或修改
- (void)creatAdddView:(NSInteger )type{
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha =  0.3;
    [self.view addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cleasView)];
    [backView  addGestureRecognizer:tap];
    addView = [[UIView alloc] init];
    addView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapdismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [addView addGestureRecognizer:tapdismissKeyboard];
    [self.view addSubview:addView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(addView.mas_top);
    }];
    
    [addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(300);
        make.top.mas_equalTo(backView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"添加分类";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:20];
    [addView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addView).mas_offset(20);
        make.centerX.mas_equalTo(addView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(120);
    }];
//    //增加监听，当键盘出现或改变时接收消息
//
    //加一个textField，以便可以弹出键盘
    textFieldType = [[UITextField alloc]init];
    textFieldType.layer.cornerRadius = 5;
    textFieldType.backgroundColor = [UIColor systemGray6Color];
    textFieldType.placeholder = @" 不能与已有类型名重复";
    textFieldType.delegate = self;
//    textField.keyboardType = UIKeyboardTypeNumberPad;  //键盘类型
    [addView addSubview:textFieldType];
    [textFieldType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(addView);
        make.height.mas_offset(60);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    addButn = [[UIButton alloc] init];
    addButn.layer.cornerRadius = 5;
    [addButn setTitleColor:[UIColor systemGray2Color] forState:UIControlStateNormal];
    [addButn setBackgroundColor:[UIColor systemGray6Color]];
    [addButn addTarget:self action:@selector(tureButton:) forControlEvents:UIControlEventTouchUpInside];
    [addView  addSubview:addButn];
    [addButn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textFieldType.mas_bottom).mas_offset(50);
        make.centerX.mas_equalTo(addView);
        make.height.mas_offset(40);
        make.width.mas_equalTo(150);

    }];
    if (type == 2) {
        UIButton *removeButton = [[UIButton alloc] init];
        removeButton.layer.cornerRadius = 5;
        [removeButton setTitle:@"删除" forState:UIControlStateNormal];
        [removeButton setBackgroundColor:[UIColor redColor]];
        [removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [removeButton addTarget:self action:@selector(removeButton) forControlEvents:UIControlEventTouchUpInside];
        [addView  addSubview:removeButton];
        [removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(addButn.mas_bottom).mas_offset(10);
            make.centerX.mas_equalTo(addView);
            make.height.mas_offset(30);
            make.width.mas_equalTo(150);
        }];
        textFieldType.text = choseEditModel.typeName;
        title.text = @"修改分类";
        [addButn setTitle:@"修改" forState:UIControlStateNormal];
        

    }else{
        [addButn setEnabled:NO];
        title.text = @"添加分类";
        [addButn setTitle:@"添加" forState:UIControlStateNormal];

    }
    
    attentionLable = [[UILabel alloc] init];
    attentionLable.textColor = [UIColor redColor];
    attentionLable.font = [UIFont systemFontOfSize:14];
    [addView addSubview:attentionLable];
    [attentionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textFieldType.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
 
 
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;   //height 就是键盘的高度
    [addView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(300);
        make.top.mas_equalTo(backView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-height);
    }];
}
 
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    [addView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(300);
        make.top.mas_equalTo(backView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}


-(void)dismissKeyboard  {
    [textFieldType resignFirstResponder];
    [addView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(300);
        make.top.mas_equalTo(backView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}
- (void) cleasView{
    [backView removeFromSuperview];
    [addView removeFromSuperview];
}

#pragma mark -UITextFlidDelegate
- (void) textFieldDidChangeSelection:(UITextField *)textField{
    
      NSString *toBeString = textField.text;
    if(toBeString.length>0){
        [addButn setEnabled:YES];
        [addButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButn setBackgroundColor:self.recordType?incomeColor:ExpenseColor];
        for (RecordTypeModel *temp in self.typeArray) {
            if ([temp.typeName isEqualToString:textField.text]) {
                if (![choseEditModel.typeName  isEqualToString:temp.typeName]) {
                    attentionLable.text = @"名称与已有分类名称相同，请常重新输入一个名称。";
                }
                [addButn setTitleColor:[UIColor systemGray2Color] forState:UIControlStateNormal];
                [addButn setBackgroundColor:[UIColor systemGray6Color]];
                [addButn setEnabled:NO];

                break;
            }else{
                attentionLable.text = @"";
                [addButn setEnabled:YES];
            }
        }
    }else{
        [addButn setEnabled:NO];
        [addButn setTitleColor:[UIColor systemGray2Color] forState:UIControlStateNormal];
        [addButn setBackgroundColor:[UIColor systemGray6Color]];
    }
      NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
      if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
         UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
         UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
         // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
         if (!position) {
              if (toBeString.length > 4) {
                  textField.text = [toBeString substringToIndex:4];
              }
          }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
          else{
              
           }
         }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况   else{
          if (toBeString.length > 4) {
              textField.text = [toBeString substringToIndex:4];
          }
}
#pragma mark -数据的添加、修改、删除、保存
//添加按钮
-(void) tureButton:(UIButton  *)btn{
    if ([btn.titleLabel.text isEqualToString:@"添加"]) {
        RecordTypeModel *add = [[RecordTypeModel alloc]init];
        if (self.recordType) {
            add.recordType = YES;
            add.iconImg = @"yiwaishouru";
        }else{
            add.recordType = NO;
            add.iconImg = @"zhichu";
        }
        add.number = self.typeArray.count +2;
        NSString *typeS = [NSString stringWithFormat:@"%@%d", [Tool randomString:6],arc4random_uniform(9)];
        add.type = typeS;
        add.typeName = textFieldType.text;
        [self savetypePlist:[add dicFromObject]];
        [self.typeArray insertObject:add atIndex:self.typeArray.count];
    }else{
        choseEditModel.typeName = textFieldType.text;
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString* plist1 = [paths objectAtIndex:0];
        //获取一个plist文件
        NSString* filename = [plist1 stringByAppendingString:@"PropertyList.plist"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filename];
        int i=0;
        for (NSDictionary *dic in array) {
            if([ dic[@"type"] isEqualToString: choseEditModel.type]){
                [array replaceObjectAtIndex:i withObject:[choseEditModel dicFromObject]];
                break;
            }
            i++;
        }
        NSString *xiaoXiPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"PropertyList.plist"];
        //如果文件路径存在的话
        BOOL bRet = [[NSFileManager defaultManager] fileExistsAtPath:xiaoXiPath];
        if (bRet) {
                      NSError *err;
                      [[NSFileManager defaultManager] removeItemAtPath:xiaoXiPath error:&err];
         }
        [array writeToFile:filename atomically:YES];
        
        int j=0;
        for (RecordTypeModel *tempType in self.typeArray) {
            if([tempType.type isEqualToString: choseEditModel.type]){
                [self.typeArray replaceObjectAtIndex:j withObject:choseEditModel];
                break;
            }
            j++;
        }
    }
    
    
    [textFieldType resignFirstResponder];
    [self cleasView];
    [_collectionView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameNotification" object:self userInfo:@{@"typeArray":self.typeArray}];
}
- (void) savetypePlist:(NSDictionary *)dic{
    //保存新的数据
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* plist1 = [paths objectAtIndex:0];
    //获取一个plist文件
    NSString* filename = [plist1 stringByAppendingString:@"PropertyList.plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    [array  addObject:dic];
    [array writeToFile:filename atomically:YES];

}
//删除按钮
-(void) removeButton{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* plist1 = [paths objectAtIndex:0];
    //获取一个plist文件
    NSString* filename = [plist1 stringByAppendingString:@"PropertyList.plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    for (NSDictionary *dic in array) {
        RecordTypeModel *tempModel = [[RecordTypeModel alloc] initWithDictionary:dic];
        if([tempModel.type isEqualToString: choseEditModel.type]){
            [array removeObject:dic];
            break;
        }
    }
    NSString *xiaoXiPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"PropertyList.plist"];
    //如果文件路径存在的话
    BOOL bRet = [[NSFileManager defaultManager] fileExistsAtPath:xiaoXiPath];
    if (bRet) {
                  NSError *err;
                  [[NSFileManager defaultManager] removeItemAtPath:xiaoXiPath error:&err];
     }
    [array writeToFile:filename atomically:YES];

    [self.typeArray removeObject:choseEditModel];
    
    [textFieldType resignFirstResponder];
    [self cleasView];
    [_collectionView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameNotification" object:self userInfo:@{@"typeArray":self.typeArray}];
      
}
- (NSMutableArray *) getTyprData:(BOOL) recordType{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* plist1 = [paths objectAtIndex:0];
    //获取一个plist文件
    NSString* filename = [plist1 stringByAppendingString:@"PropertyList.plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filename];
    NSMutableArray *tempMArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        RecordTypeModel *tempModel = [[RecordTypeModel alloc] initWithDictionary:dic];
        if(tempModel.recordType == recordType){
            [tempMArray addObject:tempModel];
        }
    }
    [tempMArray sortUsingComparator:^NSComparisonResult(RecordModel *obj1, RecordModel *obj2) {
        return [@(obj1.number) compare:@(obj2.number)];
    }];
    return tempMArray;
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
