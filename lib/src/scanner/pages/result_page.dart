import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/result_bloc.dart';
import 'scanner_page.dart';

class ResultPage extends StatelessWidget {
  final String result;
  const ResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResultBloc(result)..add(CheckResultType(result)),
      child: BlocConsumer<ResultBloc, ResultState>(
        listener: (context, state) {
          if (state is ResultError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        if (state is ResultIsUrl) {
                          context.read<ResultBloc>().add(LaunchUrl());
                        } else {
                          context.read<ResultBloc>().add(CopyText());
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Texto copiado al portapapeles'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        state.result.isEmpty
                            ? 'Ocurrió un error'
                            : state.result,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: state is ResultIsUrl
                              ? Colors.blue
                              : Colors.black,
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
                            builder: (_) => const ScannerPage(),
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
        },
      ),
    );
  }
}
