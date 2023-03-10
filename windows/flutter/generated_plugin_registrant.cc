//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <connectivity_plus/connectivity_plus_windows_plugin.h>
#include <desktop_webview_auth/desktop_webview_auth_plugin.h>
#include <flutter_js/flutter_js_plugin.h>
#include <geolocator_windows/geolocator_windows.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  DesktopWebviewAuthPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopWebviewAuthPlugin"));
  FlutterJsPluginRegisterWithRegistrar(
        registry->GetRegistrarForPlugin("FlutterJsPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
        registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  GeolocatorWindowsRegisterWithRegistrar(
        registry->GetRegistrarForPlugin("GeolocatorWindows"));
}
