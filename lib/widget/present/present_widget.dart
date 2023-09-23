import 'package:flutter/material.dart';

part 'present_controller.dart';
part 'present_type.dart';

class PresentWidget extends StatefulWidget {
  const PresentWidget(
      {super.key,
      required this.child,
      required this.controller,
      this.presentDuration = const Duration(milliseconds: 200),
      this.drawerDuration = const Duration(milliseconds: 300),
      this.leftDrawer,
      this.rightDrawer,
      this.leftDrawerBackground = Colors.white,
      this.rightDrawerBackground = Colors.white,
      this.dismissDragLeftDrawer = false,
      this.dismissDragRightDrawer = false,
      this.backgroundColor = Colors.white,
      this.borderRadius = 25});

  final Widget child;
  final PresentController controller;
  final Duration presentDuration;
  final Duration drawerDuration;
  final Widget? leftDrawer;
  final Widget? rightDrawer;
  final Color leftDrawerBackground;
  final Color rightDrawerBackground;
  final bool dismissDragLeftDrawer;
  final bool dismissDragRightDrawer;
  final double borderRadius;
  final Color backgroundColor;

  @override
  State<PresentWidget> createState() => _PresentWidgetAnimationState();
}

class _PresentWidgetAnimationState extends State<PresentWidget>
    with TickerProviderStateMixin {
  late final Animation<Offset> _presentAnimation;
  late final Animation<double> _childAnimation;
  late final Animation<double> _drawerAnimation;
  late final AnimationController _presentController;
  late final AnimationController _drawerController;
  late final AnimationController _childController;

  Size get _size => MediaQuery.of(context).size;

  double get _presentHeight => _size.height * 0.9;

  double get _drawerWidth => (_size.width / 10) * 5;

  DrawerStatus get _drawerStatus => widget.controller.drawerStatus;

  @override
  void initState() {
    /// present animation controller
    _presentController =
        AnimationController(vsync: this, duration: widget.presentDuration);

    /// drawer animation controller
    _drawerController = AnimationController(
        vsync: this,
        duration: widget.drawerDuration,
        lowerBound: -1.5,
        upperBound: 1.5,
        value: 0);

    /// child animation controller
    _childController = AnimationController(
        vsync: this,
        duration: widget.presentDuration,
        lowerBound: 0,
        upperBound: 1.5,
        value: 0);

    /// animation tween
    _drawerAnimation = _drawerController.view;
    _presentAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(_presentController);
    _childAnimation = _childController.view;
    widget.controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _presentController.dispose();
    _drawerController.dispose();
    _childController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PresentWidget oldWidget) {
    oldWidget.controller.hidePresent();
    super.didUpdateWidget(widget);
    oldWidget.controller.removeListener(_listener);
    widget.controller.addListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.controller.action == PresentAction.show ||
            widget.controller.drawerStatus != DrawerStatus.hide) {
          _hidePresent();
          _hideDrawer();
        } else {
          return true;
        }
        return false;
      },
      child: Scaffold(
          backgroundColor: widget.backgroundColor,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              /// left drawer
              AnimatedBuilder(
                animation: _drawerAnimation,
                builder: (BuildContext context, Widget? child) {
                  final value = 1 - _drawerAnimation.value;
                  return Transform.translate(
                    offset: Offset((value < 0 ? 0 : value) * (-_size.width), 0),
                    child: child!,
                  );
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: _size.width,
                  color: widget.leftDrawerBackground,
                  child: SizedBox(
                    width: _drawerWidth,
                    child: widget.leftDrawer,
                  ),
                ),
              ),

              /// right drawer
              AnimatedBuilder(
                animation: _drawerAnimation,
                builder: (BuildContext context, Widget? child) {
                  final value = 1 + _drawerAnimation.value;
                  return Transform.translate(
                    offset: Offset((value < 0 ? 0 : value) * (_size.width), 0),
                    child: child!,
                  );
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  width: _size.width,
                  color: widget.rightDrawerBackground,
                  child: SizedBox(
                    width: _drawerWidth,
                    child: widget.rightDrawer,
                  ),
                ),
              ),

              /// main child
              AnimatedBuilder(
                animation: _drawerAnimation,
                builder: (_, child) {
                  return GestureDetector(
                    onHorizontalDragUpdate: _handleChildHorizontalUpdate,
                    onHorizontalDragEnd: _handleChildHorizontalEnd,
                    child: Transform.translate(
                      offset:
                          Offset(_drawerAnimation.value * (_drawerWidth), 0),
                      child: child!,
                    ),
                  );
                },
                child: AnimatedBuilder(
                  animation: _childAnimation,
                  builder: (_, __) {
                    return Transform.scale(
                      scale: 0.85 + (0.15 * (1 - _childAnimation.value.abs())),
                      child: AnimatedBuilder(
                        animation: _childAnimation,
                        builder: (_, child) {
                          final offset = 5 * _childAnimation.value.abs();
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    widget.borderRadius *
                                        _childAnimation.value.abs())),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(-offset, -offset),
                                      blurRadius: 50,
                                      spreadRadius: 10),
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(offset, offset),
                                      blurRadius: 1,
                                      spreadRadius: 2)
                                ]),
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    widget.borderRadius *
                                        _childAnimation.value.abs())),
                                child: child!),
                          );
                        },
                        child: SizedBox(
                          height: _size.height,
                          width: _size.width,
                          child: widget.child,
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// present shadow
              AnimatedBuilder(
                  animation: _presentController,
                  builder: (_, __) {
                    return Visibility(
                      visible: _presentController.value != 0,
                      child: Opacity(
                        opacity: _presentController.value,
                        child: Container(
                          color: Colors.black26,
                        ),
                      ),
                    );
                  }),

              /// present
              GestureDetector(
                onVerticalDragUpdate: _handleVerticalUpdate,
                onVerticalDragEnd: _handleVerticalEnd,
                child: SlideTransition(
                  position: _presentAnimation,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: SizedBox(
                      width: _size.width,
                      height: _presentHeight,
                      child: widget.controller._content,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

extension on _PresentWidgetAnimationState {
  void _handleVerticalUpdate(DragUpdateDetails updateDetails) {
    var delta = updateDetails.primaryDelta!;
    var fractionDragged = delta / _presentHeight;
    if (widget.controller.dismissible) {
      _childController.value = _presentController.value -= fractionDragged;
    } else {
      _childController.value = _presentController.value -=
          _presentController.value * fractionDragged;
    }
  }

  void _handleVerticalEnd(DragEndDetails endDetails) {
    var velocity = endDetails.primaryVelocity!;
    if (!widget.controller.dismissible) {
      widget.controller._onDismissPreventedCallback?.call();
      _showPresent();
      return;
    }
    if (velocity > 500) {
      _hidePresent(clear: true);
      return;
    }
    if (_presentController.value >= 0.5) {
      _showPresent();
    } else {
      _hidePresent(clear: true);
    }
  }

  void _handleChildHorizontalUpdate(DragUpdateDetails updateDetails) {
    if (widget.dismissDragLeftDrawer &&
        updateDetails.delta.dx > 0 &&
        _drawerController.value >= 0) return;
    if (widget.dismissDragRightDrawer &&
        updateDetails.delta.dx < 0 &&
        _drawerController.value <= 0) return;
    var delta = updateDetails.primaryDelta!;
    var fractionDragged = delta / _size.width;
    _drawerController.value += fractionDragged;
    _childController.value += fractionDragged.abs();
  }

  void _handleChildHorizontalEnd(DragEndDetails endDetails) {
    var velocity = endDetails.primaryVelocity!;
    if (velocity.abs() > 500) {
      if (_drawerStatus == DrawerStatus.hide) _hideDrawer();
      if (_drawerStatus == DrawerStatus.left) _showLeftDrawer();
      if (_drawerStatus == DrawerStatus.right) _showRightDrawer();
    }
    if (_drawerStatus == DrawerStatus.hide && _drawerController.value <= -0.3) {
      _showRightDrawer();
      return;
    }
    if (_drawerStatus == DrawerStatus.hide && _drawerController.value >= 0.3) {
      _showLeftDrawer();
      return;
    }
    if (_drawerController.value.abs() < 0.7) {
      _hideDrawer();
    } else {
      if (_drawerStatus == DrawerStatus.left) _showLeftDrawer();
      if (_drawerStatus == DrawerStatus.right) _showRightDrawer();
    }
  }

  void _showPresent() {
    widget.controller.action = PresentAction.show;
    widget.controller.notifyListeners();
  }

  void _hidePresent({bool clear = false}) {
    widget.controller.hidePresent(clear: clear);
  }

  void _showLeftDrawer() {
    widget.controller.drawerStatus = DrawerStatus.left;
    widget.controller.notifyListeners();
  }

  void _hideDrawer() {
    widget.controller.drawerStatus = DrawerStatus.hide;
    widget.controller.notifyListeners();
  }

  void _showRightDrawer() {
    widget.controller.drawerStatus = DrawerStatus.right;
    widget.controller.notifyListeners();
  }

  void _listener() {
    if (widget.controller.action == PresentAction.show) {
      _presentController.forward();
      _drawerController.animateTo(0);
      widget.controller._drawerStatus = DrawerStatus.hide;
      _childController.animateTo(1);
      setState(() {});
      return;
    } else {
      _presentController.reverse().then((value) {
        widget.controller._onHide();
      });
    }
    switch (widget.controller.drawerStatus) {
      case DrawerStatus.right:
        _childController.animateTo(1);
        _drawerController.animateTo(-1);
        break;
      case DrawerStatus.left:
        _childController.animateTo(1);
        _drawerController.animateTo(1);
        break;
      case DrawerStatus.hide:
        _childController.animateTo(0);
        _drawerController.animateTo(0);
        break;
    }
  }
}
