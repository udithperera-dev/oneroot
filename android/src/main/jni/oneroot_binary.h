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

extern "C" {

#include <jni.h>

jint Java_com_akurupela_oneroot_android_OneRootNative_setLogDebugMessages( JNIEnv* env, jobject thiz, jboolean debug);

int Java_com_akurupela_oneroot_android_OneRootNative_checkForMagiskUDS( JNIEnv* env, jobject thiz );

int Java_com_akurupela_oneroot_android_OneRootNative_checkForRoot( JNIEnv* env, jobject thiz , jobjectArray pathsArray );

}
