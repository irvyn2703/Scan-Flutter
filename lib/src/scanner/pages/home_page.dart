import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/scanner_permission_bloc.dart';
import '../pages/scanner_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScannerPermissionBloc()..add(CheckPermission()),
      child: BlocConsumer<ScannerPermissionBloc, ScannerPermissionState>(
        listener: (context, state) {
          if (state is PermissionGranted) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ScannerPage()));
          }
        },
        builder: (context, state) {
          if (state is PermissionChecking) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is PermissionDenied) {
            return Scaffold(
              appBar: AppBar(title: const Text('QR Scanner')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Camera permission is required to scan codes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context
                          .read<ScannerPermissionBloc>()
                          .add(RequestPermission()),
                      child: const Text('Grant Permission'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Scaffold(
            body: Center(child: Text('Checking permissions...')),
          );
        },
      ),
    );
  }
}
