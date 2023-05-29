import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

void main(List<String> args) async {
  final runner = GenerateCommandRunner();
  final result = await runner.run(args);
  exit(result ?? 0);
}

class GenerateCommandRunner extends CommandRunner<int> {
  GenerateCommandRunner() : super('generate', 'generates all the bindings') {
    Directory(path.join(Directory.current.path, 'tool', 'bindings'))
        .listSync()
        .whereType<File>()
        .where((element) => element.path.endsWith('.yaml'))
        .map((e) => e.path.split('/').last.split('.').first)
        .forEach((element) {
      addCommand(GenerateBidingsCommand(element));
    });
  }
}

class GenerateBidingsCommand extends Command<int> {
  GenerateBidingsCommand(this.name);

  @override
  String get description => 'Generates the $name bindings';

  @override
  final String name;

  @override
  Future<int> run() async {
    final process = await Process.start(
      'dart',
      'run ffigen --config tool/bindings/$name.yaml'.split(' '),
      runInShell: true,
      mode: ProcessStartMode.inheritStdio,
    );

    final result = await process.exitCode;

    return result;
  }
}
