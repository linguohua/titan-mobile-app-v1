// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `欢迎来到Titan`
  String get welcome_to_titan {
    return Intl.message(
      '欢迎来到Titan',
      name: 'welcome_to_titan',
      desc: '',
      args: [],
    );
  }

  /// `忘记密码`
  String get forget_password {
    return Intl.message(
      '忘记密码',
      name: 'forget_password',
      desc: '',
      args: [],
    );
  }

  /// `登录`
  String get login {
    return Intl.message(
      '登录',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `注册`
  String get register {
    return Intl.message(
      '注册',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `邮箱验证码`
  String get email_verification_code {
    return Intl.message(
      '邮箱验证码',
      name: 'email_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `发送证码`
  String get sender_decoder {
    return Intl.message(
      '发送证码',
      name: 'sender_decoder',
      desc: '',
      args: [],
    );
  }

  /// `已发送`
  String get sent {
    return Intl.message(
      '已发送',
      name: 'sent',
      desc: '',
      args: [],
    );
  }

  /// `密码`
  String get password {
    return Intl.message(
      '密码',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `设置密码`
  String get set_password {
    return Intl.message(
      '设置密码',
      name: 'set_password',
      desc: '',
      args: [],
    );
  }

  /// `确认密码`
  String get confirm_password {
    return Intl.message(
      '确认密码',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `邀请码（选填）`
  String get invitation_code {
    return Intl.message(
      '邀请码（选填）',
      name: 'invitation_code',
      desc: '',
      args: [],
    );
  }

  /// `已有有帐号？点击登录`
  String get login_entry {
    return Intl.message(
      '已有有帐号？点击登录',
      name: 'login_entry',
      desc: '',
      args: [],
    );
  }

  /// `还没有帐号？点击注册`
  String get register_entry {
    return Intl.message(
      '还没有帐号？点击注册',
      name: 'register_entry',
      desc: '',
      args: [],
    );
  }

  /// `确认修改`
  String get confirm_modification {
    return Intl.message(
      '确认修改',
      name: 'confirm_modification',
      desc: '',
      args: [],
    );
  }

  /// `我已阅读并同意`
  String get privacy_policy_1 {
    return Intl.message(
      '我已阅读并同意',
      name: 'privacy_policy_1',
      desc: '',
      args: [],
    );
  }

  /// `《Titan的使用协议》`
  String get privacy_policy_2 {
    return Intl.message(
      '《Titan的使用协议》',
      name: 'privacy_policy_2',
      desc: '',
      args: [],
    );
  }

  /// `隐私协议`
  String get privacy_policy {
    return Intl.message(
      '隐私协议',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `请按住滑块，拖动到最右边`
  String get verification_drag_tip {
    return Intl.message(
      '请按住滑块，拖动到最右边',
      name: 'verification_drag_tip',
      desc: '',
      args: [],
    );
  }

  /// `使用协议`
  String get usage_protocol {
    return Intl.message(
      '使用协议',
      name: 'usage_protocol',
      desc: '',
      args: [],
    );
  }

  /// `在此特别提醒您（用户）在注册成为用户之前，请认真阅读本《用户注册及使用App隐私协议》（以下简称“协议”），确保您充分理解本协议中各条款。请您审慎阅读并选择接受或不接受本协议。除非您接受本协议所有条款，否则您无权注册、登录或使用本协议所涉服务。您的注册、登录、使用等行为将视为对本协议的接受，并同意接受本协议各项条款的约束。本协议约定律众云（北京）网络有限责任公司（以下简称“律师到了”）与用户之间关于律师到了软件服务（以下简称“服务”）的权利义务。用户，是指注册、登录、使用本服务的个人或组织。本协议可由律师到了随时更新，更新后的协议条款一旦公布即代替原来的协议条款，恕不再另行通知，用户可在本App中查阅最新版协议条款。在修改协议条款后，如果用户不接受修改后的条款，请立即停止使用律师到了提供的服务，用户继续使用律师到了提供的服务将被视为接受    一、账号注册   1、用户在使用本服务前需要注册一个律师到了App账号。律师到了App账号应当使用手机号码、或者律师到了绑定注册，请用户使用尚未与律师到了App账号绑定的手机号码，以及未被律师到了根据本协议封禁的手机号码注册律师到了App账号。律师到了可以根据用户需求或产品需要对账号注册和绑定的方式进行变更，而无须事先通知用户。     2、鉴于律师到了App账号的绑定注册方式，您同意律师到了在注册时将允许您的手机号码及手机设备识别码等信息用于注册。`
  String get privacy_content {
    return Intl.message(
      '在此特别提醒您（用户）在注册成为用户之前，请认真阅读本《用户注册及使用App隐私协议》（以下简称“协议”），确保您充分理解本协议中各条款。请您审慎阅读并选择接受或不接受本协议。除非您接受本协议所有条款，否则您无权注册、登录或使用本协议所涉服务。您的注册、登录、使用等行为将视为对本协议的接受，并同意接受本协议各项条款的约束。本协议约定律众云（北京）网络有限责任公司（以下简称“律师到了”）与用户之间关于律师到了软件服务（以下简称“服务”）的权利义务。用户，是指注册、登录、使用本服务的个人或组织。本协议可由律师到了随时更新，更新后的协议条款一旦公布即代替原来的协议条款，恕不再另行通知，用户可在本App中查阅最新版协议条款。在修改协议条款后，如果用户不接受修改后的条款，请立即停止使用律师到了提供的服务，用户继续使用律师到了提供的服务将被视为接受    一、账号注册   1、用户在使用本服务前需要注册一个律师到了App账号。律师到了App账号应当使用手机号码、或者律师到了绑定注册，请用户使用尚未与律师到了App账号绑定的手机号码，以及未被律师到了根据本协议封禁的手机号码注册律师到了App账号。律师到了可以根据用户需求或产品需要对账号注册和绑定的方式进行变更，而无须事先通知用户。     2、鉴于律师到了App账号的绑定注册方式，您同意律师到了在注册时将允许您的手机号码及手机设备识别码等信息用于注册。',
      name: 'privacy_content',
      desc: '',
      args: [],
    );
  }

  /// `Today's Rewards`
  String get today_earnings {
    return Intl.message(
      'Today\'s Rewards',
      name: 'today_earnings',
      desc: '',
      args: [],
    );
  }

  /// `TTN`
  String get TTN {
    return Intl.message(
      'TTN',
      name: 'TTN',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email {
    return Intl.message(
      'Email Address',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Current Device ID`
  String get current_device_ID {
    return Intl.message(
      'Current Device ID',
      name: 'current_device_ID',
      desc: '',
      args: [],
    );
  }

  /// `Stop Earning`
  String get stop_earning_coins {
    return Intl.message(
      'Stop Earning',
      name: 'stop_earning_coins',
      desc: '',
      args: [],
    );
  }

  /// `Start Earning`
  String get start_earning_coins {
    return Intl.message(
      'Start Earning',
      name: 'start_earning_coins',
      desc: '',
      args: [],
    );
  }

  /// `View reward details`
  String get view_earnings_details {
    return Intl.message(
      'View reward details',
      name: 'view_earnings_details',
      desc: '',
      args: [],
    );
  }

  /// `Initializing`
  String get initializing {
    return Intl.message(
      'Initializing',
      name: 'initializing',
      desc: '',
      args: [],
    );
  }

  /// `Running`
  String get running {
    return Intl.message(
      'Running',
      name: 'running',
      desc: '',
      args: [],
    );
  }

  /// `去更新`
  String get to_update {
    return Intl.message(
      '去更新',
      name: 'to_update',
      desc: '',
      args: [],
    );
  }

  /// `发现新版本 `
  String get new_version {
    return Intl.message(
      '发现新版本 ',
      name: 'new_version',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get tab_home {
    return Intl.message(
      'Home',
      name: 'tab_home',
      desc: '',
      args: [],
    );
  }

  /// `wallet`
  String get tab_wallet {
    return Intl.message(
      'wallet',
      name: 'tab_wallet',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get tab_history {
    return Intl.message(
      'History',
      name: 'tab_history',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get tab_setting {
    return Intl.message(
      'Settings',
      name: 'tab_setting',
      desc: '',
      args: [],
    );
  }

  /// `Huygens Testnet`
  String get setting_huygens_testnet {
    return Intl.message(
      'Huygens Testnet',
      name: 'setting_huygens_testnet',
      desc: '',
      args: [],
    );
  }

  /// `关于Titan`
  String get about_titan {
    return Intl.message(
      '关于Titan',
      name: 'about_titan',
      desc: '',
      args: [],
    );
  }

  /// `登录账号`
  String get login_account {
    return Intl.message(
      '登录账号',
      name: 'login_account',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Address`
  String get wallet_address {
    return Intl.message(
      'Wallet Address',
      name: 'wallet_address',
      desc: '',
      args: [],
    );
  }

  /// `退出登录`
  String get logout {
    return Intl.message(
      '退出登录',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get setting_change_language {
    return Intl.message(
      'Languages',
      name: 'setting_change_language',
      desc: '',
      args: [],
    );
  }

  /// `ZH`
  String get setting_language_zh {
    return Intl.message(
      'ZH',
      name: 'setting_language_zh',
      desc: '',
      args: [],
    );
  }

  /// `EN`
  String get setting_language_en {
    return Intl.message(
      'EN',
      name: 'setting_language_en',
      desc: '',
      args: [],
    );
  }

  /// `Twitter`
  String get setting_twitter {
    return Intl.message(
      'Twitter',
      name: 'setting_twitter',
      desc: '',
      args: [],
    );
  }

  /// `Discord`
  String get setting_discord {
    return Intl.message(
      'Discord',
      name: 'setting_discord',
      desc: '',
      args: [],
    );
  }

  /// `Telegram`
  String get setting_telegram {
    return Intl.message(
      'Telegram',
      name: 'setting_telegram',
      desc: '',
      args: [],
    );
  }

  /// `About Titan Network`
  String get setting_about_titan {
    return Intl.message(
      'About Titan Network',
      name: 'setting_about_titan',
      desc: '',
      args: [],
    );
  }

  /// `Official Site`
  String get setting_official_site {
    return Intl.message(
      'Official Site',
      name: 'setting_official_site',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get setting_version {
    return Intl.message(
      'Version',
      name: 'setting_version',
      desc: '',
      args: [],
    );
  }

  /// `Automatic Updates`
  String get setting_automatic_updates {
    return Intl.message(
      'Automatic Updates',
      name: 'setting_automatic_updates',
      desc: '',
      args: [],
    );
  }

  /// `You are up to date`
  String get setting_up_to_date {
    return Intl.message(
      'You are up to date',
      name: 'setting_up_to_date',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get setting_update_now {
    return Intl.message(
      'Update Now',
      name: 'setting_update_now',
      desc: '',
      args: [],
    );
  }

  /// `Dear User,\nThis update provides important bug fixes and security updates which include {version}, and we recommend all users to update as soon as possible.`
  String setting_update_info_1(Object version) {
    return Intl.message(
      'Dear User,\nThis update provides important bug fixes and security updates which include $version, and we recommend all users to update as soon as possible.',
      name: 'setting_update_info_1',
      desc: '',
      args: [version],
    );
  }

  /// `For information on the security content of Titan Network software updates, please visit the following website:`
  String get setting_update_info_2 {
    return Intl.message(
      'For information on the security content of Titan Network software updates, please visit the following website:',
      name: 'setting_update_info_2',
      desc: '',
      args: [],
    );
  }

  /// `Node Records`
  String get history_title {
    return Intl.message(
      'Node Records',
      name: 'history_title',
      desc: '',
      args: [],
    );
  }

  /// `Status：`
  String get history_status {
    return Intl.message(
      'Status：',
      name: 'history_status',
      desc: '',
      args: [],
    );
  }

  /// `Environment：`
  String get history_environment {
    return Intl.message(
      'Environment：',
      name: 'history_environment',
      desc: '',
      args: [],
    );
  }

  /// `Time：`
  String get history_time {
    return Intl.message(
      'Time：',
      name: 'history_time',
      desc: '',
      args: [],
    );
  }

  /// `01.Request an Identity Code`
  String get wallet_get_identity_title {
    return Intl.message(
      '01.Request an Identity Code',
      name: 'wallet_get_identity_title',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Titan Network! Please request an identity code for you device, and claim your rewards after binding the code.`
  String get wallet_get_identity_desc {
    return Intl.message(
      'Welcome to Titan Network! Please request an identity code for you device, and claim your rewards after binding the code.',
      name: 'wallet_get_identity_desc',
      desc: '',
      args: [],
    );
  }

  /// `Request an Identity Code`
  String get wallet_get_identity_button {
    return Intl.message(
      'Request an Identity Code',
      name: 'wallet_get_identity_button',
      desc: '',
      args: [],
    );
  }

  /// `02.Enter Your Identity Code`
  String get wallet_input_identity_title {
    return Intl.message(
      '02.Enter Your Identity Code',
      name: 'wallet_input_identity_title',
      desc: '',
      args: [],
    );
  }

  /// `Please bind your identity code asap to avoid losing rewards.`
  String get wallet_input_identity_desc {
    return Intl.message(
      'Please bind your identity code asap to avoid losing rewards.',
      name: 'wallet_input_identity_desc',
      desc: '',
      args: [],
    );
  }

  /// `Bind Your Identity Code`
  String get wallet_input_identity_button {
    return Intl.message(
      'Bind Your Identity Code',
      name: 'wallet_input_identity_button',
      desc: '',
      args: [],
    );
  }

  /// `Verify Information`
  String get wallet_verify_information {
    return Intl.message(
      'Verify Information',
      name: 'wallet_verify_information',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get wallet_account {
    return Intl.message(
      'Account',
      name: 'wallet_account',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get wallet_email_address {
    return Intl.message(
      'Email Address',
      name: 'wallet_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Address`
  String get wallet_wallet_address {
    return Intl.message(
      'Wallet Address',
      name: 'wallet_wallet_address',
      desc: '',
      args: [],
    );
  }

  /// `Confirm to bind`
  String get wallet_confirm_bind {
    return Intl.message(
      'Confirm to bind',
      name: 'wallet_confirm_bind',
      desc: '',
      args: [],
    );
  }

  /// `Bound`
  String get wallet_bound {
    return Intl.message(
      'Bound',
      name: 'wallet_bound',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get wallet_user {
    return Intl.message(
      'User',
      name: 'wallet_user',
      desc: '',
      args: [],
    );
  }

  /// `Device Management`
  String get wallet_device_management {
    return Intl.message(
      'Device Management',
      name: 'wallet_device_management',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
