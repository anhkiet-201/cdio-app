part of 'present_widget.dart';

class PresentController extends ChangeNotifier {
  DrawerStatus _drawerStatus = DrawerStatus.hide;
  Widget? _content;
  PresentAction _action = PresentAction.hide;
  Function()? _onDismissPreventedCallback;
  late bool _dismissible;
  final List<Function?> _callbacks = [];
  final _PresentStack _presentStack = _PresentStack();
  bool _hideWithoutPop = false;

  PresentController({bool dismissible = true}) {
    _dismissible = dismissible;
  }

  set action(PresentAction newValue) {
    _action = newValue;
    notifyListeners();
  }
  PresentAction get action => _action;

  bool get isShowingPresent => action == PresentAction.show;

  set dismissible(bool newValue) {
    _dismissible = newValue;
    notifyListeners();
  }

  bool get dismissible => _dismissible;

  set drawerStatus(DrawerStatus newValue) {
    _drawerStatus = newValue;
    notifyListeners();
  }

  DrawerStatus get drawerStatus => _drawerStatus;

  void showPresent({required Widget view, Function? callbackViewHide, Function? onPresentHide}) {
    _callbacks.add(onPresentHide);
    _push(view, callbackViewHide);
  }

  void _push(Widget widget, Function? callback) {
    if(action == PresentAction.show) {
      _hidePresentWithoutPop();
      _presentStack.push(view: widget, callback: callback);
      return;
    }
    _presentStack.push(view: widget, callback: callback);
    if(_presentStack.isNotEmpty) {
      _content = _presentStack.peek();
      FocusManager.instance.primaryFocus?.unfocus();
      action = PresentAction.show;
    }
  }

  void _onHide() {
    if(!_hideWithoutPop) {
      _presentStack.pop()?.callback?.call();
    }
    _hideWithoutPop = false;
    if(_presentStack.isNotEmpty) {
      _content = _presentStack.peek();
      FocusManager.instance.primaryFocus?.unfocus();
      action = PresentAction.show;
    } else {
      for (var element in _callbacks) {
        element?.call();
      }
      _content = null;
    }
  }

  void _hidePresentWithoutPop() {
    _hideWithoutPop = true;
    action = PresentAction.hide;
  }

  void hidePresent({bool clear = false}) {
    if(clear) {
      _presentStack.clear();
    }
    _hideWithoutPop = false;
    action = PresentAction.hide;
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void showLeftDrawer() {
    drawerStatus = DrawerStatus.left;
  }

  void showRightDrawer() {
    drawerStatus = DrawerStatus.right;
  }

  void hideDrawer() {
    drawerStatus = DrawerStatus.hide;
  }

  void onDismissPrevented(Function() callback) {
    _onDismissPreventedCallback = callback;
  }
}

class _PresentStack {
  List<_PresentStackItem> views = [];

  _PresentStackItem? pop() {
    if(views.isNotEmpty) {
      return views.removeLast();
    }
    return null;
  }

  push({required Widget view, Function? callback}) => views.add(_PresentStackItem(view, callback));

  Widget peek() => views.last.widget;

  clear() => views.clear();

  bool get isEmpty => views.isEmpty;

  bool get isNotEmpty => views.isNotEmpty;
}

class _PresentStackItem {
  final Widget widget;
  final Function? callback;
  const _PresentStackItem(this.widget, this.callback);
}
