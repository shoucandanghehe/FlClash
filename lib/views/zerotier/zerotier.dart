import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/controller.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ZeroTierView extends ConsumerStatefulWidget {
  const ZeroTierView({super.key});

  @override
  ConsumerState<ZeroTierView> createState() => _ZeroTierViewState();
}

class _ZeroTierViewState extends ConsumerState<ZeroTierView> {
  late TextEditingController _networkIdController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final config = ref.read(zeroTierSettingProvider);
    _networkIdController = TextEditingController(text: config.networkId);
  }

  @override
  void dispose() {
    _networkIdController.dispose();
    super.dispose();
  }

  Future<void> _toggleZeroTier(bool enabled) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      if (enabled) {
        final networkId = _networkIdController.text.trim();
        if (networkId.isEmpty || networkId.length != 16) {
          globalState.showMessage(
            title: 'ZeroTier',
            message: const TextSpan(
              text: 'Network ID must be 16 hex characters',
            ),
          );
          setState(() => _isLoading = false);
          return;
        }

        // Save config
        ref.read(zeroTierSettingProvider.notifier).update(
              (state) => state.copyWith(
                enabled: true,
                networkId: networkId,
              ),
            );

        final config = ref.read(zeroTierSettingProvider);
        final result = await appController.ztStart(config);
        if (result.isNotEmpty) {
          globalState.showMessage(
            title: 'ZeroTier',
            message: TextSpan(text: 'Error: $result'),
          );
          ref.read(zeroTierSettingProvider.notifier).update(
                (state) => state.copyWith(enabled: false),
              );
        }
      } else {
        final result = await appController.ztStop();
        ref.read(zeroTierSettingProvider.notifier).update(
              (state) => state.copyWith(enabled: false),
            );
        if (result.isNotEmpty) {
          globalState.showMessage(
            title: 'ZeroTier',
            message: TextSpan(text: 'Error: $result'),
          );
        }
      }

      // Refresh status
      await appController.refreshZtStatus();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickPlanetFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;

    final file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();
    final base64Data = base64Encode(bytes);

    ref.read(zeroTierSettingProvider.notifier).update(
          (state) => state.copyWith(planetData: base64Data),
        );
  }

  void _clearPlanetData() {
    ref.read(zeroTierSettingProvider.notifier).update(
          (state) => state.copyWith(planetData: ''),
        );
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(zeroTierSettingProvider);
    final status = ref.watch(zeroTierStateProvider);

    return CommonScaffold(
      title: 'ZeroTier',
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Status card
          _buildStatusCard(status, config.enabled),
          const SizedBox(height: 16),

          // Network ID input
          ..._buildConfigSection(config),
          const SizedBox(height: 16),

          // Custom planet
          ..._buildPlanetSection(config),

          // Routes display
          if (status.routes.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._buildRoutesSection(status),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCard(ZeroTierStatus status, bool enabled) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    status.online ? Icons.cloud_done : Icons.cloud_off,
                    color: status.online
                        ? colorScheme.primary
                        : colorScheme.outline,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      status.online ? 'Online' : 'Offline',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (_isLoading)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Switch(
                      value: enabled,
                      onChanged: _toggleZeroTier,
                    ),
                ],
              ),
              if (status.online) ...[
                const Divider(height: 24),
                _buildInfoRow('Node ID', status.nodeId),
                if (status.assignedIps.isNotEmpty)
                  _buildInfoRow('IP', status.assignedIps.join(', ')),
                if (status.subnet.isNotEmpty)
                  _buildInfoRow('Subnet', status.subnet),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildConfigSection(ZeroTierConfig config) {
    return generateSection(
      title: 'Network',
      items: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _networkIdController,
            decoration: const InputDecoration(
              labelText: 'Network ID',
              hintText: 'e.g. a84ac5c10a7ebb5f',
              border: OutlineInputBorder(),
              helperText: '16-character hex string',
            ),
            maxLength: 16,
            enabled: !config.enabled,
            onChanged: (value) {
              ref.read(zeroTierSettingProvider.notifier).update(
                    (state) => state.copyWith(networkId: value.trim()),
                  );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPlanetSection(ZeroTierConfig config) {
    final hasPlanet = config.planetData.isNotEmpty;
    return generateSection(
      title: 'Custom Planet',
      items: [
        ListItem(
          leading: Icon(
            hasPlanet ? Icons.public : Icons.public_off,
          ),
          title: Text(hasPlanet ? 'Custom Planet loaded' : 'Default Planet'),
          subtitle: Text(
            hasPlanet
                ? '${(base64Decode(config.planetData).length)} bytes'
                : 'Using official ZeroTier root servers',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasPlanet)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: config.enabled ? null : _clearPlanetData,
                ),
              IconButton(
                icon: const Icon(Icons.file_open_outlined),
                onPressed: config.enabled ? null : _pickPlanetFile,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRoutesSection(ZeroTierStatus status) {
    return generateSection(
      title: 'Routes',
      items: [
        for (final route in status.routes)
          ListItem(
            leading: const Icon(Icons.alt_route),
            title: Text(route),
            subtitle: const Text('via ZeroTier'),
          ),
      ],
    );
  }
}
