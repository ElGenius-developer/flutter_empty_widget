import 'dart:math';

import 'package:custom_sizable_text/custom_sizable_text.dart';
import 'package:flutter/material.dart';

part 'images.dart';

/// {@tool snippet}
///
/// This example shows how to use [EmptyWidget]
///
///  ``` dart
/// EmptyWidget(
///   image: null,
///   packageImage: PackageImage.Image_1,
///   title: 'No Notification',
///   subTitle: 'No  notification available yet',
///   titleTextStyle: TextStyle(
///     fontSize: 22,
///     color: Color(0xff9da9c7),
///     fontWeight: FontWeight.w500,
///   ),
///   subtitleTextStyle: TextStyle(
///     fontSize: 14,
///     color: Color(0xffabb8d6),
///   ),
/// )
/// ```
/// {@end-tool}

class EmptyWidget extends StatefulWidget {
  const EmptyWidget({
    super.key,
    this.title,
    this.subTitle,
    this.image,
    this.subtitleTextStyle,
    this.titleTextStyle,
    this.packageImage,
    this.height,
    this.width,
    this.hideBackgroundAnimation = false,
  });

  /// Display images from project assets
  final String? image; /*!*/

  /// Display image from package assets
  final PackageImage? packageImage; /*!*/

  /// Set text for subTitle
  final String? subTitle; /*!*/

  /// Set text style for subTitle
  final TextStyle? subtitleTextStyle; /*!*/

  /// Set text for title
  final String? title; /*!*/

  /// Text style for title
  final TextStyle? titleTextStyle; /*!*/

  /// Hides the background circular ball animation
  ///
  /// By default `false` value is set
  final bool? hideBackgroundAnimation;

  ///
  /// By default `null` value is set
  final double? height; /*!*/
  /// Hides the background circular ball animation
  ///
  /// By default `null` value is set
  final double? width; /*!*/
  @override
  State<StatefulWidget> createState() => _EmptyListWidgetState();
}

class _EmptyListWidgetState extends State<EmptyWidget> with TickerProviderStateMixin {
  late AnimationController _backgroundController;

  late Animation _imageAnimation; /*!*/
  AnimationController? _imageController; /*!*/
  late PackageImage? _packageImage; /*!*/
  TextStyle? _subtitleTextStyle; /*!*/
  TextStyle? _titleTextStyle; /*!*/
  late AnimationController _widgetController; /*!*/

  @override
  void dispose() {
    _backgroundController.dispose();
    _imageController!.dispose();
    _widgetController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _backgroundController = AnimationController(duration: const Duration(minutes: 1), vsync: this, lowerBound: 0, upperBound: 20)..repeat();
    _widgetController = AnimationController(duration: const Duration(seconds: 1), vsync: this, lowerBound: 0, upperBound: 1)..forward();
    _imageController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _imageAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _imageController!, curve: Curves.linear),
    );
    super.initState();
  }

  animationListner() {
    if (_imageController == null) {
      return;
    }
    if (_imageController!.isCompleted) {
      setState(() {
        _imageController!.reverse();
      });
    } else {
      setState(() {
        _imageController!.forward();
      });
    }
  }

  Widget _imageWidget() {
    bool isPackageImage = _packageImage != null;
    return Expanded(
      flex: 3,
      child: AnimatedBuilder(
        animation: _imageAnimation,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: Offset(0, sin(_imageAnimation.value > .9 ? 1 - _imageAnimation.value : _imageAnimation.value)),
            child: child,
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            isPackageImage ? _packageImage.encode()! : widget.image!,
            fit: BoxFit.contain,
            package: isPackageImage ? 'empty_widget' : null,
          ),
        ),
      ),
    );
  }

  Widget _imageBackground() {
    return Container(
      height: MediaQuery.of(context).size.height * .95,
      width: MediaQuery.of(context).size.height * .95,
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(
          offset: Offset(0, 0),
          color: Color(0xffe2e5ed),
        ),
        BoxShadow(blurRadius: 30, offset: Offset(20, 0), color: Color(0xffffffff), spreadRadius: -5),
      ], shape: BoxShape.circle),
    );
  }

  Widget _shell({Widget? child}) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxHeight > constraints.maxWidth) {
        return SizedBox(
          height: constraints.maxWidth,
          width: constraints.maxWidth,
          child: child,
        );
      } else {
        return child!;
      }
    });
  }

  Widget _shellChild() {
    _titleTextStyle = widget.titleTextStyle ?? Theme.of(context).typography.dense.headlineLarge!.copyWith(color: Color(0xff9da9c7));
    _subtitleTextStyle = widget.subtitleTextStyle ?? Theme.of(context).typography.dense.bodyMedium!.copyWith(color: Color(0xffabb8d6));
    _packageImage = widget.packageImage;

    bool anyImageProvided = widget.image == null && _packageImage == null;

    return FadeTransition(
      opacity: _widgetController,
      child: Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (!widget.hideBackgroundAnimation!)
                RotationTransition(
                  turns: _backgroundController,
                  child: _imageBackground(),
                ),
              LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxWidth,
                  width: constraints.maxWidth - 30,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (!anyImageProvided)
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                      if (!anyImageProvided) _imageWidget(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 10,
                          children: <Widget>[
                            CustomText(
                              widget.title ?? "",
                              textStyle: _titleTextStyle,
                              textOverflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                            ),
                           
                            CustomText(widget.subTitle ?? "",
                                textStyle: _subtitleTextStyle, textOverflow: TextOverflow.clip, textAlign: TextAlign.center)
                          ],
                        ),
                      ),
                      if (!anyImageProvided)
                        Expanded(
                          flex: 1,
                          child: Container(),
                        )
                    ],
                  ),
                );
              }),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _shell(child: _shellChild());
  }
}
