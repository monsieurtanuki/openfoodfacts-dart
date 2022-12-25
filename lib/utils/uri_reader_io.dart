import 'dart:io';
import 'uri_reader.dart';

UriReader getUriReaderInstance() => UriReaderIo();

/// Reader of URI data, "not web" version (i.e. supports `File`)
class UriReaderIo extends UriReader {
  @override
  Future<List<int>> readFileAsBytes(final Uri uri) async =>
      await File.fromUri(uri).readAsBytes();
}
