import 'package:material_ui/material_ui.dart';

/// Example demonstrating the PROPER Flutter approach using Scaffold callbacks.
///
/// This is the recommended way to handle drawer state changes in Flutter.
/// Use this approach instead of the drawer_state_observer package whenever possible.
class ProperApproachExample extends StatefulWidget {
  const ProperApproachExample({super.key});

  @override
  State<ProperApproachExample> createState() => _ProperApproachExampleState();
}

class _ProperApproachExampleState extends State<ProperApproachExample> {
  bool _isDrawerOpen = false;
  bool _isEndDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proper Flutter Approach'),
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
      // THIS IS THE PROPER WAY - use Scaffold callbacks
      onDrawerChanged: (isOpen) {
        setState(() {
          _isDrawerOpen = isOpen;
        });
      },
      onEndDrawerChanged: (isOpen) {
        setState(() {
          _isEndDrawerOpen = isOpen;
        });
      },
      body: _ProperApproachBody(
        isDrawerOpen: _isDrawerOpen,
        isEndDrawerOpen: _isEndDrawerOpen,
      ),
    );
  }
}

class _ProperApproachBody extends StatelessWidget {
  const _ProperApproachBody({
    required this.isDrawerOpen,
    required this.isEndDrawerOpen,
  });

  final bool isDrawerOpen;
  final bool isEndDrawerOpen;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          Text(
            '✓ Recommended Approach',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          _buildStatusCard('Main Drawer', isDrawerOpen, Colors.green),
          const SizedBox(height: 16),
          _buildStatusCard('End Drawer', isEndDrawerOpen, Colors.orange),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'This example uses Scaffold\'s onDrawerChanged and onEndDrawerChanged callbacks.\n\n'
              'This is the official, stable, and recommended way to handle drawer state changes in Flutter.',
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
