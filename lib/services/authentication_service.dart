import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';

class AuthenticationService {
  dynamic zitadelIssuer;
  late String zitadelClientId;

  final String callbackUrlScheme = 'com.quoppo.golainApiTests';
  // final baseUri = Uri.base;
  late OidcUserManager userManager;

  AuthenticationService() {
    zitadelIssuer = Uri.parse(dotenv.env["ZITADEL_ENDPOINT"]!);
    zitadelClientId = dotenv.env["ZITADEL_CLIENT_ID"]!;
  }

  Future init() {
    var redirectUri = Uri(scheme: callbackUrlScheme, path: '/');
    // redirectUri = Uri(
    //   scheme: "com.quoppo.golainApiTests",
    //   path: '/',
    // );

    log(redirectUri.toString());
    userManager = OidcUserManager.lazy(
      discoveryDocumentUri:
          OidcUtils.getOpenIdConfigWellKnownUri(zitadelIssuer),
      clientCredentials:
          OidcClientAuthentication.none(clientId: zitadelClientId),
      store: OidcDefaultStore(),
      settings: OidcUserManagerSettings(
        redirectUri: redirectUri,
        // the same redirectUri can be used as for post logout too.
        postLogoutRedirectUri: redirectUri,
        scope: [
          'openid',
          'profile',
          'email',
          'offline_access',
          'urn:zitadel:iam:org:id:280098382616199173' //TODO: set env
        ],
      ),
    );
    return userManager.init();
  }

  Future login() async {
    try {
      final user = await userManager.loginAuthorizationCodeFlow();
      if (user == null) {
        //it wasn't possible to login the user.

        log("here issue");
        return null;
      } else {
        return user;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await userManager.logout();
    } catch (e) {}
  }
}
