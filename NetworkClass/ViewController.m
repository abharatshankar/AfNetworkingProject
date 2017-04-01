//
//  ViewController.m
//  NetworkClass
//
//  Created by Rama kuppa on 01/04/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()
{
    NSMutableArray * articlesArray;
    
    UITableView *articleTableView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designTheTableView];
    [self forResponse];
    
    articlesArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)forResponse
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=f96b37b762b14d219b4ca072896fb39a"];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            articlesArray =[responseObject valueForKey:@"articles"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [articleTableView reloadData];
            });
        }
    }];
    [dataTask resume];
}


- (void)designTheTableView{
    
    CGSize sizeFrame = [[UIScreen mainScreen] bounds].size;
    
    articleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, sizeFrame.width, sizeFrame.height) style:UITableViewStylePlain];
    [self.view addSubview:articleTableView];
    
    [articleTableView setDelegate:self];
    [articleTableView setDataSource:self];
    
}

#pragma mark TableView Datasource And TableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return articlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    
    if (cellView == nil) {
        cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLID"];
    }
    
    //indexPath = [section,row];
    
    NSDictionary *data = [articlesArray objectAtIndex:indexPath.row];
    
    cellView.textLabel.text = [data valueForKey:@"title"];
    
    return cellView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
