import 'package:flutter/material.dart';

class RegistrationCardGrid extends StatelessWidget {
  final String cardTitle;
  final String cardImageUrl;
  final Color backgroundColor;
  final Color fontColor;
  final num fontSize;
  final Function onTapCallback;

  const RegistrationCardGrid(
      {this.cardTitle,
      this.cardImageUrl,
      this.backgroundColor,
      this.fontColor,
      this.fontSize,
      this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTapCallback,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: Image.network(
              cardImageUrl,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              backgroundColor: backgroundColor,
              title: Text(
                cardTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: fontColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
