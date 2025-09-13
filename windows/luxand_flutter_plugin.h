#ifndef FLUTTER_PLUGIN_LUXAND_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_LUXAND_FLUTTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <memory>
#include <map>

namespace luxand_flutter {

class LuxandFlutterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  LuxandFlutterPlugin();

  virtual ~LuxandFlutterPlugin();

  // Disallow copy and assign.
  LuxandFlutterPlugin(const LuxandFlutterPlugin&) = delete;
  LuxandFlutterPlugin& operator=(const LuxandFlutterPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  // Map to store template handles
  std::map<int, int> template_handles_;
  int next_template_id_;
  bool sdk_initialized_;
  bool sdk_activated_;
};

}  // namespace luxand_flutter

#endif  // FLUTTER_PLUGIN_LUXAND_FLUTTER_PLUGIN_H_