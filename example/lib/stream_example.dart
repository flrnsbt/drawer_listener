import 'dart:async';

import 'package:drawer_state_observer/drawer_state_observer.dart';
import 'package:material_ui/material_ui.dart';

/// Example demonstrating the stream-based approach to listen to drawer state.
class StreamExample extends StatefulWidget {
  const StreamExample({super.key});

  @override
  State<StreamExample> createState() => _StreamExampleState();
}

class _StreamExampleState extends State<StreamExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Main Drawer',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'End Drawer',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('End Item 1'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('End Item 2'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: const _StreamExampleBody(),
    );
  }
}

class _StreamExampleBody extends StatefulWidget {
  const _StreamExampleBody();

  @override
  State<_StreamExampleBody> createState() => _StreamExampleBodyState();
}

class _StreamExampleBodyState extends State<_StreamExampleBody> {
  bool _isDrawerOpen = false;
  bool _isEndDrawerOpen = false;
  StreamSubscription<bool>? _drawerSubscription;
  StreamSubscription<bool>? _endDrawerSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Cancel previous subscriptions
    _drawerSubscription?.cancel();
    _endDrawerSubscription?.cancel();

    // Set up new subscriptions
    _drawerSubscription = context.observeDrawer().listen((isOpen) {
      if (mounted) {
        setState(() {
          _isDrawerOpen = isOpen;
        });
      }
    });

    _endDrawerSubscription = context.observeEndDrawer().listen((isOpen) {
      if (mounted) {
        setState(() {
          _isEndDrawerOpen = isOpen;
        });
      }
    });
  }

  @override
  void dispose() {
    _drawerSubscription?.cancel();
    _endDrawerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Stream-based Listener',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          _buildStatusCard('Main Drawer', _isDrawerOpen, Colors.green),
          const SizedBox(height: 16),
          _buildStatusCard('End Drawer', _isEndDrawerOpen, Colors.orange),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'This example uses StreamSubscription to listen to drawer state changes.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, bool isOpen, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOpen ? color.withValues(alpha: 0.2) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isOpen ? color : Colors.grey, width: 2),
      ),
      child: Text(
        '$title: ${isOpen ? "OPEN" : "CLOSED"}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isOpen ? color.withValues(alpha: 0.8) : Colors.grey.shade700,
        ),
      ),
    );
  }
}
