abstract class PasteboardInterface {
  bool writeString(String string);

  String? readString();

  bool writeHtml(String htmlBody);

  void clearContents();
}
