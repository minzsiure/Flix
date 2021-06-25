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
    //URL
     //first part of string
     NSString *idString = [NSString stringWithFormat:@"%@", self.movieID ];
     NSLog(@"%@", idString);
     NSString *url_1 = @"https://api.themoviedb.org/3/movie/";
     NSString *url_3 = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed";
     NSString *APIURLString = [url_1 stringByAppendingString:idString];
     
     
     
     NSString *FullAPIURLString = [APIURLString stringByAppendingString:url_3];
     NSLog(@"%@", FullAPIURLString);
     
     //NSURL is similar to string, but it checks if input is a valid URL
     NSURL *APIURL = [NSURL URLWithString:FullAPIURLString];
     //Request
     NSURLRequest *request = [NSURLRequest requestWithURL:APIURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
     NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

     NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         //once network request comes back
            if (error != nil) {
                //if there's an error
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                //else gets to API
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //NSLog(@"%@", dataDictionary); // every api call gives a dataDic
                
                //gives a key (ie. results) to access the dictionary
                // this creates an NSArray named movies
                NSString *videoKey = dataDictionary[@"results"][1][@"key"];
                NSLog(@"key, %@", videoKey);
                
                //call your data source again bc the underlying data may have changed
                //[self.trailerWebView reloadData];
                NSString *baseString = @"https://www.youtube.com/watch?v=";
                NSLog(@"videoKey, %@", videoKey);
                
                NSString *comboString = [baseString stringByAppendingString:videoKey];
                NSLog(@"%@", comboString);
                // Convert the url String to a NSURL object.
                NSURL *videoURL = [NSURL URLWithString:comboString];


                // Place the URL in a URL Request.
                NSURLRequest *request = [NSURLRequest requestWithURL:videoURL
                                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                     timeoutInterval:10.0];
                // Load Request into WebView.
                [self.anotherWebView loadRequest:request];
                
            }
             //[self.refreshControl endRefreshing];
        }];
    [task resume];


    
    

}
    
    // Do any additional setup after loading the view.


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
