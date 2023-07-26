class Journal {
  final int? id;
  final String? title;
  final String ?content;
  final String? mood;
  final String? date;
  Journal(
      {this.id,
       this.title,
       this.content,
       this.mood,
       this.date});

  Map<String, dynamic> toMap() {
    return {'title': title, 'content': content, 'mood': mood, 'date': date};
  }
}