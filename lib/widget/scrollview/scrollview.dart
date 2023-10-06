import 'package:cdio/utils/extensions/object.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_indicator/loading_indicator.dart';

typedef BaseScrollViewItemType = Widget? Function(
    BuildContext context, int index);
typedef BaseScrollViewBuilder = Widget Function(
    BuildContext context, int index);
typedef BaseScrollViewOnRefresh = Future<void> Function();
typedef BaseScrollViewOnLoadMore = Function();

class BaseScrollView extends StatefulWidget {
  BaseScrollView(
      {super.key,
      this.itemCount,
      required this.itemBuilder,
      this.isLoading = false,
      this.loadingBuilder,
      this.onRefresh,
      this.hasNext = false,
      this.endReachedThreshold = 200,
      this.onLoadMore,
      this.spacing = 8,
      this.shrinkWrap = false,
      this.padding}) {
    assert(isLoading == false || loadingBuilder != null);
    _scrollDirection = Axis.vertical;
    slivers = [];
  }

  BaseScrollView.single(
      {super.key,
      required Widget child,
      this.isLoading = false,
      this.loadingBuilder,
      this.onRefresh,
      this.endReachedThreshold = 200,
      this.spacing = 8,
      this.shrinkWrap = false,
      this.padding}) {
    assert(isLoading == false || loadingBuilder != null);
    itemCount = 1;
    itemBuilder = (_, __) => child;
    hasNext = false;
    onLoadMore = null;
    _scrollDirection = Axis.vertical;
    slivers = [];
  }

  BaseScrollView.horizontal(
      {super.key,
      this.itemCount,
      required this.itemBuilder,
      this.isLoading = false,
      this.loadingBuilder,
      this.hasNext = false,
      this.endReachedThreshold = 200,
      this.spacing = 8,
      this.shrinkWrap = false,
      this.onLoadMore,
      this.padding}) {
    assert(isLoading == false || loadingBuilder != null);
    onRefresh = null;
    _scrollDirection = Axis.horizontal;
    slivers = [];
  }

  BaseScrollView.sliver(
      {super.key,
      required this.slivers,
      required Widget body,
      this.isLoading = false,
      this.loadingBuilder,
      this.onRefresh,
      this.endReachedThreshold = 200,
      this.spacing = 8,
      this.shrinkWrap = false,
      this.padding}) {
    assert(isLoading == false || loadingBuilder != null);
    itemCount = 1;
    itemBuilder = (_, __) => body;
    hasNext = false;
    onLoadMore = null;
    _scrollDirection = Axis.vertical;
  }

  late final int? itemCount;
  late final BaseScrollViewItemType itemBuilder;
  final bool isLoading;
  final EdgeInsets? padding;
  late final bool hasNext;
  final BaseScrollViewBuilder? loadingBuilder;
  late final BaseScrollViewOnRefresh? onRefresh;
  late final BaseScrollViewOnLoadMore? onLoadMore;
  final double endReachedThreshold;
  final double spacing;
  late final Axis _scrollDirection;
  late final List<Widget> slivers;
  late final bool shrinkWrap;

  @override
  State<BaseScrollView> createState() => _BaseScrollViewState();
}

class _BaseScrollViewState extends State<BaseScrollView> {
  late final ScrollController _controller;
  late bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BaseScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isLoadingMore = false;
  }

  void _onScroll() {
    if (!_controller.hasClients ||
        widget.isLoading ||
        !widget.hasNext ||
        _isLoadingMore) return;
    final thresholdReached =
        _controller.position.extentAfter < widget.endReachedThreshold;
    if (thresholdReached) {
      _isLoadingMore = true;
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: widget._scrollDirection,
      shrinkWrap: widget.shrinkWrap,
      controller: _controller,
      physics: widget.isLoading
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        if (widget.slivers.isNotEmpty) ...widget.slivers,
        widget.onRefresh != null
            ? SliverPadding(
                padding: widget.padding ??
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                sliver: CupertinoSliverRefreshControl(
                  onRefresh: widget.onRefresh,
                  builder: (
                    BuildContext context,
                    RefreshIndicatorMode refreshState,
                    double pulledExtent,
                    double refreshTriggerPullDistance,
                    double refreshIndicatorExtent,
                  ) {
                    // print();
                    return const Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballPulseSync,
                        ),
                      ),
                    );
                  },
                ),
              )
            : SliverPadding(
                padding: widget._scrollDirection == Axis.vertical
                    ? (widget.padding ??
                        EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top))
                    : EdgeInsets.zero),
        SliverPadding(
          padding: widget.padding.isNotNull
              ? EdgeInsets.only(
                  left: widget.padding!.left,
                  right: widget.padding!.right,
                  bottom: widget.padding!.bottom)
              : EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      reverseDuration: const Duration(milliseconds: 500),
                      child: Padding(
                          padding: widget._scrollDirection == Axis.vertical
                              ? EdgeInsets.only(
                                  bottom: index <
                                          (widget.itemCount ??
                                                  double.infinity) -
                                              1
                                      ? widget.spacing
                                      : 0)
                              : EdgeInsets.only(
                                  right: index <
                                          (widget.itemCount ??
                                                  double.infinity) -
                                              1
                                      ? widget.spacing
                                      : 0),
                          child: widget.isLoading
                              ? widget.loadingBuilder!(context, index)
                              : widget.itemBuilder(context, index)),
                    ),
                childCount: widget.isLoading ? null : widget.itemCount),
          ),
        ),
        if (widget.hasNext && !widget.isLoading)
          const SliverToBoxAdapter(
            child: Center(
              child: SizedBox(
                height: 60,
                width: 60,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballZigZagDeflect,
                ),
              ),
            ),
          )
      ],
    );
  }
}
