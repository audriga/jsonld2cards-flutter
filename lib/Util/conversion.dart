library;

import 'dart:convert';

dynamic tryDecode(data) {
  try {
    return jsonDecode(data);
  } catch (e) {
    return null;
  }
}

/// When parsing markup, and it contains some URI of some sort,
/// sometimes dart already parses it an [Uri] object, but other times it is just
/// a string.
/// This function takes a [String] or [Uri] as [input] and outputs the corresponding [Uri].
/// On error (be that null-input, a parse fail or an input of an unexpected type) returns null.
Uri? tryCastOrParse(dynamic input){
  if (input == null) {
    return null;
  }
  if (input is Uri) {
    return input;
  }
  if (input is String) {
    return Uri.tryParse(input);
  }
  return null;
}

num? tryCastOrParseNum(dynamic input){
  if (input == null) {
    return null;
  }
  if (input is num) {
    return input;
  }
  if (input is String) {
    return num.tryParse(input);
  }
  return null;
}