import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

Future<String> makeTempFileName([String suffix]) async {
  final tempDir = await getTemporaryDirectory();
  final fileName = Uuid().v1() + (suffix != null ? '.$suffix' : '');
  return path.join(tempDir.path, fileName);
}
