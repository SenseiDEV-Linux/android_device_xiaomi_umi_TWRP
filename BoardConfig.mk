#
# Copyright (C) 2019 The TwrpBuilder Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ALLOW_MISSING_DEPENDENCIES := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := kryo
TARGET_CPU_VARIANT_RUNTIME := kryo585

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := kryo
TARGET_2ND_CPU_VARIANT_RUNTIME := $(TARGET_CPU_VARIANT_RUNTIME)

TARGET_USES_64_BIT_BINDER := true

ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Bootloader
PRODUCT_PLATFORM := kona
TARGET_BOOTLOADER_BOARD_NAME := apollo
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Platform
TARGET_BOARD_PLATFORM := xiaomi_sm8250
TARGET_BOARD_PLATFORM_GPU := qcom-adreno650
QCOM_BOARD_PLATFORMS += xiaomi_sm8250

# Kernel
BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200n8 androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 androidboot.usbcontroller=a600000.dwc3 swiotlb=2048 loop.max_part=7 cgroup.memory=nokmem,nosocket reboot=panic_warm buildvariant=user
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
BOARD_BOOT_HEADER_VERSION := 2
BOARD_KERNEL_HEADER_VERSION := $(BOARD_BOOT_HEADER_VERSION)
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_BASE          := 0x00000000
BOARD_KERNEL_TAGS_OFFSET   := 0x00000100
BOARD_KERNEL_OFFSET        := 0x00008000
BOARD_KERNEL_SECOND_OFFSET := 0x00f00000
BOARD_RAMDISK_OFFSET       := 0x01000000
TARGET_KERNEL_ARCH := arm64
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/apollo/kernel

BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_KERNEL_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --second_offset $(BOARD_KERNEL_SECOND_OFFSET)

# Kenel dtb
# BOARD_INCLUDE_DTB_IN_BOOTIMG := true
INSTALLED_DTBIMAGE_TARGET := $(DEVICE_PATH)/prebuilt/apollo/dtb
BOARD_DTB_OFFSET := 0x01f00000
BOARD_MKBOOTIMG_ARGS += --dtb $(INSTALLED_DTBIMAGE_TARGET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)

# Kenel recovery dtbo
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_PREBUILT_RECOVERY_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/apollo/recovery_dtbo

# QCOM
#TARGET_USE_SDCLANG := true

# Assert
TARGET_OTA_ASSERT_DEVICE := apollo

# Avb
BOARD_AVB_ENABLE := true
BOARD_AVB_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Partitions
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 134217728

# Dynamic Partition
BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 9126805504
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := product vendor system system_ext odm

# System as root
BOARD_ROOT_EXTRA_FOLDERS := bluetooth dsp firmware persist
BOARD_SUPPRESS_SECURE_ERASE := true

# File systems
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Workaround for error copying vendor files to recovery ramdisk
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

#Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_apollo
TARGET_RECOVERY_DEVICE_MODULES := libinit_apollo
TARGET_PLATFORM_DEVICE_BASE := /devices/soc/

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"

# Crypto
BOARD_USES_QCOM_FBE_DECRYPTION := true
BOARD_USES_METADATA_PARTITION := true
ifdef DECRYPT_PLATFORM_VERSION
PLATFORM_VERSION := $(DECRYPT_PLATFORM_VERSION)
else
# NOTE: pinned to 99, NOT to the ROM's Android version. QTI keymaster binds
# key unwrapping to BOTH the OS version and the patchlevel tags: a recovery
# reporting a LOWER OS version than the installed ROM fails the metadata
# unwrap exactly like a patchlevel mismatch does (keys are re-bound on the
# first boot after every OTA). A far-future value always satisfies the check,
# so decryption survives ROM updates. Cosmetic side effect: the recovery
# reports Android release "99".
PLATFORM_VERSION := 99
endif
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
# Same reasoning as PLATFORM_VERSION: a far-future SPL always passes the
# keymaster version check, so decrypt does not break after every monthly
# security update. Harmless here - bootloader is unlocked, AVB rollback
# index is not enforced.
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
# Must match PRODUCT_SHIPPING_API_LEVEL := 29 in device.mk (FBE v1 / ice).
TW_USE_FSCRYPT_POLICY := 1

# Network
BUILD_BROKEN_USES_NETWORK := true

# Tool
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_LPDUMP := true
TW_INCLUDE_LPTOOLS := true
			     
# TWRP specific build flags
TW_THEME := portrait_hdpi
TW_DEVICE_VERSION := By Murtaza Kolachi
RECOVERY_SDCARD_ON_DATA := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXCLUDE_ENCRYPTED_BACKUPS := false
TW_EXTRA_LANGUAGES := true
TW_INCLUDE_NTFS_3G := true
TW_NO_EXFAT_FUSE := true
TW_USE_TOOLBOX := true
TW_INPUT_BLACKLIST := "hbtp_vm"

# --- Touch: folders opening by themselves while scrolling -------------------
# TWRP's minui keeps a SINGLE touch point: minuitwrp/events.cpp stores one
# mt_p.x/mt_p pair and has no ABS_MT_SLOT handling, so a second finger simply
# overwrites x/y. "Finger up" is inferred from the event stream, and two of
# those inferences fire spuriously mid-gesture:
#
#   * ABS_MT_TOUCH_MAJOR == 0 -> touchReleaseOnNextSynReport = 1
#     (events.cpp:554 case, 561 assign; guarded by TW_IGNORE_MAJOR_AXIS_0 at :557)
#   * ABS_MT_PRESSURE    == 0 -> touchReleaseOnNextSynReport = 1
#     (events.cpp:569 case, 575 assign; NOT guarded by anything in fox_12.1 -
#      see patches/optional-bootable_recovery-TW_IGNORE_MT_PRESSURE_0.patch)
#
# A panel that reports zero major/pressure while the finger is still down makes
# the GUI emit a fake TOUCH_RELEASE at the current position. GUIScrollList still
# has an item selected at that moment, so the folder under the finger opens.
#
# This flag only covers the TOUCH_MAJOR path. Which of the two the panel uses is
# visible in `getevent -lt` output - check before assuming the flag is enough.
#
# Release still works without this code path: the panel signals the real
# finger-up with ABS_MT_TRACKING_ID = -1, which sets
# touchReleaseOnNextSynReport = 2 (events.cpp:626) - a different branch.
# If taps ever stop registering, revert this one line.
TW_IGNORE_MAJOR_AXIS_0 := true

# Log every TOUCH_START/TOUCH_DRAG/TOUCH_RELEASE and the raw EV_ABS events to
# the recovery log. Keep this on until the touch behaviour is confirmed, then
# remove it - it is noisy. Read with:
#   adb shell cat /tmp/recovery.log | grep -E "TOUCH_|EV_ABS"
TW_EVENT_LOGGING := true
TWRP_EVENT_LOGGING := true
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_MAX_BRIGHTNESS := 2047
TW_DEFAULT_BRIGHTNESS := 300
TW_STATUS_ICONS_ALIGN := center
TW_CUSTOM_CPU_POS := 172
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
TW_NO_SCREEN_BLANK := true
TW_HAS_EDL_MODE := false
TW_SUPPORT_INPUT_AIDL_HAPTICS :=true
TW_BACKUP_EXCLUSIONS := /data/fonts,/data/adb/ap,/data/adb/ksu
