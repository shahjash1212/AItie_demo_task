import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityBanner extends StatefulWidget {
  final Widget child;
  const ConnectivityBanner({super.key, required this.child});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOffline = false;
  bool _showBanner = false;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _checkInitialStatus();

    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _checkInitialStatus() async {
    final results = await Connectivity().checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    bool offline = results.contains(ConnectivityResult.none);

    setState(() {
      _isOffline = offline;
      if (offline) {
        _showBanner = true;
        _timer?.cancel();
      } else {
        if (_showBanner) {
          _timer = Timer(const Duration(seconds: 2), () {
            setState(() => _showBanner = false);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          top: _showBanner ? 80 : -100,
          left: 0,
          right: 0,
          child: Material(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              color: _isOffline ? Colors.red : Colors.green,
              alignment: Alignment.center,
              child: Text(
                _isOffline ? "You are offline" : "Back online!",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
