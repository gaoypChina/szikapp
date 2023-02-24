import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../ui/themes.dart';

class CustomIcons {
  static const String armchair = 'assets/icons/armchair.svg';
  static const String arrowLeft = 'assets/icons/arrow_left.svg';
  static const String article = 'assets/icons/article.svg';
  static const String beer = 'assets/icons/beer.svg';
  static const String bell = 'assets/icons/bell.svg';
  static const String bookClosed = 'assets/icons/book_closed.svg';
  static const String bookOpen = 'assets/icons/book_open.svg';
  static const String calendar = 'assets/icons/calendar.svg';
  static const String camera = 'assets/icons/camera.svg';
  static const String cedar = 'assets/icons/cedar.svg';
  static const String chalkboard = 'assets/icons/chalkboard.svg';
  static const String clock = 'assets/icons/clock.svg';
  static const String close = 'assets/icons/close.svg';
  static const String closeOutlined = 'assets/icons/close_outlined.svg';
  static const String description = 'assets/icons/description.svg';
  static const String dice = 'assets/icons/dice.svg';
  static const String done = 'assets/icons/done.svg';
  static const String doubleArrowDown = 'assets/icons/double_arrow_down.svg';
  static const String doubleArrowLeft = 'assets/icons/double_arrow_left.svg';
  static const String doubleArrowRight = 'assets/icons/double_arrow_right.svg';
  static const String doubleArrowUp = 'assets/icons/double_arrow_up.svg';
  static const String email = 'assets/icons/email.svg';
  static const String envelope = 'assets/icons/envelope.svg';
  static const String feed = 'assets/icons/feed.svg';
  static const String filter = 'assets/icons/filter.svg';
  static const String fire = 'assets/icons/fire.svg';
  static const String gift = 'assets/icons/gift.svg';
  static const String handpalm = 'assets/icons/handpalm.svg';
  static const String heartEmpty = 'assets/icons/heart_empty.svg';
  static const String heartFull = 'assets/icons/heart_full.svg';
  static const String hourglass = 'assets/icons/hourglass.svg';
  static const String house = 'assets/icons/house.svg';
  static const String image = 'assets/icons/image.svg';
  static const String knife = 'assets/icons/knife.svg';
  static const String library = 'assets/icons/library.svg';
  static const String like = 'assets/icons/like.svg';
  static const String logout = 'assets/icons/logout.svg';
  static const String menu = 'assets/icons/menu.svg';
  static const String moon = 'assets/icons/moon.svg';
  static const String password = 'assets/icons/password.svg';
  static const String pencil = 'assets/icons/pencil.svg';
  static const String pencilAndPaper = 'assets/icons/pencil_and_paper.svg';
  static const String phone = 'assets/icons/phone.svg';
  static const String pin = 'assets/icons/pin.svg';
  static const String plus = 'assets/icons/plus.svg';
  static const String report = 'assets/icons/report.svg';
  static const String search = 'assets/icons/search.svg';
  static const String settings = 'assets/icons/settings.svg';
  static const String share = 'assets/icons/share.svg';
  static const String shield = 'assets/icons/shield.svg';
  static const String smiley = 'assets/icons/smiley.svg';
  static const String sun = 'assets/icons/sun.svg';
  static const String tag = 'assets/icons/tag.svg';
  static const String toolbox = 'assets/icons/toolbox.svg';
  static const String trash = 'assets/icons/trash.svg';
  static const String user = 'assets/icons/user.svg';
  static const String userName = 'assets/icons/username.svg';
  static const String userOutlined = 'assets/icons/user_outlined.svg';
  static const String users = 'assets/icons/users.svg';
  static const String volumeDown = 'assets/icons/volume_down.svg';
  static const String volumeUp = 'assets/icons/volume_up.svg';
  static const String wrench = 'assets/icons/wrench.svg';
}

class CustomIcon extends StatelessWidget {
  final String type;
  final double size;
  final Color? color;

  const CustomIcon(
    this.type, {
    super.key,
    this.size = kIconSizeNormal,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      type,
      width: size,
      height: size,
      color: color,
    );
  }
}
