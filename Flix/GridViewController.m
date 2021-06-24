//
//  GridViewController.m
//  Flix
//
//  Created by Eva Xie on 6/24/21.
//

#import "GridViewController.h"
#import "UIImageView+AFNetworking.h"

@interface GridViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *gridBackDropView;
@property (weak, nonatomic) IBOutlet UIImageView *gridPosterView;
@property (weak, nonatomic) IBOutlet UILabel *gridTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *gridSynoposisLabel;
@property (weak, nonatomic) IBOutlet UILabel *gridDateLabel;

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    //NSURL is similar to string, but it checks if input is a valid URL
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.gridPosterView setImageWithURL:posterURL];
    [self.gridPosterView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.gridPosterView.layer setBorderWidth:3.0];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    //NSURL is similar to string, but it checks if input is a valid URL
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    
    [self.gridBackDropView setImageWithURL:backdropURL];
    
    self.gridTitleLabel.text = self.movie[@"title"];
    self.gridSynoposisLabel.text = self.movie[@"overview"];
    self.gridDateLabel.text = self.movie[@"release_date"];
    
    [self.gridTitleLabel sizeToFit];
    [self.gridSynoposisLabel sizeToFit];
    [self.gridDateLabel sizeToFit];
}


//#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    UITableViewCell *tappedCell = sender;
//    NSIndexPath indexPath = [self.tableView indexPathForCell];
//    NSDictionary *movie = self.movies[indexPath.row];
//
//    GridViewController *gridViewController = [segue destinationViewController]
//    NSLog(@"hey");
//}


@end
