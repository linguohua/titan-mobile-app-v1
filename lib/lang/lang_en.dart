import 'package:titan_app/lang/lang_dict.dart';

class LangDictEN implements LangDict {
  @override
  String get bound => "Bound";
  @override
  String get confirmBinding => "Confirm binding";
  @override
  String get startError => "Startup failed";
  @override
  String get openUrlError => "Unable to Access Webpage";
  @override
  String get show => "Show";

  @override
  String get hide => "Hide";
  @override
  String get exit => "Quit";
  @override
  String get stopError => "Failed to Stop";

  @override
  String get saveFailed => "Failed to Save";

  @override
  String get deviceHasBeenBound => "Device Already Bound";
  @override
  String get signatureError => "Invalid Signature";
  @override
  String get parameterError => "Invalid Parameters";
  @override
  String get unknown => "Unknown Error";
  @override
  String get invalidToken => "Invalid identity code";
  @override
  String get network => "Network Error";
  @override
  String get tokenHasBeenBound => "Invalid identity code has been used";
  @override
  String get nodeNotExist => "The node is not logged in";
  //
  @override
  String get appTitle => "Titan Network";

  @override
  String get belongs => "Titan Account related to identity code";

  @override
  String get unBindingHelp => "How to receive an identity code?";

  @override
  String get bindingToken => "Connect to the identity code.";

  @override
  String get email => "Email Address";

  @override
  String get lang => "English";

  @override
  String get totalIncome => "Accumulated Rewards";

  @override
  String get yesterdayIncome => "Yesterday's Rewards";

  @override
  String get weekIncome => "7 Day's Rewards";

  @override
  String get monthIncome => "30 Day's Rewards";

  @override
  String get incomeStatistics => "Rewards";

  @override
  String get todayIncome => "Today's Rewards";

  @override
  String get setting => "Settings";

  @override
  String get walletAddress => "Wallet Address";

  @override
  String get checkInfo => "Please confirm the information below";

  @override
  String get nodeID => "ID: ";

  @override
  String get back => "Back";

  @override
  String get sharedStorage => "Storage Space";

  @override
  String get changeStorageTip => "Setting";

  @override
  String get changeStorage => "Configuration";

  @override
  String get confirmChange => "Confirm";

  @override
  String get commonProblem => "Q&A";

  @override
  String get bindingError => "Error";

  @override
  String get storagePath => "Storage Pathway";

  @override
  String get notEmpty => "cannot be empty";

  @override
  String get waitStart => "Loading...";

  @override
  String get waiting => "Please wait...";

  @override
  String get networkCheck => "Please check the network";

  @override
  String get unBindingHint =>
      "Please connect the identity code to avoid losing the rewards.";

  @override
  String get token => "Identity Code";

  @override
  String get waitStop => "Pause...";

  @override
  String get clickToCopy => "Click To Copy";

  @override
  String get copySuccess => "Copied to clipboard!";

  @override
  String get startEarning => "Start";

  @override
  String get stopEarning => "Stop";

  @override
  String get settingTip => 'Here you can preset the amount of resources you wish to \ncontribute to the Titan network. Please note that your actual \nreward is calculated based on the actual amount of \nresources we use, not just these preset values.';

  @override
  String get settingTip1 => 'You want to use Titan network.';
}
