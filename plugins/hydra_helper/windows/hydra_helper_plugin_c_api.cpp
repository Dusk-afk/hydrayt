#include "include/hydra_helper/hydra_helper_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "hydra_helper_plugin.h"

void HydraHelperPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  hydra_helper::HydraHelperPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
