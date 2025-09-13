#include "luxand_flutter_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>
#include <string>

// Luxand SDK headers (these would need to be provided by the Luxand SDK)
// #include "luxand/LuxandFaceSDK.h"

namespace luxand_flutter {

// Static.
void LuxandFlutterPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "luxand_flutter",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<LuxandFlutterPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

LuxandFlutterPlugin::LuxandFlutterPlugin() : next_template_id_(1), sdk_initialized_(false), sdk_activated_(false) {}

LuxandFlutterPlugin::~LuxandFlutterPlugin() {
  // Cleanup any remaining templates
  template_handles_.clear();
  
  // Finalize SDK if it was initialized
  if (sdk_initialized_) {
    // FSDK_Finalize(); // Uncomment when Luxand SDK is available
  }
}

void LuxandFlutterPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  
  const std::string& method = method_call.method_name();
  
  if (method.compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows " << GetVersion();
    result->Success(flutter::EncodableValue(version_stream.str()));
  }
  else if (method.compare("initialize") == 0) {
    // Initialize Luxand SDK
    // int init_result = FSDK_Initialize(); // Uncomment when Luxand SDK is available
    
    // For now, simulate successful initialization
    int init_result = 0; // FSDKE_OK
    
    if (init_result == 0) { // FSDKE_OK
      sdk_initialized_ = true;
      result->Success(flutter::EncodableValue(true));
    } else {
      result->Success(flutter::EncodableValue(false));
    }
  }
  else if (method.compare("activate") == 0) {
    if (!sdk_initialized_) {
      result->Success(flutter::EncodableValue(false));
      return;
    }
    
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto license_key_it = arguments->find(flutter::EncodableValue("licenseKey"));
      if (license_key_it != arguments->end()) {
        const std::string license_key = std::get<std::string>(license_key_it->second);
        
        // Activate Luxand SDK with license key
        // int activate_result = FSDK_ActivateLibrary(license_key.c_str()); // Uncomment when Luxand SDK is available
        
        // For now, simulate successful activation
        int activate_result = 0; // FSDKE_OK
        
        if (activate_result == 0) { // FSDKE_OK
          sdk_activated_ = true;
          result->Success(flutter::EncodableValue(true));
        } else {
          result->Success(flutter::EncodableValue(false));
        }
      } else {
        result->Success(flutter::EncodableValue(false));
      }
    } else {
      result->Success(flutter::EncodableValue(false));
    }
  }
  else if (method.compare("loadTemplate") == 0) {
    if (!sdk_activated_) {
      result->Success(flutter::EncodableValue(-1));
      return;
    }
    
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto template_path_it = arguments->find(flutter::EncodableValue("templatePath"));
      if (template_path_it != arguments->end()) {
        const std::string template_path = std::get<std::string>(template_path_it->second);
        
        // Load template from file
        // FSDK_FACETEMPLATE template;
        // int load_result = FSDK_LoadFaceTemplateFromFile(&template, template_path.c_str()); // Uncomment when Luxand SDK is available
        
        // For now, simulate successful template loading
        int load_result = 0; // FSDKE_OK
        
        if (load_result == 0) { // FSDKE_OK
          int template_id = next_template_id_++;
          template_handles_[template_id] = 0; // Store template handle (placeholder)
          result->Success(flutter::EncodableValue(template_id));
        } else {
          result->Success(flutter::EncodableValue(-1));
        }
      } else {
        result->Success(flutter::EncodableValue(-1));
      }
    } else {
      result->Success(flutter::EncodableValue(-1));
    }
  }
  else if (method.compare("saveTemplate") == 0) {
    if (!sdk_activated_) {
      result->Success(flutter::EncodableValue(false));
      return;
    }
    
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto template_id_it = arguments->find(flutter::EncodableValue("templateId"));
      auto template_path_it = arguments->find(flutter::EncodableValue("templatePath"));
      
      if (template_id_it != arguments->end() && template_path_it != arguments->end()) {
        const int template_id = std::get<int>(template_id_it->second);
        const std::string template_path = std::get<std::string>(template_path_it->second);
        
        if (template_handles_.find(template_id) != template_handles_.end()) {
          // Save template to file
          // int save_result = FSDK_SaveFaceTemplateToFile(template_handles_[template_id], template_path.c_str()); // Uncomment when Luxand SDK is available
          
          // For now, simulate successful template saving
          int save_result = 0; // FSDKE_OK
          
          result->Success(flutter::EncodableValue(save_result == 0));
        } else {
          result->Success(flutter::EncodableValue(false));
        }
      } else {
        result->Success(flutter::EncodableValue(false));
      }
    } else {
      result->Success(flutter::EncodableValue(false));
    }
  }
  else if (method.compare("extractTemplate") == 0) {
    if (!sdk_activated_) {
      result->Success(flutter::EncodableValue(-1));
      return;
    }
    
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto image_path_it = arguments->find(flutter::EncodableValue("imagePath"));
      if (image_path_it != arguments->end()) {
        const std::string image_path = std::get<std::string>(image_path_it->second);
        
        // Extract face template from image
        // FSDK_FACETEMPLATE template;
        // int extract_result = FSDK_ExtractFaceTemplateFromFile(image_path.c_str(), &template); // Uncomment when Luxand SDK is available
        
        // For now, simulate successful template extraction
        int extract_result = 0; // FSDKE_OK
        
        if (extract_result == 0) { // FSDKE_OK
          int template_id = next_template_id_++;
          template_handles_[template_id] = 0; // Store template handle (placeholder)
          result->Success(flutter::EncodableValue(template_id));
        } else {
          result->Success(flutter::EncodableValue(-1));
        }
      } else {
        result->Success(flutter::EncodableValue(-1));
      }
    } else {
      result->Success(flutter::EncodableValue(-1));
    }
  }
  else if (method.compare("compareTemplates") == 0) {
    if (!sdk_activated_) {
      result->Success(flutter::EncodableValue(-1.0));
      return;
    }
    
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto template1_it = arguments->find(flutter::EncodableValue("template1"));
      auto template2_it = arguments->find(flutter::EncodableValue("template2"));
      
      if (template1_it != arguments->end() && template2_it != arguments->end()) {
        const int template1_id = std::get<int>(template1_it->second);
        const int template2_id = std::get<int>(template2_it->second);
        
        if (template_handles_.find(template1_id) != template_handles_.end() &&
            template_handles_.find(template2_id) != template_handles_.end()) {
          
          // Compare templates
          // float similarity;
          // int compare_result = FSDK_MatchFaceTemplates(template_handles_[template1_id], template_handles_[template2_id], &similarity); // Uncomment when Luxand SDK is available
          
          // For now, simulate template comparison
          int compare_result = 0; // FSDKE_OK
          float similarity = 0.85f; // Mock similarity value
          
          if (compare_result == 0) { // FSDKE_OK
            result->Success(flutter::EncodableValue(static_cast<double>(similarity)));
          } else {
            result->Success(flutter::EncodableValue(-1.0));
          }
        } else {
          result->Success(flutter::EncodableValue(-1.0));
        }
      } else {
        result->Success(flutter::EncodableValue(-1.0));
      }
    } else {
      result->Success(flutter::EncodableValue(-1.0));
    }
  }
  else if (method.compare("freeTemplate") == 0) {
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto template_id_it = arguments->find(flutter::EncodableValue("templateId"));
      if (template_id_it != arguments->end()) {
        const int template_id = std::get<int>(template_id_it->second);
        
        if (template_handles_.find(template_id) != template_handles_.end()) {
          // Free template
          // FSDK_FreeFaceTemplate(template_handles_[template_id]); // Uncomment when Luxand SDK is available
          
          template_handles_.erase(template_id);
          result->Success(flutter::EncodableValue(true));
        } else {
          result->Success(flutter::EncodableValue(false));
        }
      } else {
        result->Success(flutter::EncodableValue(false));
      }
    } else {
      result->Success(flutter::EncodableValue(false));
    }
  }
  else if (method.compare("finalize") == 0) {
    if (sdk_initialized_) {
      // Clean up all templates
      template_handles_.clear();
      
      // Finalize SDK
      // FSDK_Finalize(); // Uncomment when Luxand SDK is available
      
      sdk_initialized_ = false;
      sdk_activated_ = false;
      result->Success(flutter::EncodableValue(true));
    } else {
      result->Success(flutter::EncodableValue(false));
    }
  }
  else {
    result->NotImplemented();
  }
}