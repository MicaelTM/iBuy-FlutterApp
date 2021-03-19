import 'package:flutter/cupertino.dart';
import 'app_localizations.dart';

class instances {
  String switchCategories (BuildContext context, int catID) {
    switch(catID) {
      case 1:
        return AppLocalizations.of(context).translate('category_text_1');
        break;
      case 2:
        return AppLocalizations.of(context).translate('category_text_2');
        break;
      case 3:
        return AppLocalizations.of(context).translate('category_text_3');
        break;
      case 4:
        return AppLocalizations.of(context).translate('category_text_4');
        break;
      case 5:
        return AppLocalizations.of(context).translate('category_text_5');
        break;
      case 6:
        return AppLocalizations.of(context).translate('category_text_6');
        break;
      case 7:
        return AppLocalizations.of(context).translate('category_text_7');
        break;
      case 8:
        return AppLocalizations.of(context).translate('category_text_8');
        break;
      case 9:
        return AppLocalizations.of(context).translate('category_text_9');
        break;
      case 10:
        return AppLocalizations.of(context).translate('category_text_10');
        break;
      case 11:
        return AppLocalizations.of(context).translate('category_text_11');
        break;
      case 12:
        return AppLocalizations.of(context).translate('category_text_12');
        break;
      case 13:
        return AppLocalizations.of(context).translate('category_text_13');
        break;
      case 14:
        return AppLocalizations.of(context).translate('category_text_14');
        break;
      case 15:
        return AppLocalizations.of(context).translate('category_text_15');
        break;
    }
  }
}