//
//  anotherTrailerViewViewController.m
//  Flix
//
//  Created by Eva Xie on 6/25/21.
//

#import "anotherTrailerViewViewController.h"

@interface anotherTrailerViewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *anotherWebView;

@end

@implementation anotherTrailerViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // As a property or local variable
    NSString *urlString = @"https://www.dropbox.com/terms?mobile=1";
    
    // Convert the url String to a NSURL object.
    NSURL *url = [NSURL URLWithString:urlString];

    // Place the URL in a URL Request.
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];
    // Load Request into WebView.
    [self.anotherWebView loadRequest:request];
    
    // Do any additional setup after loading the view.
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
