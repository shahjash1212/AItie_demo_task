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

  // inside _ConnectivityBannerState
  @override
  void initState() {
    super.initState();
    // 1. Check the status manually ONCE at start
    _checkInitialStatus();

    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _checkInitialStatus() async {
    print('LISTENNINGNGNGGNGNGNGNGNGN --------------');
    final results = await Connectivity().checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    bool offline = results.contains(ConnectivityResult.none);

    // Logic remains the same...
    setState(() {
      _isOffline = offline;
      if (offline) {
        _showBanner = true;
        _timer?.cancel();
      } else {
        // If we were already online at startup, we don't need the 2s banner
        // This check prevents a "Back Online" green flash every time you open the app
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
          top: _showBanner ? 0 : -100, // Slides from above the screen
          left: 0,
          right: 0,
          child: Material(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 10,
              ), // Adjust for status bar
              color: _isOffline ? Colors.red : Colors.green,
              alignment: Alignment.center,
              child: Text(
                _isOffline ? "You are offline" : "Back online!",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
