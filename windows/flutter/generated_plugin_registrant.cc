//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <firebase_core/firebase_core_plugin_c_api.h>
#include <tencent_cloud_chat_sdk/tencent_cloud_chat_sdk_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
  TencentCloudChatSdkPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("TencentCloudChatSdkPluginCApi"));
}
