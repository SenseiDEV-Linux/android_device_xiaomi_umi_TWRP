#
# Copyright (C) 2020 The TwrpBuilder Open-Source Project
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

# Configure base.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Configure core_64_bit_only.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Configure twrp
$(call inherit-product, vendor/twrp/config/common.mk)

PRODUCT_PACKAGES += \
    bootctrl.xiaomi_sm8250.recovery

# SHIPPING API
# LOAD-BEARING for decryption. ro.product.first_api_level in the recovery
# ramdisk comes from here, and it picks the whole crypto profile:
#   29 (Android 10, apollo's launch release) -> FBE v1 + legacy dm-default-key
#   30+                                      -> FBE v2 + v2 dm-default-key
# With 30 the recovery mounts /data with the v2 profile while the installed
# ROM uses v1/ice: vold hands the raw wrapped key blob to dm-default-key and
# it fails ("Invalid keysize"), so /data never mounts and /sdcard stays empty.
PRODUCT_SHIPPING_API_LEVEL := 29
PRODUCT_FIRST_API_LEVEL := 29

# VNDK API
PRODUCT_TARGET_VNDK_VERSION := 31

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

PRODUCT_USE_DYNAMIC_PARTITIONS := true

# otacert
PRODUCT_EXTRA_RECOVERY_KEYS += \
    $(DEVICE_PATH)/security/magisk \
    $(DEVICE_PATH)/security/miui_releasekey

PRODUCT_PROPERTY_OVERRIDES += ro.twrp.device.name=apollo

ifneq ($(TW_SKKK_VER_CODE),)
PRODUCT_PROPERTY_OVERRIDES += ro.twrp.version.skkk.code=$(TW_SKKK_VER_CODE)
endif

TWRP_REQUIRED_MODULES += miui_prebuilt \
    magisk_prebuilt \
    erofsfuse.recovery
