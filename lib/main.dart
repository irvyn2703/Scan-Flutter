import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner Flow',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

// -----------------------------------------------------------
// 1️⃣ PANTALLA PRINCIPAL
// -----------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _checkingPermission = true;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
        _checkingPermission = false;
      });
      _openScanner();
    } else {
      final newStatus = await Permission.camera.request();
      setState(() {
        _hasPermission = newStatus.isGranted;
        _checkingPermission = false;
      });
      if (newStatus.isGranted) {
        _openScanner();
      }
    }
  }

  void _openScanner() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ScannerPage()));
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingPermission) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_hasPermission) {
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
                onPressed: _checkCameraPermission,
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      );
    }

    return const Scaffold(
      body: Center(child: Text('Redirecting to scanner...')),
    );
  }
}

// -----------------------------------------------------------
// 2️⃣ PANTALLA DEL ESCÁNER
// -----------------------------------------------------------
class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AiBarcodeScanner(
      controller: MobileScannerController(formats: [BarcodeFormat.qrCode]),
      onDetect: (BarcodeCapture capture) async {
        final barcode = capture.barcodes.first.rawValue ?? '';
        debugPrint("Barcode detected: $barcode");

        await Future.delayed(const Duration(seconds: 1));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ResultPage(result: barcode)),
        );
      },
      galleryButtonText: "Subir de galería",
      validator: (barcode) {
        // Si el valor está vacío o nulo → marcar error
        if (barcode.barcodes.isEmpty) {
          return false; // naranja
        }
        return true; // verde
      },

      overlayConfig: const ScannerOverlayConfig(
        borderColor: Colors.blue,
        successColor: Colors.teal,
        errorColor: Colors.orange,
      ),
    );
  }
}

// -----------------------------------------------------------
// 3️⃣ PANTALLA DE RESULTADO
// -----------------------------------------------------------
class ResultPage extends StatefulWidget {
  final String result;
  const ResultPage({super.key, required this.result});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Future<void> _launchURL() async {
    try {
      await EasyLauncher.url(url: widget.result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace.')),
      );
    }
  }

  Future<void> _copyText() async {
    await Clipboard.setData(ClipboardData(text: widget.result));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Texto copiado al portapapeles')),
    );
  }

  bool get _isValidUrl {
    final uri = Uri.tryParse(widget.result);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_2, size: 150, color: Colors.blue),
              const SizedBox(height: 30),
              const Text(
                'Código escaneado',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _isValidUrl ? _launchURL() : _copyText(),
                child: Text(
                  widget.result.isEmpty ? 'Ocurrió un error' : widget.result,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isValidUrl ? Colors.blue : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ScannerPage(),
                    ),
                  );
                },
                child: const Text('Volver a escanear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
