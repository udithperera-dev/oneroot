/*
 * *
 *  * Created by Udith Perera on 12/21/23, 3:54 PM
 *  * Copyright (c) 2023 . All rights reserved.
 *  * Last modified 12/21/23, 3:54 PM
 *
 */

package com.akurupela.oneroot.core;

import static com.akurupela.oneroot.core.Const.BINARY_BUSYBOX;
import static com.akurupela.oneroot.core.Const.BINARY_SU;

import android.content.Context;
import android.content.pm.PackageManager;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Scanner;

public class OneRoot {
    private final Context mContext;
    private boolean loggingEnabled = true;

    public OneRoot(Context context) {
        mContext = context;
    }
    public boolean isRooted() {
        return detectRootManagementApps() || detectPotentiallyDangerousApps() || checkForBinary(BINARY_SU)
                || checkForBinary(BINARY_BUSYBOX) || checkForDangerousProps() || checkForRWPaths()
                || detectTestKeys() || checkSuExists() || checkForRootNative() || checkForMagiskBinary() || checkForMagiskNative();
    }
    public boolean detectTestKeys() {
        String buildTags = android.os.Build.TAGS;
        return buildTags != null && buildTags.contains("test-keys");
    }
    public boolean detectRootManagementApps() {
        return detectRootManagementApps(null);
    }

    public boolean detectRootManagementApps(String[] additionalRootManagementApps) {
        ArrayList<String> packages = new ArrayList<>(Arrays.asList(Const.knownRootAppsPackages));
        if (additionalRootManagementApps!=null && additionalRootManagementApps.length>0){
            packages.addAll(Arrays.asList(additionalRootManagementApps));
        }
        return isAnyPackageFromListInstalled(packages);
    }
    public boolean detectPotentiallyDangerousApps() {
        return detectPotentiallyDangerousApps(null);
    }

    public boolean detectPotentiallyDangerousApps(String[] additionalDangerousApps) {
        ArrayList<String> packages = new ArrayList<>();
        packages.addAll(Arrays.asList(Const.knownDangerousAppsPackages));
        if (additionalDangerousApps!=null && additionalDangerousApps.length>0){
            packages.addAll(Arrays.asList(additionalDangerousApps));
        }
        return isAnyPackageFromListInstalled(packages);
    }

    public boolean detectRootCloakingApps() {
        return detectRootCloakingApps(null) || canLoadNativeLibrary() && !checkForNativeLibraryReadAccess();
    }

    public boolean detectRootCloakingApps(String[] additionalRootCloakingApps) {
        ArrayList<String> packages = new ArrayList<>(Arrays.asList(Const.knownRootCloakingPackages));
        if (additionalRootCloakingApps!=null && additionalRootCloakingApps.length>0){
            packages.addAll(Arrays.asList(additionalRootCloakingApps));
        }
        return isAnyPackageFromListInstalled(packages);
    }
    public boolean checkForMagiskBinary(){ return checkForBinary("magisk"); }
    public boolean checkForBinary(String filename) {
        String[] pathsArray = Const.getPaths();
        boolean result = false;
        for (String path : pathsArray) {
            String completePath = path + filename;
            File f = new File(path, filename);
            boolean fileExists = f.exists();
            if (fileExists) {
                result = true;
            }
        }
        return result;
    }
    private String[] propsReader() {
        try {
            InputStream inputstream = Runtime.getRuntime().exec("getprop").getInputStream();
            if (inputstream == null) return null;
            String propVal = new Scanner(inputstream).useDelimiter("\\A").next();
            return propVal.split("\n");
        } catch (IOException | NoSuchElementException e) {
            return null;
        }
    }

    private String[] mountReader() {
        try {
            InputStream inputstream = Runtime.getRuntime().exec("mount").getInputStream();
            if (inputstream == null) return null;
            String propVal = new Scanner(inputstream).useDelimiter("\\A").next();
            return propVal.split("\n");
        } catch (IOException | NoSuchElementException e) {
            return null;
        }
    }

    private boolean isAnyPackageFromListInstalled(List<String> packages){
        boolean result = false;

        PackageManager pm = mContext.getPackageManager();

        for (String packageName : packages) {
            try {
                pm.getPackageInfo(packageName, 0);
                result = true;
            } catch (PackageManager.NameNotFoundException e) {}
        }

        return result;
    }

    public boolean checkForDangerousProps() {
        final Map<String, String> dangerousProps = new HashMap<>();
        dangerousProps.put("ro.debuggable", "1");
        dangerousProps.put("ro.secure", "0");
        boolean result = false;
        String[] lines = propsReader();
        if (lines == null){
            return false;
        }
        for (String line : lines) {
            for (String key : dangerousProps.keySet()) {
                if (line.contains(key)) {
                    String badValue = dangerousProps.get(key);
                    badValue = "[" + badValue + "]";
                    if (line.contains(badValue)) {
                        result = true;
                    }
                }
            }
        }
        return result;
    }
    public boolean checkForRWPaths() {
        boolean result = false;
        String[] lines = mountReader();
        if (lines == null){
            return false;
        }
        int sdkVersion = android.os.Build.VERSION.SDK_INT;
        for (String line : lines) {

            String[] args = line.split(" ");
            if ((sdkVersion <= android.os.Build.VERSION_CODES.M && args.length < 4)
                    || (sdkVersion > android.os.Build.VERSION_CODES.M && args.length < 6)) {
                continue;
            }

            String mountPoint;
            String mountOptions;

            if (sdkVersion > android.os.Build.VERSION_CODES.M) {
                mountPoint = args[2];
                mountOptions = args[5];
            } else {
                mountPoint = args[1];
                mountOptions = args[3];
            }

            for(String pathToCheck: Const.pathsThatShouldNotBeWritable) {
                if (mountPoint.equalsIgnoreCase(pathToCheck)) {
                        if (android.os.Build.VERSION.SDK_INT > android.os.Build.VERSION_CODES.M) {
                            mountOptions = mountOptions.replace("(", "");
                            mountOptions = mountOptions.replace(")", "");
                        }
                    for (String option : mountOptions.split(",")){
                        if (option.equalsIgnoreCase("rw")){
                            result = true;
                            break;
                        }
                    }
                }
            }
        }
        return result;
    }

    public boolean checkSuExists() {
        Process process = null;
        try {
            process = Runtime.getRuntime().exec(new String[] { "which", BINARY_SU });
            BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
            return in.readLine() != null;
        } catch (Throwable t) {
            return false;
        } finally {
            if (process != null) process.destroy();
        }
    }

    public boolean checkForNativeLibraryReadAccess() {
        Phaser rootBeerNative = new Phaser();
        try {
            rootBeerNative.setLogDebugMessages(loggingEnabled);
            return true;
        } catch (UnsatisfiedLinkError e) {
            return false;
        }
    }

    public boolean canLoadNativeLibrary(){
        return new Phaser().wasNativeLibraryLoaded();
    }

    public boolean checkForRootNative() {
        if (!canLoadNativeLibrary()){
            return false;
        }
        String[] paths = Const.getPaths();
        String[] checkPaths = new String[paths.length];
        for (int i = 0; i < checkPaths.length; i++) {
            checkPaths[i] = paths[i]+ BINARY_SU;
        }

        Phaser rootBeerNative = new Phaser();
        try {
            rootBeerNative.setLogDebugMessages(loggingEnabled);
            return rootBeerNative.checkForRoot(checkPaths) > 0;
        } catch (UnsatisfiedLinkError e) {
            return false;
        }
    }

    public boolean checkForMagiskNative() {
        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            if (!canLoadNativeLibrary()){
                return false;
            }
            Phaser phaser = new Phaser();
            try {
                phaser.setLogDebugMessages(loggingEnabled);
                return phaser.checkForMagiskUDS() > 0;
            } catch (UnsatisfiedLinkError e) {
                return false;
            }
        }else{
            return false;
        }
    }
}
