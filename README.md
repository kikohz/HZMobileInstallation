HZMobileInstallation
==================

Achieved `MobileInstallation.framework` inside install, uninstall, appList.

###Usage

Add files to the project

######Install

	NSString *docpath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [docpath stringByAppendingPathComponent:@"test.ipa"];
    IPAResult status =  InstallIpa(path);



###Demo

######Show App List


![list](http://ww3.sinaimg.cn/large/62b50d84tw1ee7d69bdffj20hs0qo0v6.jpg)