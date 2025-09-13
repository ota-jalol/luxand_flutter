#include "include/luxand_flutter/luxand_flutter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "luxand_flutter_plugin.h"

void LuxandFlutterPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  luxand_flutter::LuxandFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}