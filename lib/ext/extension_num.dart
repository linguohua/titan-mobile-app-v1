/// 扩展函数
extension StringExtension on num {
  String formatPercentNumber() {
    String result = (this * 100).toStringAsFixed(2);
    if (result.endsWith('.00')) {
      result = result.replaceAll('.00', '');
    } else if (result.endsWith('0')) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }
}
extension TruncateString on String {
  String truncate() {
    if (this.length <= 18) {
      return this; // 如果字符串长度小于等于 6，返回原字符串
    }
    return '${this.substring(0, 18)}...${this.substring(this.length - 3)}';
  }
}