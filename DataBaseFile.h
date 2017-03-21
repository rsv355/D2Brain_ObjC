//
//  DataBaseFile.h
//  DatabaseDemo
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBaseFile : NSObject

+(DataBaseFile *)databaseFile;

@property(strong,nonatomic)NSString *databasePath;
@property(nonatomic)sqlite3 *sqlite;
@property(strong,nonatomic)NSMutableArray *selectAllData;
@property(strong,nonatomic)NSString *ImageFolderPath;



-(void)CopyDatabaseInDevice;

-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

-(void)insertDataWithQuesy:(NSString *)insertQuery;
-(void)UpdateDataWithQuesy:(NSString *)UpdateQuery;
-(void)DeleteDataWithQuesy:(NSString *)DeleteQuery;




-(NSMutableArray *)selectAllDataFromTablewithQuery:(NSString *)selectQuery ofColumn:(int)numOfColumn;
-(NSMutableArray *)selectAllDataWithSingleFieldTablewithQuery:(NSString *)selectQuery;
-(NSString *)MathOperationInTable:(NSString *)selectQuery;




@end
