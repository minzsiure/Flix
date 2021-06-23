//
//  MoviesViewController.m
//  Flix
//
//  Created by Eva Xie on 6/23/21.
//

#import "MoviesViewController.h"

@interface MoviesViewController ()

// create a property. it does both setter and getter in java
// nonatomic (in most cases it will use nonatomic) and
// strong ("data don't go away") means how compiler generates
@property (nonatomic, strong) NSArray *movies;

@end

@implementation MoviesViewController
// property can be override here

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // set up
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //once network calls
           if (error != nil) {
               //if there's an error
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               //else gets to API
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary); // every api call gives a dataDic
               
               //gives a key (ie. results) to access the dictionary
               // this creates an NSArray named movies
               self.movies = dataDictionary[@"results"];
               
               // iterate through each movie in movies and print out "titles"
               for (NSDictionary *movie in self.movies){
                   NSLog(@"%@", movie[@"title"]);
               }
               
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
       }];
    [task resume];
}

- (void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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
