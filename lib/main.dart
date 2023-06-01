import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasteboard demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Colors.purple),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(),
      ),
      home: const MyHomePage(title: 'Pasteboard demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    required this.title,
    super.key,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String prompt = '';

  late final TextEditingController textEditingController =
      TextEditingController();

  late final pasteboard = getPasteboard();

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  void handleCopyHtml() {
    final textToCopy = textEditingController.selectedText;

    if (textToCopy.isEmpty) {
      return;
    }

    if (textToCopy.isEmpty) {
      return;
    }

    pasteboard.clearContents();
    final result = pasteboard.writeHtml(
      '<b><i>$textToCopy</i></b>',
    );
    pasteboard.writeString(textToCopy);

    setState(() {
      prompt = result ? 'Copied "$textToCopy" as HTML!' : 'Failed to copy!';
    });
  }

  void handlePaste() {
    final text = pasteboard.readString();

    if (text == null) {
      setState(() {
        prompt = 'Failed to paste!';
      });
      return;
    }

    textEditingController.pasteString(text);

    setState(() {
      prompt = 'Pasted "$text"!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: TextField(
                autofocus: true,
                controller: textEditingController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Type here',
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: handleCopyHtml,
                  child: const Text(
                    'Copy with formatting',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: handlePaste,
                  child: const Text(
                    'Paste',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              prompt,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

extension on TextEditingController {
  String get selectedText {
    var textToCopy = selection.textInside(text);
    if (textToCopy.isEmpty) {
      textToCopy = text;
    }
    return textToCopy;
  }

  void pasteString(String text) {
    value = value.copyWith(
      text: this.text.replaceRange(
            selection.start,
            selection.end,
            text,
          ),
      selection: TextSelection.collapsed(
        offset: selection.start + text.length,
      ),
    );
  }
}
