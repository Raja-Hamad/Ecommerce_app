class FaqModel {
  final String id;
  final String adminId;
  final String question;
  final String answer;
  final String type;

  FaqModel({
    required this.adminId,
    required this.answer,
    required this.id,
    required this.question,
    required this.type,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      adminId: json['adminId'] ?? '',
      answer: json['answer'] ?? '',
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "adminId": adminId,
      "question": question,
      "answer": answer,
      "type": type,
    };
  }

  @override
  String toString() {
    return 'FaqModel(id: $id, adminId: $adminId, question: $question, answer: $answer, type: $type)';
  }
}
