import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class CardProductExclusiveLocked extends StatelessWidget {
  const CardProductExclusiveLocked({
    super.key, 
    required this.imageUrl,
    this.imagePlaceholder,
    this.imageError,
    required this.name,
    required this.category,
    this.isLocked = false,
    this.onTapProduct,
    this.onTapProductExclusive,
    this.heightCard = 160,
    this.widthCard = 160,
    this.borderRadiusCard = 8,
    this.backgroundColorCard = StoycoColors.deepTeal,
    this.paddingContentCard,
    this.nameFontStyle,
    this.categoryFontStyle,
  });

  final String imageUrl;
  final Widget? imagePlaceholder;
  final Widget? imageError;
  final String name;
  final String category;
  final bool isLocked;
  final VoidCallback? onTapProduct;
  final VoidCallback? onTapProductExclusive;

  final double heightCard;
  final double widthCard;
  final double borderRadiusCard;
  final Color backgroundColorCard;
  final EdgeInsetsGeometry? paddingContentCard;

  final TextStyle? nameFontStyle;
  final TextStyle? categoryFontStyle;

  @override
  Widget build(BuildContext context) => InkWell(
      borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, borderRadiusCard)),
      onTap: isLocked ? onTapProductExclusive : onTapProduct,
      child: SizedBox(
        width: StoycoScreenSize.width(context, widthCard),
        height: StoycoScreenSize.height(context, heightCard),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, borderRadiusCard)),
              color: backgroundColorCard,
            ),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(StoycoScreenSize.radius(context, borderRadiusCard)),
                    topRight: Radius.circular(StoycoScreenSize.radius(context, borderRadiusCard)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        height: constraints.maxHeight * 0.7,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: imageUrl,
                        placeholder: (BuildContext context, String url) => imagePlaceholder ?? const DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
                            ),
                          ),
                        ),
                        errorWidget: (BuildContext context, String url, Object error) => imageError ?? const Icon(Icons.error),
                      ),
                      if (isLocked)
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 5,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.25,
                    child: Padding(
                      padding: paddingContentCard ?? StoycoScreenSize.symmetric(
                        context,
                        horizontal: 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            style: nameFontStyle ?? TextStyle(
                              fontSize: StoycoScreenSize.fontSize(context, 12),
                              fontWeight: FontWeight.bold,
                              color: StoycoColors.white,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            category,
                            style: categoryFontStyle ?? GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: StoycoScreenSize.fontSize(context, 10),
                                fontWeight: FontWeight.w400,
                                color: StoycoColors.hint,
                              ),
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLocked) 
                  Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, borderRadiusCard)),
                    ),
                    child: Positioned(
                      top: 8,
                      right: 8,
                      child: TagLocked(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
}

class TagLocked extends StatelessWidget {
  const TagLocked({
    super.key,
    this.message = 'Contenido bloqueado',
    this.messageStyle,
    this.padding,
    this.backgroundColor = StoycoColors.lightGray,
    this.borderRadius = 10.0,
    this.tagLockIcon,
    this.tagLockIconWidth,
    this.tagLockIconHeight,
  });

  final String message;
  final TextStyle? messageStyle;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Widget? tagLockIcon;
  final double? tagLockIconWidth;
  final double? tagLockIconHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? StoycoScreenSize.symmetric(context, horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, borderRadius)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          tagLockIcon ?? StoycoAssets.lib.assets.icons.tagLock.svg(
            width: tagLockIconWidth,
            height: tagLockIconHeight,
          ),
          Gap(StoycoScreenSize.width(context, 4)),
          Text(
            message,
            style: messageStyle ?? GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: StoycoScreenSize.fontSize(context, 9.23),
                fontWeight: FontWeight.w400,
              ),
            ),
          ), 
        ],
      ),
    );
  }
}
