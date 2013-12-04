//
//  WizardViewController.m
//  linphone
//
//  Created by huyheo on 12/3/13.
//
//

#import "WizardViewController.h"
#import "linphonecore.h"
#import "LinphoneManager.h"
@interface WizardViewController ()

@end

@implementation WizardViewController
@synthesize userName, passWord, domainName;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clearProxyConfig {
	linphone_core_clear_proxy_config([LinphoneManager getLc]);
	linphone_core_clear_all_auth_info([LinphoneManager getLc]);
}
- (void)setDefaultSettings:(LinphoneProxyConfig*)proxyCfg {
    BOOL pushnotification = [[LinphoneManager instance] lpConfigBoolForKey:@" aapush_notification" forSection:@"wizard"];
    [[LinphoneManager instance] lpConfigSetBool:pushnotification forKey:@"pushnotification_preference"];
    if(pushnotification) {
        [[LinphoneManager instance] addPushTokenToProxyConfig:proxyCfg];
    }
    int expires = [[LinphoneManager instance] lpConfigIntForKey:@"expires" forSection:@"wizard"];
    linphone_proxy_config_expires(proxyCfg, expires);
    
    NSString* transport = [[LinphoneManager instance] lpConfigStringForKey:@"transport" forSection:@"wizard"];
    LinphoneCore *lc = [LinphoneManager getLc];
    LCSipTransports transportValue={0};
	if (transport!=nil) {
		if (linphone_core_get_sip_transports(lc, &transportValue)) {
			[LinphoneLogger logc:LinphoneLoggerError format:"cannot get current transport"];
		}
		// Only one port can be set at one time, the others's value is 0
		if ([transport isEqualToString:@"tcp"]) {
			transportValue.tcp_port=transportValue.tcp_port|transportValue.udp_port|transportValue.tls_port;
			transportValue.udp_port=0;
            transportValue.tls_port=0;
		} else if ([transport isEqualToString:@"udp"]){
			transportValue.udp_port=transportValue.tcp_port|transportValue.udp_port|transportValue.tls_port;
			transportValue.tcp_port=0;
            transportValue.tls_port=0;
		} else if ([transport isEqualToString:@"tls"]){
			transportValue.tls_port=transportValue.tcp_port|transportValue.udp_port|transportValue.tls_port;
			transportValue.tcp_port=0;
            transportValue.udp_port=0;
		} else {
			[LinphoneLogger logc:LinphoneLoggerError format:"unexpected transport [%s]",[transport cStringUsingEncoding:[NSString defaultCStringEncoding]]];
		}
		if (linphone_core_set_sip_transports(lc, &transportValue)) {
			[LinphoneLogger logc:LinphoneLoggerError format:"cannot set transport"];
		}
	}
    
    NSString* sharing_server = [[LinphoneManager instance] lpConfigStringForKey:@"sharing_server" forSection:@"wizard"];
    [[LinphoneManager instance] lpConfigSetString:sharing_server forKey:@"sharing_server_preference"];
    
    BOOL ice = [[LinphoneManager instance] lpConfigBoolForKey:@"ice" forSection:@"wizard"];
    [[LinphoneManager instance] lpConfigSetBool:ice forKey:@"ice_preference"];
    
    NSString* stun = [[LinphoneManager instance] lpConfigStringForKey:@"stun" forSection:@"wizard"];
    [[LinphoneManager instance] lpConfigSetString:stun forKey:@"stun_preference"];
    
    if ([stun length] > 0){
        linphone_core_set_stun_server(lc, [stun UTF8String]);
        if(ice) {
            linphone_core_set_firewall_policy(lc, LinphonePolicyUseIce);
        } else {
            linphone_core_set_firewall_policy(lc, LinphonePolicyUseStun);
        }
    } else {
        linphone_core_set_stun_server(lc, NULL);
        linphone_core_set_firewall_policy(lc, LinphonePolicyNoFirewall);
    }
}
- (void)addProxyConfig:(NSString*)username password:(NSString*)password domain:(NSString*)domain server:(NSString*)server {
    [self clearProxyConfig];
    if(server == nil) {
        server = domain;
    }
	LinphoneProxyConfig* proxyCfg = linphone_core_create_proxy_config([LinphoneManager getLc]);
    char normalizedUserName[256];
    LinphoneAddress* linphoneAddress = linphone_address_new("sip:user@domain.com");
    linphone_proxy_config_normalize_number(proxyCfg, [username cStringUsingEncoding:[NSString defaultCStringEncoding]], normalizedUserName, sizeof(normalizedUserName));
    linphone_address_set_username(linphoneAddress, normalizedUserName);
    linphone_address_set_domain(linphoneAddress, [domain UTF8String]);
    const char* identity = linphone_address_as_string_uri_only(linphoneAddress);
	linphone_proxy_config_set_identity(proxyCfg, identity);
	linphone_proxy_config_set_server_addr(proxyCfg, [server UTF8String]);
    LinphoneAuthInfo* info = linphone_auth_info_new([username UTF8String]
													, NULL, [password UTF8String]
													, NULL
													, NULL
													,linphone_proxy_config_get_domain(proxyCfg));
	
	if([server compare:domain options:NSCaseInsensitiveSearch] != NSOrderedSame) {
        linphone_proxy_config_set_route(proxyCfg, [server UTF8String]);
    }
    int defaultExpire = [[LinphoneManager instance] lpConfigIntForKey:@"default_expires"];
    if (defaultExpire >= 0)
        linphone_proxy_config_expires(proxyCfg, defaultExpire);
    if([domain compare:[[LinphoneManager instance] lpConfigStringForKey:@"domain" forSection:@"wizard"] options:NSCaseInsensitiveSearch] == 0) {
        [self setDefaultSettings:proxyCfg];
    }
    linphone_proxy_config_enable_register(proxyCfg, true);
    linphone_core_add_proxy_config([LinphoneManager getLc], proxyCfg);
	linphone_core_set_default_proxy([LinphoneManager getLc], proxyCfg);
	linphone_core_add_auth_info([LinphoneManager getLc], info);
}

- (IBAction)singin:(id)sender {
    
    
    NSMutableString *errors = [NSMutableString string];
    if ([self.userName.text length] == 0) {
        
        [errors appendString:[NSString stringWithFormat:NSLocalizedString(@"Please enter a username.\n", nil)]];
    }
    
    if ([self.domainName.text length] == 0) {
        [errors appendString:[NSString stringWithFormat:NSLocalizedString(@"Please enter a domain.\n", nil)]];
    }
    
    if([errors length]) {
        UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Check error(s)",nil)
                                                            message:[errors substringWithRange:NSMakeRange(0, [errors length] - 1)]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Continue",nil)
                                                  otherButtonTitles:nil,nil];
        [errorView show];
     
    } else {
   //     [self.waitView setHidden:false];
        [self addProxyConfig:self.userName.text password:self.passWord.text domain:self.domainName.text server:nil];
    }
}
@end
