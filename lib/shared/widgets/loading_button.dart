import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../core/theme/app_theme.dart';

class LoadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;
  final bool isOutlined;
  final Color? loadingColor;
  final double? loadingSize;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
    this.isOutlined = false,
    this.loadingColor,
    this.loadingSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: _buildChild(),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitThreeBounce(
            color: loadingColor ?? Colors.white,
            size: loadingSize!,
          ),
          const SizedBox(width: 8),
          const Text('Loading...'),
        ],
      );
    }

    return child;
  }
}

class LoadingIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final bool isLoading;
  final Color? color;
  final double? size;
  final Color? loadingColor;
  final double? loadingSize;
  final String? tooltip;

  const LoadingIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.isLoading = false,
    this.color,
    this.size,
    this.loadingColor,
    this.loadingSize = 16,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SpinKitThreeBounce(
              color: loadingColor ?? AppTheme.primaryColor,
              size: loadingSize!,
            )
          : Icon(
              icon,
              color: color,
              size: size,
            ),
      tooltip: tooltip,
    );
  }
}

class LoadingFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? loadingColor;
  final double? loadingSize;
  final String? tooltip;
  final bool mini;

  const LoadingFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.loadingColor,
    this.loadingSize = 20,
    this.tooltip,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: isLoading ? null : onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      tooltip: tooltip,
      mini: mini,
      child: isLoading
          ? SpinKitThreeBounce(
              color: loadingColor ?? Colors.white,
              size: loadingSize!,
            )
          : child,
    );
  }
}