//
//  MainNavigationViewController.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/11/25.
//

#import "MainNavigationViewController.h"

@interface MainNavigationViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toobBar;

@end

@implementation MainNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 修改NarBar背景
    if (@available(iOS 15.0, *)) {
        
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        // 背景色
        appearance.backgroundColor = [UIColor whiteColor];
        // 去掉半透明效果
        appearance.backgroundEffect = nil;
        // 标题字体颜色及大小
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName : [UIColor blackColor],
            NSFontAttributeName : [UIFont boldSystemFontOfSize:20],
        };
        // 设置导航栏下边界分割线透明
        appearance.shadowImage = [[UIImage alloc] init];
        // 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
        appearance.shadowColor = [UIColor systemGray4Color];
        // standardAppearance：常规状态, 标准外观，iOS15之后不设置的时候，导航栏背景透明
        self.navigationBar.standardAppearance = appearance;
        // scrollEdgeAppearance：被scrollview向下拉的状态, 滚动时外观，不设置的时候，使用标准外观
        self.navigationBar.scrollEdgeAppearance = appearance;
    }
//    self.navigationBar.ba = [UIColor blackColor];
//    self.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationBar.tintColor = [UIColor blackColor];
    UIToolbar *b = [[UIToolbar alloc] init];
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
