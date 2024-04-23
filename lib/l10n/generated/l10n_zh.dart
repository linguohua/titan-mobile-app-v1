// ignore_for_file: non_constant_identifier_names, use_super_parameters, unnecessary_string_escapes

import 'l10n.dart';

/// The translations for Chinese (`zh`).
class SZh extends S {
  SZh([String locale = 'zh']) : super(locale);

  @override
  String get welcome_to_titan => '欢迎来到Titan';

  @override
  String get forget_password => '忘记密码';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get email_verification_code => '邮箱验证码';

  @override
  String get sender_decoder => '发送证码';

  @override
  String get sent => '已发送';

  @override
  String get password => '密码';

  @override
  String get set_password => '设置密码';

  @override
  String get confirm_password => '确认密码';

  @override
  String get invitation_code => '邀请码（选填）';

  @override
  String get login_entry => '已有有帐号？点击登录';

  @override
  String get register_entry => '还没有帐号？点击注册';

  @override
  String get confirm_modification => '确认修改';

  @override
  String get privacy_policy_1 => '我已阅读并同意';

  @override
  String get privacy_policy_2 => '《Titan的使用协议》';

  @override
  String get privacy_policy => '隐私协议';

  @override
  String get verification_drag_tip => '请按住滑块，拖动到最右边';

  @override
  String get usage_protocol => '使用协议';

  @override
  String get privacy_content =>
      '在此特别提醒您（用户）在注册成为用户之前，请认真阅读本《用户注册及使用App隐私协议》（以下简称“协议”），确保您充分理解本协议中各条款。请您审慎阅读并选择接受或不接受本协议。除非您接受本协议所有条款，否则您无权注册、登录或使用本协议所涉服务。您的注册、登录、使用等行为将视为对本协议的接受，并同意接受本协议各项条款的约束。本协议约定律众云（北京）网络有限责任公司（以下简称“律师到了”）与用户之间关于律师到了软件服务（以下简称“服务”）的权利义务。用户，是指注册、登录、使用本服务的个人或组织。本协议可由律师到了随时更新，更新后的协议条款一旦公布即代替原来的协议条款，恕不再另行通知，用户可在本App中查阅最新版协议条款。在修改协议条款后，如果用户不接受修改后的条款，请立即停止使用律师到了提供的服务，用户继续使用律师到了提供的服务将被视为接受    一、账号注册   1、用户在使用本服务前需要注册一个律师到了App账号。律师到了App账号应当使用手机号码、或者律师到了绑定注册，请用户使用尚未与律师到了App账号绑定的手机号码，以及未被律师到了根据本协议封禁的手机号码注册律师到了App账号。律师到了可以根据用户需求或产品需要对账号注册和绑定的方式进行变更，而无须事先通知用户。     2、鉴于律师到了App账号的绑定注册方式，您同意律师到了在注册时将允许您的手机号码及手机设备识别码等信息用于注册。';

  @override
  String get today_earnings => '今日预估收益';

  @override
  String get ttn => 'TTN';

  @override
  String get email => '邮箱';

  @override
  String get current_device_ID => '当前设备ID';

  @override
  String get stop_earning_coins => '停止赚钱';

  @override
  String get start_earning_coins => '开始赚钱';

  @override
  String get view_earnings_details => '查看收益详情';

  @override
  String get initializing => '启动中';

  @override
  String get starting => '启动中';

  @override
  String get stopping => '停止中';

  @override
  String get to_update => '去更新';

  @override
  String get new_version => '发现新版本 ';

  @override
  String get tab_home => '首页';

  @override
  String get tab_wallet => '绑定';

  @override
  String get tab_history => '历史记录';

  @override
  String get tab_setting => '设置';

  @override
  String get setting_huygens_testnet => '惠更斯测试网';

  @override
  String get about_titan => '关于Titan';

  @override
  String get login_account => '登录账号';

  @override
  String get wallet_address => '钱包地址';

  @override
  String get logout => '退出登录';

  @override
  String get setting_change_language => '语言切换';

  @override
  String get setting_language_zh => '中文';

  @override
  String get setting_language_en => '英文';

  @override
  String get setting_twitter => '推特';

  @override
  String get setting_discord => 'Discord';

  @override
  String get setting_telegram => 'Telegram';

  @override
  String get setting_about_titan => '关于Titan Network';

  @override
  String get setting_official_site => '官网';

  @override
  String get setting_version => '版本号';

  @override
  String get setting_automatic_updates => '自动更新';

  @override
  String get setting_up_to_date => '已是最新版本';

  @override
  String get setting_update_now => '立即更新';

  @override
  String setting_update_info_1(Object version) {
    return '亲爱的用户， 本次更新合入了$version，建议您尽快更新，修复已知的问题和bug\n\n';
  }

  @override
  String get setting_update_info_2 => '如需了解Titan Network软件更新的安全性内容，请访问此网站：';

  @override
  String get history_title => '运行记录';

  @override
  String get history_status => '状态：';

  @override
  String get history_environment => '环境：';

  @override
  String get history_time => '时间：';

  @override
  String get wallet_get_identity_title => '01.领取身份';

  @override
  String get wallet_get_identity_desc =>
      '欢迎加入Titan网络！\n请先领取身份码 ，以确认您的设备归属。\n绑定成功后，您即可开始领取收益';

  @override
  String get wallet_get_identity_button => '领取身份码';

  @override
  String get wallet_input_identity_title => '02.输入身份码';

  @override
  String get wallet_input_identity_desc => '请及时绑定，以免奖励丢失';

  @override
  String get wallet_input_identity_button => '绑定身份码';

  @override
  String get wallet_verify_information => '核对信息';

  @override
  String get wallet_account => '身份码所属账户';

  @override
  String get wallet_email_address => '邮箱';

  @override
  String get wallet_wallet_address => '钱包地址';

  @override
  String get wallet_confirm_bind => '确认绑定';

  @override
  String get wallet_bound => '已绑定';

  @override
  String get wallet_user => '所属用户';

  @override
  String get wallet_device_management => '设备管理';

  @override
  String get error_device_has_bound => '设备已绑定';

  @override
  String get error_signature => '签名错误';

  @override
  String get error_parameter => '参数错误';

  @override
  String get error_unknown => '未知错误';

  @override
  String get error_invalid_token => '无效的身份码';

  @override
  String get error_network => '网络错误';

  @override
  String get error_token_has_bound => '身份码已被使用';

  @override
  String get error_node_not_exists => '节点未登陆';

  @override
  String get error_input_empty => '输入不能为空';

  @override
  String get error_identity_format_invalid => '身份码输入错误';

  @override
  String get failed_stop => '停止失败';

  @override
  String get failed_start => '启动失败';

  @override
  String get failed_bind => '绑定出错';

  @override
  String get belongs => '所属账户';

  @override
  String get bound => '已绑定';

  @override
  String get back => '返回';

  @override
  String get download_progress => '下载进度';

  @override
  String get download_installation_package => '正在下载安装包';
}
