//
//  HZMobileInstallation.m
//  AppManage
//
//  Created by x on 14-3-7.
//
//
#import <dlfcn.h>
#import "HZMobileInstallation.h"

#define kApplicationType   @"ApplicationType"

typedef int (*MobileInstallationBrowse)(NSDictionary *options, int (*mibcallback)(NSDictionary *dict, id usercon), id usercon);

typedef int (*MobileInstallationUninstall)(NSString *appCode, NSDictionary *dict, void *na, NSString *strna);

typedef int (*MobileInstallationInstall)(NSString *path, NSDictionary *dict, void *na, NSString *path2_equal_path_maybe_no_use);

IPAResult InstallIpa(NSString *path){
  
  void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
  if (lib)
  {
    IPAResult ret = IPAResultFail;
    MobileInstallationInstall pMobileInstallationInstall = (MobileInstallationInstall)dlsym(lib, "MobileInstallationInstall");
    if (pMobileInstallationInstall){
      NSString *name = [@"Install_" stringByAppendingString:@"app.ipa"];
      NSString *temp = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
      if(![[NSFileManager defaultManager] fileExistsAtPath:temp])
      {
        if(![[NSFileManager defaultManager] copyItemAtPath:path toPath:temp error:nil])
          return IPAResultFileNotFound;
      }
      
      ret = (IPAResult)pMobileInstallationInstall(temp, [NSDictionary dictionaryWithObject:kUser forKey:kApplicationType], 0, path);
      [[NSFileManager defaultManager] removeItemAtPath:temp error:nil];
    }
    dlclose(lib);
    return ret;
  }
  return IPAResultNoFunction;
}


IPAResult UninstallApp(NSString *bundleIdentifier){
  
  void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
  if (lib)
  {
    IPAResult ret = IPAResultFail;
    MobileInstallationUninstall pMobileInstallationUninstall = (MobileInstallationUninstall)dlsym(lib, "MobileInstallationUninstall");
    if (pMobileInstallationUninstall)
    {
      ret = (IPAResult)pMobileInstallationUninstall(bundleIdentifier, [NSDictionary dictionaryWithObject:kUser forKey:kApplicationType], 0, 0);
    }
    dlclose(lib);
    return ret;
  }
  return IPAResultNoFunction;
}


static int browse_mibcallback(NSDictionary *dict, id result)
{
	NSArray *currentlist = [dict objectForKey:@"CurrentList"];
	if (currentlist) {
    @autoreleasepool {
      for (NSDictionary *appinfo in currentlist) {
        [(NSMutableArray*)result addObject:[appinfo copy] ];
      }
    }
	}
	return 0;
}

NSArray *AppList(NSString *applicationType){
  
  NSMutableArray *apps = [NSMutableArray array];
  void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
  if (lib)
  {
    MobileInstallationBrowse pMobileInstallationBrowse = (MobileInstallationBrowse)dlsym(lib, "MobileInstallationBrowse");
    if (pMobileInstallationBrowse)
    {
      int ret = pMobileInstallationBrowse(
                                          [NSDictionary dictionaryWithObject:applicationType forKey:kApplicationType],
                                          &browse_mibcallback,
                                          apps);
      if(ret!=0)
        return nil;
    }
  }
  dlclose(lib);
  if(!apps)
    return nil;
  return apps;
}

