import 'package:flutter/material.dart';
import 'package:pasteboard_macos/pasteboard_macos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String prompt = '';

  late final TextEditingController controller = TextEditingController();

  late final pasteboard = PasteboardMacos.general;

  @override
  void initState() {
    super.initState();
    controller.value =
        const TextEditingValue(text: 'Type text to be copied here');
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void handleCopy() {
    var textToCopy = controller.selection.textInside(controller.text);
    if (textToCopy.isEmpty) {
      textToCopy = controller.text;
    }

    final result = pasteboard.writeString(textToCopy, PasteboardType.string);

    setState(() {
      prompt = result ? 'Copied "$textToCopy"!' : 'Failed to copy!';
    });
  }

  void handlePaste() {
    final text = pasteboard.readString(PasteboardType.string);

    if (text == null) {
      setState(() {
        prompt = 'Failed to paste!';
      });
      return;
    }

    controller.value = controller.value.copyWith(
      text: controller.text.replaceRange(
        controller.selection.start,
        controller.selection.end,
        text,
      ),
      selection: TextSelection.collapsed(
        offset: controller.selection.start + text.length,
      ),
    );

    setState(() {
      prompt = 'Pasted "$text"!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: controller,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: handleCopy,
                    child: const Text('Copy'),
                  ),
                  ElevatedButton(
                    onPressed: handlePaste,
                    child: const Text('Paste'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                prompt,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
