import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo/enum/alert_enum.dart';

class DialogUtils {

  final BuildContext context;
  
  DialogUtils(this.context);

  show({
    String title,
    String content,
    AlertApp dialogApp,
    Function action
  }) {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              ClipOval(
                child: SvgPicture.asset('assets/icon/alert/${_getIconPath(dialogApp)}.svg', 
                  height: 120
                )
              ),
              SizedBox(height: 15),
              Text(title ?? this._getTitle(dialogApp)),
            ]
          ),
          content: Text(content ?? '', textAlign: TextAlign.center),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
              if (action != null) action();
            }, 
            child: Text("OK"))
          ],
        );
      },
    );
  }

  String _getTitle(AlertApp dialogApp) {
    String text;
    switch (dialogApp) {
      case AlertApp.success: text = 'Success'; break;
      case AlertApp.warning: text = 'Warning'; break;
      case AlertApp.erorr: text = 'Error'; break;
      case AlertApp.bug: text = 'Bug'; break;
      default: text = 'Info'; break;
    }
    return text;
  }

  String _getIconPath(AlertApp alertApp) {
    String text;
    switch (alertApp) {
      case AlertApp.success: text = 'success'; break;
      case AlertApp.warning: text = 'warning'; break;
      case AlertApp.erorr: text = 'warning'; break;
      case AlertApp.bug: text = 'warning'; break;
      default: text = 'info'; break;
    }
    return text;
  }
}

