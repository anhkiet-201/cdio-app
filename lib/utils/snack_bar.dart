import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

extension CDIOSnackBar on BuildContext {
  _showSnackBar(SnackBarType type, {String? customMessage}) {
    final marginValue = MediaQuery.of(this).size.height;
    final statusBarHeight = MediaQuery.of(this).viewPadding.top;
    ScaffoldMessenger.maybeOf(this)
        ?.showSnackBar(
        SnackBar(
            content: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(1, 5),
                    blurRadius: 10,
                    spreadRadius: 1
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    type._icon
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                      child: Text(
                        type._withMessage(customMessage),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  )
                ],
              ),
            ),
          padding: EdgeInsets.only(
            top: statusBarHeight + 10,
            left: 20,
            right: 20,
            bottom: 75
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          dismissDirection: DismissDirection.horizontal,
          // margin: EdgeInsets.only(
          //   bottom:  marginValue - statusBarHeight
          // ),
        )
    );
  }
  
  showSnackBar(SnackBarType type) => _showSnackBar(type);

  showCustomSnackBar(String? message) => _showSnackBar(SnackBarType.custom, customMessage: message ?? '');
  
}

enum SnackBarType {
  success,
  error,
  custom;

  String get _message {
    switch(this) {
      case SnackBarType.success: return 'Success';
      case SnackBarType.error: return 'Error';
      default: return '';
    }
  }

  IconData get _icon {
    switch(this) {
      case SnackBarType.success: return Iconsax.tick_circle;
      case SnackBarType.error: return Iconsax.close_circle;
      default: return Iconsax.info_circle;
    }
  }

  String _withMessage(String? message) => '$_message${this == SnackBarType.custom ? '' : ':'} $message';
}
