import 'package:material_ui/material_ui.dart';
import 'package:drawer_state_observer/drawer_state_observer.dart';

/// Example demonstrating the widget-based approach using DrawerStateObserver.
class WidgetExample extends StatelessWidget {
  const WidgetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Approach'),
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
      body: const _WidgetExampleBody(),
    );
  }
}

class _WidgetExampleBody extends StatelessWidget {
  const _WidgetExampleBody();

  @override
  Widget build(BuildContext context) {
    return DrawerStateObserver(
      builder: (context, isDrawerOpen, isEndDrawerOpen, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'DrawerStateObserver',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              _buildStatusCard('Main Drawer', isDrawerOpen, Colors.green),
              const SizedBox(height: 16),
              _buildStatusCard('End Drawer', isEndDrawerOpen, Colors.orange),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'This example uses the DrawerStateObserver widget to rebuild '
                  'the UI when drawer state changes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      },
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
