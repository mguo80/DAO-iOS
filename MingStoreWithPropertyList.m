//
//  MingStoreWithPropertyList.m
//
//  Created by mguo80 on 10/12/14.
//

#import "MingStoreWithPropertyList.h"

@interface MingStoreWithPropertyList()
@property (nonatomic, strong)   NSString *path;     //absolute file path (including file name)
@end

@implementation MingStoreWithPropertyList

@synthesize cloud;

-(instancetype)initWithName:(NSString *)name andCloud:(id<MingCloud>)cld
{
    if (self = [super init])
    {
        self.name = name;
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePathWithFolder = [filePath stringByAppendingPathComponent:@"plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePathWithFolder])
        {
            //create immediate sub-directory to hold all .plist files
            NSError *error;
            [[NSFileManager defaultManager] createDirectoryAtPath:filePathWithFolder withIntermediateDirectories:YES attributes:nil error:&error];
        }
        self.path = [filePathWithFolder stringByAppendingPathComponent:name];
        self.cloud = cld;
    }
    return self;
}

-(id)getObjectByKey:(NSString *)key
{
    id obj = [[self getPList] objectForKey:key];
    if (!obj)
    {
        //fall back to cloud cache if it doesn't exist in disk cache yet
        obj = [self.cloud getObjectByKey:key];
        if (obj)
        {
            [self savePListObject:obj ByKey:key];
        }
    }
    return obj;
}

-(BOOL)setObject:(id)obj ByKey:(NSString *)key
{
    [self savePListObject:obj ByKey:key];
    return [self.cloud setObject:obj ByKey:key];
}

-(id)getCustomObjectByKey:(NSString *)key
{
    NSData *data = [self getObjectByKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

-(BOOL)setCustomObject:(id<NSCoding>)obj ByKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    return [self setObject:data ByKey:key];
}

-(NSDictionary*)getPList
{
    NSDictionary *plist = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.path])
    {
        NSData *data = [NSData dataWithContentsOfFile:self.path];
        if (data)
        {
            plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
        }
    }
    return plist;
}

-(void)savePListObject:(id)obj ByKey:(NSString*)key
{
    NSMutableDictionary *plist = [[self getPList] mutableCopy];
    if (!plist)
    {
        plist = [NSMutableDictionary dictionary];
    }
    [plist setObject:obj forKey:key];
    
    NSError *error;
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:plist format:NSPropertyListXMLFormat_v1_0 options:(0) error:&error];
    if (data)
    {
        [data writeToFile:self.path options:NSDataWritingAtomic error:&error];
    }
}

@end
