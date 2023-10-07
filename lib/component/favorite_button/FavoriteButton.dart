import 'package:cdio/network/services/UserService.dart';
import 'package:cdio/utils/extensions/context.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton(this.id, {super.key, this.size = 24});
  final double size;
  final int id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _ViewModel(context, id)..init(),
      child: _View(size),
    );
  }
}

class _View extends StatefulWidget {
  const _View(this.size, {super.key});
  final double size;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  late _ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<_ViewModel>(context);
    return Visibility(
      visible: context.appState.user != null && !_viewModel.hasError,
      child: _viewModel.isLoading ? _loading() : _icon(),
    );
  }

  Widget _icon() {
    return IconButton(
      icon: Icon(_viewModel.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: _viewModel.isFavorite ? Colors.redAccent : Colors.black, size: widget.size,),
      onPressed: () {
        if(_viewModel.isFavorite) {
          _viewModel.removeFavorite();
        } else {
          _viewModel.addFavorite();
        }
      },
    );
  }

  Widget _loading() {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      width: widget.size,
      height: widget.size,
      child: SkeletonAvatar(
        style: SkeletonAvatarStyle(
          borderRadius: BorderRadius.circular(50),
          width: widget.size,
          height: widget.size
        ),
      ),
    );
  }
}

class _ViewModel with ChangeNotifier {
  final BuildContext context;
  final int id;
  final _service = UserService.shared;

  _ViewModel(this.context, this.id);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  set isFavorite(bool value) {
    _isFavorite = value;
    notifyListeners();
  }

  bool hasError = false;

  init() async {
    isLoading = true;
    await _service.checkIsFavorite(id)
        .then((value) {
      isFavorite = value;
    })
        .onError((error, stackTrace) {
          debugPrintStack(stackTrace: stackTrace);
    })
        .whenComplete(() => isLoading = false);
  }

  Future<void> addFavorite() async {
    isFavorite = true;
    await _service.addFavorite(id: id)
        .then((value) {
      isFavorite = value;
      debugPrint('Add favorite with house id: $id');
    }).onError((error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
    });
  }

  Future<void> removeFavorite() async {
    isFavorite = false;
    await _service.removeFavorite(id: id)
        .then((value) {
      isFavorite = value;
      debugPrint('Remove favorite with house id: $id');
    }).onError((error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
    });
  }

}

