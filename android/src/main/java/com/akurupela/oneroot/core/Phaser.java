/*
 * *
 *  * Created by Udith Perera on 12/21/23, 3:54 PM
 *  * Copyright (c) 2023 . All rights reserved.
 *  * Last modified 12/21/23, 3:54 PM
 *
 */

package com.akurupela.oneroot.core;

public class Phaser {
    private static boolean libraryLoaded = false;
    static {
        try {
            System.loadLibrary("oneroot_binary");
            libraryLoaded = true;
        } catch (UnsatisfiedLinkError e) {}
    }

    public boolean wasNativeLibraryLoaded() {
        return libraryLoaded;
    }

    public native int checkForMagiskUDS();
    public native int checkForRoot(Object[] pathArray);

    public native int setLogDebugMessages(boolean logDebugMessages);
}
