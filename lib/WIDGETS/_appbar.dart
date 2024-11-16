import 'package:flutter/material.dart';

class CustomExpandableAppBar extends StatefulWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final String? routeName;
  final Widget? trailing;
  final Widget? flexibleContent;
  final double expandedHeight;
  final double collapsedHeight;
  final bool automaticallyImplyLeading;
  final bool enableDrag;
  final ValueNotifier<double>? heightNotifier;
  final double minHeight;
  final double maxHeight;
  final Duration animationDuration;
  final Curve animationCurve;

  const CustomExpandableAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.routeName,
    this.trailing,
    this.flexibleContent,
    this.expandedHeight = 140.0,
    this.collapsedHeight = 56.0,
    this.automaticallyImplyLeading = true,
    this.enableDrag = true,
    this.heightNotifier,
    this.minHeight = 56.0,
    this.maxHeight = 100.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<CustomExpandableAppBar> createState() => _CustomExpandableAppBarState();
}

class _CustomExpandableAppBarState extends State<CustomExpandableAppBar>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<double> _heightNotifier;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  double _dragStartHeight = 0.0;
  double _currentHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _heightNotifier =
        widget.heightNotifier ?? ValueNotifier(widget.expandedHeight);
    _currentHeight = _heightNotifier.value;

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _heightAnimation = Tween<double>(
      begin: widget.collapsedHeight,
      end: widget.expandedHeight,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    _heightNotifier.addListener(() {
      setState(() {
        _currentHeight =
            _heightNotifier.value.clamp(widget.minHeight, widget.maxHeight);
      });
    });
  }

  @override
  void dispose() {
    if (widget.heightNotifier == null) {
      _heightNotifier.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.enableDrag) return;
    final newHeight = _dragStartHeight - details.primaryDelta!;
    _heightNotifier.value = newHeight.clamp(widget.minHeight, widget.maxHeight);
  }

  void _handleDragStart(DragStartDetails details) {
    _dragStartHeight = _currentHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enableDrag) return;
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() > 300) {
      final targetHeight = velocity < 0 ? widget.maxHeight : widget.minHeight;
      _animateToHeight(targetHeight);
    } else {
      final midPoint = (widget.maxHeight + widget.minHeight) / 2;
      final targetHeight =
          _currentHeight > midPoint ? widget.maxHeight : widget.minHeight;
      _animateToHeight(targetHeight);
    }
  }

  void _animateToHeight(double targetHeight) {
    final initialHeight = _currentHeight;
    final animation = Tween<double>(
      begin: initialHeight,
      end: targetHeight,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    animation.addListener(() {
      _heightNotifier.value = animation.value;
    });

    _animationController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: _currentHeight,
      collapsedHeight: widget.collapsedHeight,
      pinned: true,
      floating: true,
      leading: widget.automaticallyImplyLeading
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBackPressed ??
                  () {
                    if (widget.routeName != null) {
                      Navigator.pushNamed(context, widget.routeName!);
                    } else {
                      Navigator.pop(context);
                    }
                  },
            )
          : null,
      title: widget.title != null
          ? Text(
              widget.title!,
              style: const TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
            )
          : null,
      flexibleSpace: GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragStart: _handleDragStart,
        onVerticalDragEnd: _handleDragEnd,
        child: FlexibleSpaceBar(
          background: widget.flexibleContent,
        ),
      ),
      actions: widget.trailing != null ? [widget.trailing!] : null,
    );
  }
}
