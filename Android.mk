LOCAL_PATH := $(call my-dir)

pigz_src_files := pigz.c try.c yarn.c
zopfli_src_files := zopfli/src/zopfli/blocksplitter.c \
					zopfli/src/zopfli/cache.c \
					zopfli/src/zopfli/deflate.c \
					zopfli/src/zopfli/tree.c \
					zopfli/src/zopfli/lz77.c \
					zopfli/src/zopfli/hash.c \
					zopfli/src/zopfli/util.c \
					zopfli/src/zopfli/squeeze.c \
					zopfli/src/zopfli/katajainen.c
pigz_cflags := -Wno-unused-variable -Wno-unused-parameter

include $(CLEAR_VARS)
LOCAL_MODULE := libzopfli_static
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(zopfli_src_files)
LOCAL_C_INCLUDES := $(LOCAL_PATH) external/zlib external/pigz/zopfli/src/zopfli
LOCAL_CFLAGS := $(pigz_cflags)
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libminipigz_static
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(pigz_src_files)
LOCAL_C_INCLUDES := $(LOCAL_PATH) external/zlib external/pigz/zopfli
LOCAL_CFLAGS := -Dmain=pigz_main $(pigz_cflags)
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := pigz
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(pigz_src_files)
LOCAL_STATIC_LIBRARIES := libzopfli_static
LOCAL_SHARED_LIBRARIES := libz
LOCAL_C_INCLUDES := $(LOCAL_PATH) external/zlib external/pigz/zopfli/src/zopfli
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)

PIGZ_TOOLS := unpigz gzip gunzip zcat
LOCAL_POST_INSTALL_CMD := $(hide) $(foreach t,$(PIGZ_TOOLS),ln -sf pigz $(TARGET_OUT)/xbin/$(t);)
LOCAL_CFLAGS := $(pigz_cflags)

include $(BUILD_EXECUTABLE)
