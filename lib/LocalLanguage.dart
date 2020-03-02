@deprecated
class LocalLanguage {
  Map<String, Map<String, String>> _localizedMap = {
    'en': {'upload': 'upload', 'zh': 'Chinese'},
    'zh': {'upload': '上传', 'zh': '中文'}
  };

  Map<String, Map<String, String>> getLanguage() {
    return _localizedMap;
  }
}
