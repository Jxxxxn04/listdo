import 'dart:ui';

class Constants {

  final String _domainBaseUrl = 'http://jxxxxxn.ddns.net:3000';

  final Color _linearGradientColorTopBlue = const Color(0xFF6774EB);
  final Color _linearGradientColorBottomViolet = const Color(0xFFCA8EFF);


  String get domainBaseUrl {
    return _domainBaseUrl;
  }

  Color get linearGradientTopColor {
    return _linearGradientColorTopBlue;
  }

  Color get linearGradientBottomColor {
    return _linearGradientColorBottomViolet;
  }

}