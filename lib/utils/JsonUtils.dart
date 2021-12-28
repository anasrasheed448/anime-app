class JsonUtils {
  /// A very bad and basic check for a valid json
  static bool isValidJson(String json) {
    var conditionA = json.startsWith('{') && json.endsWith('}');
    var conditionB = json.startsWith('[') && json.endsWith(']');
    return conditionA || conditionB;
  }
}
