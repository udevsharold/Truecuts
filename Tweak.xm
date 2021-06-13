%group ShortcutsGroup
@interface WFTrigger : NSObject
+(BOOL)isAllowedToRunAutomatically;
@end

%hook WFTrigger
+(BOOL)isAllowedToRunAutomatically {
    return YES;
}
%end

@interface WFSharingSettings : NSObject
+(BOOL)shortcutFileSharingEnabled;
@end

%hook WFSharingSettings
+(BOOL)shortcutFileSharingEnabled {
    return YES;
}
%end
%end //ShortcutsGroup

%group AutomationNotificationGroup
%hook VCUserNotificationManager
-(BOOL)_postNotificationOfType:(unsigned long long)arg1 forTrigger:(id)arg2 workflowReference:(id)arg3 removeDeliveredNotifications:(BOOL)arg4 pendingTriggerEventIDs:(id)arg5 actionIcons:(id)arg6 error:(id*)arg7{    return YES;
}
%end
%end //AutomationNotificationGroup

%ctor {
    @autoreleasepool {
        NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
        
        if (args.count != 0) {
            NSString *executablePath = args[0];
            
            if (executablePath) {
                NSString *processName = [executablePath lastPathComponent];
                if ([processName isEqualToString:@"siriactionsd"]){
                    %init(AutomationNotificationGroup);
                }else{
                    %init(ShortcutsGroup);
                }
            }
        }
    }
}
