//
//  AboutMainViewController.m
//  Khodro service shahr
//
//  Created by aDb on 2/12/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "AboutMainViewController.h"
#import "JKPopMenuView.h"
#import "AboutUSDetailViewController.h"

@interface AboutMainViewController ()<JKPopMenuViewSelectDelegate>
{
    BOOL isShown;
}
@end

@implementation AboutMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isShown = NO;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!isShown) {
        NSMutableArray *nameArray = [[NSMutableArray alloc]initWithObjects:@"خدمات",@"تاریخچه",@"باشگاه مشتریان",@"مزیت های رقابتی",@"تماس با ما",@"تسهیلات رانندگی",nil];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSInteger i = 1; i < 7; i++) {
            NSString *string = [NSString stringWithFormat:@"icon%ld",i];
            NSString *title = [nameArray objectAtIndex:i-1];
            JKPopMenuItem *item = [JKPopMenuItem itemWithTitle:title image:[UIImage imageNamed:string]];
            [array addObject:item];
        }
        
        JKPopMenuView *jkpop = [JKPopMenuView menuViewWithItems:array];
        jkpop.containerView = self.view;
        jkpop.delegate = self;
        [jkpop show];
        
        isShown = YES;
    }

}

#pragma mark App JKPopMenuViewSelectDelegate
- (void)popMenuViewSelectIndex:(NSInteger)index
{
    NSLog(@"%s",__func__);
    
    self.menuID = index;
    isShown = NO;
    [self performSegueWithIdentifier:@"about" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AboutUSDetailViewController *destionation = [segue destinationViewController];
    destionation.menuID = self.menuID;

}


@end
