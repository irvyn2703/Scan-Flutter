import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import '../blocs/scanner_bloc.dart';
import 'result_page.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScannerBloc()..add(StartScanning()),
      child: BlocConsumer<ScannerBloc, ScannerState>(
        listener: (context, state) {
          if (state is ScannerDetected) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => ResultPage(result: state.code)),
            );
          }
        },
        builder: (context, state) {
          return AiBarcodeScanner(
            controller: MobileScannerController(
              formats: [BarcodeFormat.qrCode],
            ),
            onDetect: (BarcodeCapture capture) {
              final code = capture.barcodes.first.rawValue ?? '';
              context.read<ScannerBloc>().add(CodeDetected(code));
            },
            galleryButtonText: "Subir de galería",
            validator: (barcode) => barcode.barcodes.isNotEmpty,
            overlayConfig: const ScannerOverlayConfig(
              borderColor: Colors.blue,
              successColor: Colors.teal,
              errorColor: Colors.orange,
            ),
          );
        },
      ),
    );
  }
}
