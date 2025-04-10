%hook UIKeyboardImpl

- (void)handleKeyboardInput:(id)arg1 {
    NSLog(@"[SwipeInputTweak] Keyboard input detected: %@", arg1);
    %orig;
}

%end
