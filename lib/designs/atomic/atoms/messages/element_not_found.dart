import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class ElementNotFound extends StatelessWidget {
  const ElementNotFound({super.key, required this.filter});

  final String filter;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Gap(StoycoScreenSize.height(context, 95)),
            _buildTitle(context),
            if (filter.trim().isEmpty)
              Container()
            else
              Column(
                children: <Widget>[
                  _buildSuggestionsHeader(context),
                  _buildSuggestionsList(context),
                ],
              ),
          ],
        ),
      );

  Widget _buildTitle(BuildContext context) => Container(
        margin: StoycoScreenSize.symmetric(context, horizontal: 50.5, vertical:  36),
        child: Text(
          // If filter is empty, avoid showing empty quotes
          filter.trim().isEmpty
              ? 'No hemos encontrado resultados'
              : 'No hemos encontrado resultados que coincidan con "$filter"',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFF2F2FA),
            fontSize: StoycoScreenSize.fontSize(context, 24),
            fontWeight: FontWeight.w700,
            height: StoycoScreenSize.height(context, 32) /
                StoycoScreenSize.fontSize(context, 24),
          ),
        ),
      );

  Widget _buildSuggestionsHeader(BuildContext context) => Container(
        margin: StoycoScreenSize.symmetric(context, horizontal: 34, vertical:  0),
        alignment: Alignment.topCenter,
        child: Text(
          'Sugerencias de búsqueda:',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: const Color(0xFFF2F2FA),
            fontSize: StoycoScreenSize.fontSize(context, 16),
            fontWeight: FontWeight.w700,
            height: StoycoScreenSize.height(context, 24) /
                StoycoScreenSize.fontSize(context, 16),
          ),
        ),
      );

  Widget _buildSuggestionsList(BuildContext context) {
    const List<String> suggestions = <String>[
      'Revisa la ortografía',
      'Usa palabras claves',
    ];

    return Container(
      margin: StoycoScreenSize.symmetric(context, horizontal: 34, vertical: 10),
      child: Column(
        children: suggestions
            .map((String suggestion) => _buildSuggestionItem(context, suggestion))
            .toList(),
      ),
    );
  }

  Widget _buildSuggestionItem(BuildContext context, String text) => Padding(
        padding: StoycoScreenSize.symmetric(context, horizontal: 0, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: StoycoScreenSize.symmetric(context, horizontal: 8, vertical: 0),
              width: StoycoScreenSize.width(context, 6),
              height: StoycoScreenSize.height(context, 6),
              decoration: const BoxDecoration(
                color: StoycoColors.white2,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
            Container(
              margin: StoycoScreenSize.symmetric(context, horizontal: 12, vertical: 0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: StoycoColors.white2,
                  fontSize: StoycoScreenSize.fontSize(context, 14),
                  fontWeight: FontWeight.w400,
                  height: StoycoScreenSize.height(context, 16) /
                      StoycoScreenSize.fontSize(context, 14),
                ),
              ),
            ),
          ],
        ),
      );
}
