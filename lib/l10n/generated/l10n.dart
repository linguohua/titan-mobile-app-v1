// ignore_for_file: non_constant_identifier_names, use_super_parameters, unnecessary_string_escapes
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_zh.dart';

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @welcome_to_titan.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Titan'**
  String get welcome_to_titan;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forgotten password'**
  String get forget_password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Email code'**
  String get email_verification_code;

  /// No description provided for @sender_decoder.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sender_decoder;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @set_password.
  ///
  /// In en, this message translates to:
  /// **'Set a password'**
  String get set_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirm_password;

  /// No description provided for @invitation_code.
  ///
  /// In en, this message translates to:
  /// **'Invitation Code (optional)'**
  String get invitation_code;

  /// No description provided for @login_entry.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Click to login'**
  String get login_entry;

  /// No description provided for @register_entry.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet? Click to register'**
  String get register_entry;

  /// No description provided for @confirm_modification.
  ///
  /// In en, this message translates to:
  /// **'Confirm to change'**
  String get confirm_modification;

  /// No description provided for @privacy_policy_1.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to'**
  String get privacy_policy_1;

  /// No description provided for @privacy_policy_2.
  ///
  /// In en, this message translates to:
  /// **'《Titan\'s Use Agreement》'**
  String get privacy_policy_2;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Agreement'**
  String get privacy_policy;

  /// No description provided for @verification_drag_tip.
  ///
  /// In en, this message translates to:
  /// **'Please press and hold the slider and drag it to the far right'**
  String get verification_drag_tip;

  /// No description provided for @usage_protocol.
  ///
  /// In en, this message translates to:
  /// **'Utilization Agreement'**
  String get usage_protocol;

  /// No description provided for @privacy_content.
  ///
  /// In en, this message translates to:
  /// **'We would like to remind you (the User) that before registering as a User, please read this User Registration and Use of App Privacy Agreement (hereinafter referred to as the \"Agreement\") carefully to ensure that you fully understand the terms and conditions of this Agreement. Please read it carefully and choose to accept or not accept this Agreement. Unless you accept all the terms and conditions of this Agreement, you are not authorized to register, log in or use the services covered by this Agreement. Your registration, login, use and other behavior will be regarded as the acceptance of this Agreement, and agree to be bound by the terms of this Agreement. This Agreement governs the rights and obligations of Lazhong Yun (Beijing) Network Co., Ltd (hereinafter referred to as \"Lawyer to the\") and the User with respect to the Lawyer to the software services (hereinafter referred to as \"Services\"). The User is the individual or organization that registers, logs in, and uses the Service. This Agreement may be updated by Lawyer to Lawyer at any time, and the updated Terms of Agreement will replace the original Terms of Agreement once published without further notice, and the User may review the latest version of the Terms of Agreement in the App. After the modification of the terms of the agreement, if the user does not accept the modified terms, please immediately stop using the services provided by the lawyer to the user to continue to use the services provided by the lawyer to the user will be deemed to accept the   a, account registration 1, the user needs to register a lawyer to the App account before using this service. Lawyer to the App account should use a cell phone number, or lawyer to the binding registration, please use the user has not yet with the lawyer to the App account binding cell phone number, as well as has not been lawyer to the blocked cell phone number under this agreement to register lawyer to the App account. Lawyer to the can according to the user demand or product needs to account registration and binding of the way to change, without prior notice to the user.     2, in view of the lawyer to the app account binding registration method, you agree to the lawyer to the registration will allow your cell phone number and mobile device identification code and other information for registration.'**
  String get privacy_content;

  /// No description provided for @today_earnings.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Est. Rewards'**
  String get today_earnings;

  /// No description provided for @ttn.
  ///
  /// In en, this message translates to:
  /// **'TTN'**
  String get ttn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @current_device_ID.
  ///
  /// In en, this message translates to:
  /// **'Current Device ID'**
  String get current_device_ID;

  /// No description provided for @stop_earning_coins.
  ///
  /// In en, this message translates to:
  /// **'Stop Earning'**
  String get stop_earning_coins;

  /// No description provided for @start_earning_coins.
  ///
  /// In en, this message translates to:
  /// **'Start Earning'**
  String get start_earning_coins;

  /// No description provided for @view_earnings_details.
  ///
  /// In en, this message translates to:
  /// **'View reward details'**
  String get view_earnings_details;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing'**
  String get initializing;

  /// No description provided for @starting.
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get starting;

  /// No description provided for @stopping.
  ///
  /// In en, this message translates to:
  /// **'Stopping'**
  String get stopping;

  /// No description provided for @to_update.
  ///
  /// In en, this message translates to:
  /// **'to upgrade'**
  String get to_update;

  /// No description provided for @new_version.
  ///
  /// In en, this message translates to:
  /// **'found new version'**
  String get new_version;

  /// No description provided for @tab_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tab_home;

  /// No description provided for @tab_wallet.
  ///
  /// In en, this message translates to:
  /// **'wallet'**
  String get tab_wallet;

  /// No description provided for @tab_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tab_history;

  /// No description provided for @tab_setting.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tab_setting;

  /// No description provided for @setting_huygens_testnet.
  ///
  /// In en, this message translates to:
  /// **'Huygens Testnet'**
  String get setting_huygens_testnet;

  /// No description provided for @about_titan.
  ///
  /// In en, this message translates to:
  /// **'About Titan'**
  String get about_titan;

  /// No description provided for @login_account.
  ///
  /// In en, this message translates to:
  /// **'Login account'**
  String get login_account;

  /// No description provided for @wallet_address.
  ///
  /// In en, this message translates to:
  /// **'Wallet Address'**
  String get wallet_address;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @setting_change_language.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get setting_change_language;

  /// No description provided for @setting_language_zh.
  ///
  /// In en, this message translates to:
  /// **'ZH'**
  String get setting_language_zh;

  /// No description provided for @setting_language_en.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get setting_language_en;

  /// No description provided for @setting_twitter.
  ///
  /// In en, this message translates to:
  /// **'Twitter'**
  String get setting_twitter;

  /// No description provided for @setting_discord.
  ///
  /// In en, this message translates to:
  /// **'Discord'**
  String get setting_discord;

  /// No description provided for @setting_telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get setting_telegram;

  /// No description provided for @setting_about_titan.
  ///
  /// In en, this message translates to:
  /// **'About Titan Network'**
  String get setting_about_titan;

  /// No description provided for @setting_official_site.
  ///
  /// In en, this message translates to:
  /// **'Official Site'**
  String get setting_official_site;

  /// No description provided for @setting_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get setting_version;

  /// No description provided for @setting_automatic_updates.
  ///
  /// In en, this message translates to:
  /// **'Automatic Updates'**
  String get setting_automatic_updates;

  /// No description provided for @setting_up_to_date.
  ///
  /// In en, this message translates to:
  /// **'You are up to date'**
  String get setting_up_to_date;

  /// No description provided for @setting_update_now.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get setting_update_now;

  /// No description provided for @setting_update_info_1.
  ///
  /// In en, this message translates to:
  /// **'Dear User,\nThis update provides important bug fixes and security updates which include {version}, and we recommend all users to update as soon as possible.'**
  String setting_update_info_1(Object version);

  /// No description provided for @setting_update_info_2.
  ///
  /// In en, this message translates to:
  /// **'For information on the security content of Titan Network software updates, please visit the following website:'**
  String get setting_update_info_2;

  /// No description provided for @history_title.
  ///
  /// In en, this message translates to:
  /// **'Node Records'**
  String get history_title;

  /// No description provided for @history_status.
  ///
  /// In en, this message translates to:
  /// **'Status：'**
  String get history_status;

  /// No description provided for @history_environment.
  ///
  /// In en, this message translates to:
  /// **'Environment：'**
  String get history_environment;

  /// No description provided for @history_time.
  ///
  /// In en, this message translates to:
  /// **'Time：'**
  String get history_time;

  /// No description provided for @wallet_get_identity_title.
  ///
  /// In en, this message translates to:
  /// **'01.Request an Identity Code'**
  String get wallet_get_identity_title;

  /// No description provided for @wallet_get_identity_desc.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Titan Network! Please request an identity code for you device, and claim your rewards after binding the code.'**
  String get wallet_get_identity_desc;

  /// No description provided for @wallet_get_identity_button.
  ///
  /// In en, this message translates to:
  /// **'Request an Identity Code'**
  String get wallet_get_identity_button;

  /// No description provided for @wallet_input_identity_title.
  ///
  /// In en, this message translates to:
  /// **'02.Enter Your Identity Code'**
  String get wallet_input_identity_title;

  /// No description provided for @wallet_input_identity_desc.
  ///
  /// In en, this message translates to:
  /// **'Please bind your identity code asap to avoid losing rewards.'**
  String get wallet_input_identity_desc;

  /// No description provided for @wallet_input_identity_button.
  ///
  /// In en, this message translates to:
  /// **'Bind Your Identity Code'**
  String get wallet_input_identity_button;

  /// No description provided for @wallet_verify_information.
  ///
  /// In en, this message translates to:
  /// **'Verify Information'**
  String get wallet_verify_information;

  /// No description provided for @wallet_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get wallet_account;

  /// No description provided for @wallet_email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get wallet_email_address;

  /// No description provided for @wallet_wallet_address.
  ///
  /// In en, this message translates to:
  /// **'Wallet Address'**
  String get wallet_wallet_address;

  /// No description provided for @wallet_confirm_bind.
  ///
  /// In en, this message translates to:
  /// **'Confirm to bind'**
  String get wallet_confirm_bind;

  /// No description provided for @wallet_bound.
  ///
  /// In en, this message translates to:
  /// **'Bound'**
  String get wallet_bound;

  /// No description provided for @wallet_user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get wallet_user;

  /// No description provided for @wallet_device_management.
  ///
  /// In en, this message translates to:
  /// **'Device Management'**
  String get wallet_device_management;

  /// No description provided for @error_device_has_bound.
  ///
  /// In en, this message translates to:
  /// **'Device Already Bound'**
  String get error_device_has_bound;

  /// No description provided for @error_signature.
  ///
  /// In en, this message translates to:
  /// **'Invalid Signature'**
  String get error_signature;

  /// No description provided for @error_parameter.
  ///
  /// In en, this message translates to:
  /// **'Invalid Parameters'**
  String get error_parameter;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown Error'**
  String get error_unknown;

  /// No description provided for @error_invalid_token.
  ///
  /// In en, this message translates to:
  /// **'Invalid identity code'**
  String get error_invalid_token;

  /// No description provided for @error_network.
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get error_network;

  /// No description provided for @error_token_has_bound.
  ///
  /// In en, this message translates to:
  /// **'Identity code has been used'**
  String get error_token_has_bound;

  /// No description provided for @error_node_not_exists.
  ///
  /// In en, this message translates to:
  /// **'The node is not logged in'**
  String get error_node_not_exists;

  /// No description provided for @error_input_empty.
  ///
  /// In en, this message translates to:
  /// **'input should not be empty'**
  String get error_input_empty;

  /// No description provided for @error_identity_format_invalid.
  ///
  /// In en, this message translates to:
  /// **'identity\'s format is invalid'**
  String get error_identity_format_invalid;

  /// No description provided for @failed_stop.
  ///
  /// In en, this message translates to:
  /// **'Failed to Stop'**
  String get failed_stop;

  /// No description provided for @failed_start.
  ///
  /// In en, this message translates to:
  /// **'Startup failed'**
  String get failed_start;

  /// No description provided for @failed_bind.
  ///
  /// In en, this message translates to:
  /// **'Bind failed'**
  String get failed_bind;

  /// No description provided for @belongs.
  ///
  /// In en, this message translates to:
  /// **'Titan Account related to identity code'**
  String get belongs;

  /// No description provided for @bound.
  ///
  /// In en, this message translates to:
  /// **'Bound'**
  String get bound;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @download_progress.
  ///
  /// In en, this message translates to:
  /// **'Download progress'**
  String get download_progress;

  /// No description provided for @download_installation_package.
  ///
  /// In en, this message translates to:
  /// **'Downloading installation package'**
  String get download_installation_package;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'zh':
      return SZh();
  }

  throw FlutterError(
      'S.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
