import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class SignaturePad extends StatefulWidget {
  final String label;
  final ValueChanged<Uint8List?> onChanged;
  const SignaturePad({super.key, required this.label, required this.onChanged});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  Uint8List? _image;

  Future<void> _openCapture() async {
    final result = await Navigator.push<Uint8List?>(
      context,
      MaterialPageRoute(builder: (_) => SignatureCapturePage(title: widget.label, initialImage: _image)),
    );
    if (!mounted) return;
    if (result != null) {
      setState(() => _image = result);
      widget.onChanged(result);
    }
  }

  void _clear() {
    setState(() => _image = null);
    widget.onChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold))),
                if (_image != null)
                  TextButton.icon(onPressed: _clear, icon: const Icon(Icons.clear), label: const Text('Clear')),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _openCapture,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _image == null
                    ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.draw_outlined, size: 32), SizedBox(height: 6), Text('Tap to enter signature / thumb impression')]))
                    : Padding(padding: const EdgeInsets.all(8), child: Image.memory(_image!, fit: BoxFit.contain)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignatureCapturePage extends StatefulWidget {
  final String title;
  final Uint8List? initialImage;
  const SignatureCapturePage({super.key, required this.title, this.initialImage});

  @override
  State<SignatureCapturePage> createState() => _SignatureCapturePageState();
}

class _SignatureCapturePageState extends State<SignatureCapturePage> {
  final List<Offset?> _points = [];
  bool _hasInk = false;

  @override
  void initState() {
    super.initState();
    // An image is displayed by the parent; editing an existing image starts with a blank pad.
  }

  void _clear() {
    setState(() {
      _points.clear();
      _hasInk = false;
    });
  }

  Future<void> _done() async {
    if (!_hasInk) return;
    final recorder = ui.PictureRecorder();
    const size = Size(460, 430);
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 760, 430));
    canvas.drawColor(Colors.white, BlendMode.srcOver);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < _points.length - 1; i++) {
      final a = _points[i];
      final b = _points[i + 1];
      if (a != null && b != null) canvas.drawLine(a, b, paint);
    }
    final guide = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.5;
    canvas.drawLine(const Offset(30, 365), const Offset(730, 365), guide);
    final picture = recorder.endRecording();
    final image = await picture.toImage(760, 430);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (!mounted) return;
    Navigator.pop(context, data?.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(onPressed: _clear, child: const Text('Clear')),
          Padding(padding: const EdgeInsets.only(right: 8), child: FilledButton(onPressed: _done, child: const Text('Done'))),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Sign or make a thumb impression below.', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade500, width: 2), borderRadius: BorderRadius.circular(14)),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (d) => setState(() { _points.add(d.localPosition); _hasInk = true; }),
                    onPanUpdate: (d) => setState(() => _points.add(d.localPosition)),
                    onPanEnd: (_) => _points.add(null),
                    child: CustomPaint(painter: _SignaturePainter(_points), size: Size.infinite),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Use your finger or stylus. The signature will be stored with the record and placed on the PDF.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      if (a != null && b != null) canvas.drawLine(a, b, paint);
    }
    final guide = Paint()..color = Colors.grey.shade300..strokeWidth = 1;
    canvas.drawLine(Offset(24, size.height - 50), Offset(size.width - 24, size.height - 50), guide);
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => oldDelegate.points != points;
}
