import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/helmet_provider.dart';
import '../widgets/status_card.dart';
import '../widgets/command_button.dart';

class HelmetControlScreen extends StatelessWidget {
  const HelmetControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HelmetProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Helmet Control')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _StatusCardsGrid(provider: provider),
              const SizedBox(height: 24),
              _PairButton(provider: provider),
              const SizedBox(height: 16),
              _CommandButtonsRow(provider: provider),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCardsGrid extends StatelessWidget {
  final HelmetProvider provider;
  const _StatusCardsGrid({required this.provider});

  @override
  Widget build(BuildContext context) {
    final programStateText = provider.programState.toString().split('.').last;
    final statusCards = [
      StatusCard(
        label: 'Connection',
        value: provider.connectionStatus,
        icon: Icons.link,
        color: provider.connectionStatus == 'Connected'
            ? Colors.green
            : (provider.connectionStatus == 'Connecting...' ? Colors.orange : Colors.red),
      ),
      StatusCard(
        label: 'Program State',
        value: programStateText,
        icon: Icons.play_circle_fill,
        color: provider.programState.name == 'running'
            ? Colors.green
            : (provider.programState.name == 'paused' ? Colors.orange : Colors.grey),
      ),
      StatusCard(
        label: 'Last Command',
        value: provider.lastCommand,
        icon: Icons.history,
        color: Colors.blueGrey,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;
        if (constraints.maxWidth >= 900) {
          columns = 3;
        } else if (constraints.maxWidth >= 600) {
          columns = 2;
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3.6,
          children: statusCards,
        );
      },
    );
  }
}

class _PairButton extends StatelessWidget {
  final HelmetProvider provider;
  const _PairButton({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isConnected = provider.connectionStatus == 'Connected';
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.green.shade300,
          disabledForegroundColor: Colors.white70,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: isConnected
            ? null
            : () {
                provider.connect();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pairing started')),
                );
              },
        icon: Icon(isConnected ? Icons.check_circle : Icons.bluetooth_connected),
        label: Text(isConnected ? 'Connected' : 'Pair',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _CommandButtonsRow extends StatelessWidget {
  final HelmetProvider provider;
  const _CommandButtonsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        CommandButton(
          label: 'Start',
          color: Colors.green,
          enabled: provider.connectionStatus == 'Connected' &&
              provider.programState == ProgramState.idle,
          onPressed: () => provider.sendCommand('start'),
        ),
        CommandButton(
          label: 'Pause',
          color: Colors.orange,
          enabled: provider.connectionStatus == 'Connected' &&
              provider.programState == ProgramState.running,
          onPressed: () => provider.sendCommand('pause'),
        ),
        CommandButton(
          label: 'Continue',
          color: Colors.green,
          enabled: provider.connectionStatus == 'Connected' &&
              provider.programState == ProgramState.paused,
          onPressed: () => provider.sendCommand('continue'),
        ),
        CommandButton(
          label: 'Stop',
          color: Colors.red,
          enabled: provider.connectionStatus == 'Connected' &&
              (provider.programState == ProgramState.running ||
                  provider.programState == ProgramState.paused),
          onPressed: () => provider.sendCommand('stop'),
        ),
      ],
    );
  }
}