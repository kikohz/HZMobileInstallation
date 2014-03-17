HZMobileInstallation
==================

Achieved `MobileInstallation.framework` inside install, uninstall, appList.

###Usage

Add a pod entry to your Podfile:

	pod 'HZMobileInstallation', '~> 0.1'
	
Install the pod(s) by running:

	pod install
	
add entitlements file

open keychain will automatically generate entitlements file

![](http://ww3.sinaimg.cn/large/62b50d84tw1eeit6olyoyj20h104fjre.jpg)

Reference `Source/test.entitlements` Set 


######Install ipa

	NSString *docpath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [docpath stringByAppendingPathComponent:@"test.ipa"];
    IPAResult status =  InstallIpa(path);



###Demo

######Show App List


![list](http://ww3.sinaimg.cn/large/62b50d84tw1ee7d69bdffj20hs0qo0v6.jpg)