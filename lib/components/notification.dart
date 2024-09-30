import 'package:flutter/material.dart';

class NotificationAlert extends StatefulWidget {
  final String message;
  final bool isSuccess;

  const NotificationAlert({
    super.key,
    required this.message,
    required this.isSuccess,
  });

  @override
  _NotificationAlertState createState() => _NotificationAlertState();
}

class _NotificationAlertState extends State<NotificationAlert> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..forward().then((_) {
      _animationController.reverse().then((_) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    });

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double alertWidth = screenWidth * 0.6; // 60% of screen width

    return FadeTransition(
      opacity: _animation,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: alertWidth,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: widget.isSuccess ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isSuccess ? Icons.check_circle : Icons.error,
                  color: Colors.white,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

void showNotification(BuildContext context, String message, bool isSuccess) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 20,
      right: 20,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Material(
        color: Colors.transparent,
        child: NotificationAlert(
          message: message,
          isSuccess: isSuccess,
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(const Duration(seconds: 5), () {
    overlayEntry.remove();
  });
}

void showSuccessMsg(BuildContext context, String message) {
  showNotification(context, message, true);
}

void showErrorMsg(BuildContext context, String message) {
  showNotification(context, message, false);
}
