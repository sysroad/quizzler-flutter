import 'dart:collection';
import 'dart:io';
import 'dart:convert';

class Quiz {
  String quiz;
  bool answer;

  Quiz({String q, bool a}) {
    quiz = q;
    answer = a;
  }

  Quiz.fromJson(Map<String,  dynamic> json) {
    quiz = json["Quiz"];
    answer = json["Answer"];
  }

  Map<String, dynamic> toJson() {
    return { 'Quiz': quiz, 'Answer': answer };
  }
}

class QuizBank extends ListBase<Quiz> {
  List<Quiz> container;
  QuizBank(List<Quiz> quizes) {
    container = quizes;
  }

  set length(int newLength) { container.length = newLength; }
  get length => container.length;
  Quiz operator[](int index) => container[index];
  operator []=(int index, Quiz value) { container[index] = value; }

  static QuizBank fromFile(String filename) {
    if (FileSystemEntity.typeSync(filename) == FileSystemEntityType.notFound) {
      return null;
    }

    String content = new File(filename).readAsStringSync();
    final List jsonData =  json.decode(content);

    return QuizBank(jsonData.map((item) => Quiz.fromJson(item)).toList());
  }
}