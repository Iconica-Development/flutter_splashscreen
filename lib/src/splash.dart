import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

enum SplashScreenDismissMode { timer, buttonClick }

enum SplashScreenMode { show, hide }

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    required this.onComplete,
    this.splashScreenMode = SplashScreenMode.show,
    this.splashScreenBackgroundWidget,
    this.splashScreenDismissButton,
    this.splashScreenDismissMode = SplashScreenDismissMode.timer,
    this.splashScreenButtonIcon = const Icon(Icons.arrow_forward),
    this.splashScreenTimerLength = const Duration(seconds: 1),
    this.splashScreenCenterWidget,
    this.splashScreenButtonText,
    this.splashScreenFuture,
    this.backgroundColor,
    this.splashScreenTermsAndConditionsIcon,
    super.key,
  }) : assert(
          !(splashScreenDismissMode == SplashScreenDismissMode.buttonClick &&
              splashScreenDismissButton == null),
          'splashScreenDismissButton must not be null when buttonClick',
        );

  final SplashScreenMode splashScreenMode;

  final VoidCallback onComplete;

  /// Future function that is called during the splash screen
  /// and once completed onComplete will be called
  final Future Function()? splashScreenFuture;

  final Widget? splashScreenCenterWidget;

  final Widget? splashScreenBackgroundWidget;

  /// Choose between two style options for the splash screen button
  /// when [splashScreenDismissMode] is
  /// equal to [SplashScreenDismissMode.ButtonClick].
  /// Determines if the button used to dismiss the splash screen
  /// is a text button or just a rounded shape.
  final Widget? splashScreenDismissButton;

  /// Determine how the splashscreen can be dismissed.
  /// [SplashScreenDismissMode.Timer] Splash screen will be dismissed
  /// after a short duration.
  /// This duration be configured using [splashScreenTimerLength].
  ///
  /// [SplashScreenDismissMode.ButtonClick] Splash screen will be
  /// dismissed after the user click on a button.
  /// Set [splashScreenRoundButton] to choose the style for this button.
  final SplashScreenDismissMode splashScreenDismissMode;

  /// Set the duration that the splash screen is visible
  /// if [splashScreenDismissMode] is equal to [SplashScreenDismissMode.Timer].
  final Duration splashScreenTimerLength;

  final Text? splashScreenButtonText;

  final Icon splashScreenButtonIcon;

  /// Show the terms and conditions of the app.
  final IconData? splashScreenTermsAndConditionsIcon;

  final Color? backgroundColor;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  bool navigationDone = false;
  bool canNavigate = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.splashScreenDismissMode == SplashScreenDismissMode.timer) {
        timer = Timer(widget.splashScreenTimerLength, () {
          widget.onComplete.call();
        });
      }
      if (navigationDone ||
          widget.splashScreenDismissMode != SplashScreenDismissMode.timer) {
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.splashScreenMode == SplashScreenMode.hide) {
      double indicatorWidth = min(
        MediaQuery.of(context).size.width / 3,
        MediaQuery.of(context).size.height / 3,
      );

      return Material(
        color: Theme.of(context).backgroundColor,
        child: Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: indicatorWidth,
            height: indicatorWidth,
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: indicatorWidth / 10,
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor:
            widget.backgroundColor ?? Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            if (widget.splashScreenBackgroundWidget != null) ...[
              Center(child: widget.splashScreenBackgroundWidget),
            ],
            Column(
              children: <Widget>[
                _buildTermsAndConditions(context),
                _buildCenterWidget(context),
                _buildSplashScreenButton(context),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    if (widget.splashScreenTermsAndConditionsIcon != null) {
      return Expanded(
        flex: 1,
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 10),
              child: SizedBox(
                height: 48,
                width: 48,
                child: GestureDetector(
                  child: Icon(
                    widget.splashScreenTermsAndConditionsIcon,
                    size: 24,
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Expanded(flex: 1, child: Container());
    }
  }

  Widget _buildCenterWidget(BuildContext context) {
    if (widget.splashScreenCenterWidget != null) {
      return Expanded(
        child: Container(
          alignment: Alignment.center,
          child: widget.splashScreenCenterWidget,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildSplashScreenButton(BuildContext context) {
    Widget button;

    if (widget.splashScreenDismissMode != SplashScreenDismissMode.timer) {
      button = widget.splashScreenDismissButton!;
    } else {
      return const Expanded(child: SizedBox.shrink());
    }

    return Expanded(
      flex: 1,
      child: Container(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              widget.onComplete.call();
            },
            child: Builder(
              builder: (context) {
                if (canNavigate) {
                  return button;
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
