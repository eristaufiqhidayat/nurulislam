import 'package:flutter/material.dart';

class CustomToast {
  static OverlayEntry? _currentToast;

  static void show(
    BuildContext context, {
    required String message1,
    String? message2,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double fontSize1 = 15,
    double fontSize2 = 13,
    ToastGravity gravity = ToastGravity.bottom,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Hapus toast sebelumnya jika masih tampil
    _currentToast?.remove();
    _currentToast = null;

    final overlay = Overlay.of(context);

    // Posisi toast
    Alignment alignment = Alignment.bottomCenter;
    EdgeInsets margin = const EdgeInsets.only(bottom: 50);

    switch (gravity) {
      case ToastGravity.top:
        alignment = Alignment.topCenter;
        margin = const EdgeInsets.only(top: 50);
        break;
      case ToastGravity.center:
        alignment = Alignment.center;
        margin = EdgeInsets.zero;
        break;
      case ToastGravity.bottom:
        alignment = Alignment.bottomCenter;
        margin = const EdgeInsets.only(bottom: 50);
        break;
    }

    _currentToast = OverlayEntry(
      builder: (context) => SafeArea(
        child: Container(
          alignment: alignment,
          margin: margin,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 5)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message1,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize1,
                    ),
                  ),
                  Text(
                    message2!,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Tampilkan toast
    overlay.insert(_currentToast!);

    // Hapus setelah duration selesai
    Future.delayed(duration, () {
      _currentToast?.remove();
      _currentToast = null;
    });
  }
}

// ENUM POSISI TOAST
enum ToastGravity { top, center, bottom }
