// ignore_for_file: non_constant_identifier_names, use_super_parameters, unnecessary_string_escapes

import 'l10n.dart';

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get welcome_to_titan => 'Welcome to Titan';

  @override
  String get forget_password => 'Forgotten password';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email_verification_code => 'Email code';

  @override
  String get sender_decoder => 'Send code';

  @override
  String get sent => 'Sent';

  @override
  String get password => 'Password';

  @override
  String get set_password => 'Set a password';

  @override
  String get confirm_password => 'Confirm password';

  @override
  String get invitation_code => 'Invitation Code (optional)';

  @override
  String get login_entry => 'Already have an account? Click to login';

  @override
  String get register_entry => 'Don\'t have an account yet? Click to register';

  @override
  String get confirm_modification => 'Confirm to change';

  @override
  String get privacy_policy_1 => 'I have read and agree to';

  @override
  String get privacy_policy_2 => '《Titan\'s Use Agreement》';

  @override
  String get privacy_policy => 'Privacy Agreement';

  @override
  String get verification_drag_tip =>
      'Please press and hold the slider and drag it to the far right';

  @override
  String get usage_protocol => 'Utilization Agreement';

  @override
  String get privacy_content =>
      'We would like to remind you (the User) that before registering as a User, please read this User Registration and Use of App Privacy Agreement (hereinafter referred to as the \"Agreement\") carefully to ensure that you fully understand the terms and conditions of this Agreement. Please read it carefully and choose to accept or not accept this Agreement. Unless you accept all the terms and conditions of this Agreement, you are not authorized to register, log in or use the services covered by this Agreement. Your registration, login, use and other behavior will be regarded as the acceptance of this Agreement, and agree to be bound by the terms of this Agreement. This Agreement governs the rights and obligations of Lazhong Yun (Beijing) Network Co., Ltd (hereinafter referred to as \"Lawyer to the\") and the User with respect to the Lawyer to the software services (hereinafter referred to as \"Services\"). The User is the individual or organization that registers, logs in, and uses the Service. This Agreement may be updated by Lawyer to Lawyer at any time, and the updated Terms of Agreement will replace the original Terms of Agreement once published without further notice, and the User may review the latest version of the Terms of Agreement in the App. After the modification of the terms of the agreement, if the user does not accept the modified terms, please immediately stop using the services provided by the lawyer to the user to continue to use the services provided by the lawyer to the user will be deemed to accept the   a, account registration 1, the user needs to register a lawyer to the App account before using this service. Lawyer to the App account should use a cell phone number, or lawyer to the binding registration, please use the user has not yet with the lawyer to the App account binding cell phone number, as well as has not been lawyer to the blocked cell phone number under this agreement to register lawyer to the App account. Lawyer to the can according to the user demand or product needs to account registration and binding of the way to change, without prior notice to the user.     2, in view of the lawyer to the app account binding registration method, you agree to the lawyer to the registration will allow your cell phone number and mobile device identification code and other information for registration.';

  @override
  String get today_earnings => 'Today\'s Est. Rewards';

  @override
  String get ttn => 'TTN';

  @override
  String get email => 'Email Address';

  @override
  String get current_device_ID => 'Current Device ID';

  @override
  String get stop_earning_coins => 'Stop Earning';

  @override
  String get start_earning_coins => 'Start Earning';

  @override
  String get view_earnings_details => 'View reward details';

  @override
  String get initializing => 'Initializing';

  @override
  String get starting => 'Starting';

  @override
  String get stopping => 'Stopping';

  @override
  String get to_update => 'to upgrade';

  @override
  String get new_version => 'found new version';

  @override
  String get tab_home => 'Home';

  @override
  String get tab_wallet => 'wallet';

  @override
  String get tab_history => 'History';

  @override
  String get tab_setting => 'Settings';

  @override
  String get setting_huygens_testnet => 'Huygens Testnet';

  @override
  String get about_titan => 'About Titan';

  @override
  String get login_account => 'Login account';

  @override
  String get wallet_address => 'Wallet Address';

  @override
  String get logout => 'Logout';

  @override
  String get setting_change_language => 'Languages';

  @override
  String get setting_language_zh => 'ZH';

  @override
  String get setting_language_en => 'EN';

  @override
  String get setting_twitter => 'Twitter';

  @override
  String get setting_discord => 'Discord';

  @override
  String get setting_telegram => 'Telegram';

  @override
  String get setting_about_titan => 'About Titan Network';

  @override
  String get setting_official_site => 'Official Site';

  @override
  String get setting_version => 'Version';

  @override
  String get setting_automatic_updates => 'Automatic Updates';

  @override
  String get setting_up_to_date => 'You are up to date';

  @override
  String get setting_update_now => 'Update Now';

  @override
  String setting_update_info_1(Object version) {
    return 'Dear User,\nThis update provides important bug fixes and security updates which include $version, and we recommend all users to update as soon as possible.';
  }

  @override
  String get setting_update_info_2 =>
      'For information on the security content of Titan Network software updates, please visit the following website:';

  @override
  String get history_title => 'Node Records';

  @override
  String get history_status => 'Status：';

  @override
  String get history_environment => 'Environment：';

  @override
  String get history_time => 'Time：';

  @override
  String get wallet_get_identity_title => '01.Request an Identity Code';

  @override
  String get wallet_get_identity_desc =>
      'Welcome to Titan Network! Please request an identity code for you device, and claim your rewards after binding the code.';

  @override
  String get wallet_get_identity_button => 'Request an Identity Code';

  @override
  String get wallet_input_identity_title => '02.Enter Your Identity Code';

  @override
  String get wallet_input_identity_desc =>
      'Please bind your identity code asap to avoid losing rewards.';

  @override
  String get wallet_input_identity_button => 'Bind Your Identity Code';

  @override
  String get wallet_verify_information => 'Verify Information';

  @override
  String get wallet_account => 'Account';

  @override
  String get wallet_email_address => 'Email Address';

  @override
  String get wallet_wallet_address => 'Wallet Address';

  @override
  String get wallet_confirm_bind => 'Confirm to bind';

  @override
  String get wallet_bound => 'Bound';

  @override
  String get wallet_user => 'User';

  @override
  String get wallet_device_management => 'Device Management';

  @override
  String get error_device_has_bound => 'Device Already Bound';

  @override
  String get error_signature => 'Invalid Signature';

  @override
  String get error_parameter => 'Invalid Parameters';

  @override
  String get error_unknown => 'Unknown Error';

  @override
  String get error_invalid_token => 'Invalid identity code';

  @override
  String get error_network => 'Network Error';

  @override
  String get error_token_has_bound => 'Identity code has been used';

  @override
  String get error_node_not_exists => 'The node is not logged in';

  @override
  String get error_input_empty => 'input should not be empty';

  @override
  String get error_identity_format_invalid => 'identity\'s format is invalid';

  @override
  String get failed_stop => 'Failed to Stop';

  @override
  String get failed_start => 'Startup failed';

  @override
  String get failed_bind => 'Bind failed';

  @override
  String get belongs => 'Titan Account related to identity code';

  @override
  String get bound => 'Bound';

  @override
  String get back => 'Back';

  @override
  String get download_progress => 'Download progress';

  @override
  String get download_installation_package =>
      'Downloading installation package';
}
