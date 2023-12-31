/*
 * *
 *  * Created by Udith Perera on 12/21/23, 1:57 PM
 *  * Copyright (c) 2023 . All rights reserved.
 *  * Last modified 12/21/23, 1:57 PM
 *  * Web : www.akurupela.com
 *  * Email : info@akurupela.com
 *  * Description : Root checking JNI NDK code
 *
 */

#include <jni.h>
#include <android/log.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <pwd.h>
#include <grp.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/un.h>
#include "oneroot_binary.h"
#define  LOG_TAG    "OneRoot:"
#define  LOGD(...)  if (DEBUG) __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__);
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__);

#define BUFSIZE 1024

static int DEBUG = 1;

extern "C"
jint Java_com_akurupela_oneroot_core_Phaser_setLogDebugMessages(JNIEnv* env, jobject thiz, jboolean debug)
{
  if (debug){
    DEBUG = 1;
  }
  else{
    DEBUG = 0;
  }

  return 0;
}

int exists(const char *fname)
{
    FILE *file;
    if ((file = fopen(fname, "r")))
    {
        LOGD("LOOKING FOR BINARY: %s PRESENT!!!",fname);
        fclose(file);
        return 1;
    }
    LOGD("LOOKING FOR BINARY: %s Absent :(",fname);
    return 0;
}

void strmode(mode_t mode, char * buf) {
    const char chars[] = "rwxrwxrwx";

    for (size_t i = 0; i < 9; i++) {
        buf[i] = (mode & (1 << (8-i))) ? chars[i] : '-';
    }

    buf[9] = '\0';
}

extern int stat(const char *, struct stat *);
int checkFileStat(const char *fname)
{
    struct stat file_info = { 0 };
    mode_t file_mode;

    if(!fname)
    {
        return 0;
    }

    if (stat(fname, &file_info) == -1)
    {
        return -1;
    }

    file_mode = file_info.st_mode;
    LOGD(">>>>> File Name : %s\n", fname);
    printf(">>>>> =======================================\n");
    LOGD(">>>>> File Type : ");
    if (S_ISREG(file_mode))
    {
        LOGD(">>>>> Regular File\n");
    }
    else if (S_ISLNK(file_mode))
    {
        LOGD(">>>>> Symbolic Link\n");
    }
    else if (S_ISDIR(file_mode))
    {
        LOGD(">>>>> Directory\n");
    }
    else if (S_ISCHR(file_mode))
    {
        LOGD(">>>>> Terminal Device\n");
    }
    else if (S_ISBLK(file_mode))
    {
        LOGD(">>>>> Block Device\n");
    }
    else if (S_ISFIFO(file_mode))
    {
        LOGD(">>>>> FIFO\n");
    }
    else if (S_ISSOCK(file_mode))
    {
        LOGD(">>>>> Socket\n");
    }
    return 1;
}

extern "C"
int Java_com_akurupela_oneroot_core_Phaser_checkForMagiskUDS(JNIEnv* env, jobject thiz )
{
    int uds_detect_count = 0;
    int magisk_file_detect_count = 0;
    int result = 0;
    FILE *fh = fopen("/proc/net/unix", "r");
    if (fh) {
        for (;;) {
            char filename[BUFSIZE] = {0};
            uint32_t a, b, c, d, e, f, g;
            int count = fscanf(fh, "%x: %u %u %u %u %u %u ",
                               &a, &b, &c, &d, &e, &f, &g);
            if (count == 0) {
                if (!fgets(filename, BUFSIZE, fh)) {
                    break;
                }
                continue;
            } else if (count == -1) {
                break;
            } else if (!fgets(filename, BUFSIZE, fh)) {
                break;
            }

            LOGD("%s", filename);

            magisk_file_detect_count += checkFileStat("/dev/.magisk.unblock");

            magisk_file_detect_count += checkFileStat("/sbin/magiskinit");
            magisk_file_detect_count += checkFileStat("/sbin/magisk");
            magisk_file_detect_count += checkFileStat("/sbin/.magisk");

            magisk_file_detect_count += checkFileStat("/data/adb/magisk.img");
            magisk_file_detect_count += checkFileStat("/data/adb/magisk.db");
            magisk_file_detect_count += checkFileStat("/data/adb/.boot_count");
            magisk_file_detect_count += checkFileStat("/data/adb/magisk_simple");
            magisk_file_detect_count += checkFileStat("/data/adb/magisk");

            magisk_file_detect_count += checkFileStat("/cache/.disable_magisk");
            magisk_file_detect_count += checkFileStat("/cache/magisk.log");

            magisk_file_detect_count += checkFileStat("/init.magisk.rc");

            char *ptr = strtok(filename, "@");
            if(ptr) {
                if(strstr(ptr, "/")) {
                    ;
                } else if(strstr(ptr, " ")) {
                    ;
                } else if(strstr(ptr, ".")) {
                    ;
                } else {
                    int len = strlen(ptr);
                    if (len >= 32) {
                        LOGD("[Detect Magisk UnixDomainSocket] %s", ptr);

                        uds_detect_count++;
                    }
                }
            }
        }
        fclose(fh);
    }
    if(uds_detect_count == 0 && magisk_file_detect_count == 0) {
        result = 0;
    } else {
        result = 1;
    }
    return result;
}

extern "C"

int Java_com_akurupela_oneroot_core_Phaser_checkForRoot(JNIEnv* env, jobject thiz, jobjectArray pathsArray ) {
    int binariesFound = 0;
    int stringCount = (env)->GetArrayLength(pathsArray);

    for (int i = 0; i < stringCount; i++) {
        jstring string = (jstring) (env)->GetObjectArrayElement(pathsArray, i);
        const char *pathString = (env)->GetStringUTFChars(string, 0);

        binariesFound += exists(pathString);

        (env)->ReleaseStringUTFChars(string, pathString);
    }

    return binariesFound>0;
}
