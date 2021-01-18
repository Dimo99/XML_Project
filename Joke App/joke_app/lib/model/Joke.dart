class Joke {
  int id;
  String categoryName;
  String content;

  // Stats
  int numberOfLikes;
  int numberOfHearts;
  int numberOfHaha;
  int numberOfWow;
  int numberOfSad;
  int numberOfFacebookShares;

  Joke({
    this.id,
    this.categoryName,
    this.content,
    this.numberOfLikes = 0,
    this.numberOfHearts = 0,
    this.numberOfHaha = 0,
    this.numberOfWow = 0,
    this.numberOfSad = 0,
    this.numberOfFacebookShares = 0,
  });

  factory Joke.fromData(Map<String, dynamic> data) {
    return Joke(
      id: int.parse(data['id']),
      categoryName: data['categoryName'],
      content: data['content'],
      numberOfLikes: int.parse(data['numberOfLikes']),
      numberOfHearts: int.parse(data['numberOfHearts']),
      numberOfHaha: int.parse(data['numberOfHaha']),
      numberOfWow: int.parse(data['numberOfWow']),
      numberOfSad: int.parse(data['numberOfSad']),
      numberOfFacebookShares: int.parse(data['numberOfFacebookShares']),
    );
  }

  Map<String, dynamic> toData() {
    Map<String, dynamic> data = <String, dynamic> {};

    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['content'] = this.content;
    data['numberOfLikes'] = this.numberOfLikes;
    data['numberOfHearts'] = this.numberOfHearts;
    data['numberOfHaha'] = this.numberOfHaha;
    data['numberOfWow'] = this.numberOfWow;
    data['numberOfSad'] = this.numberOfSad;
    data['numberOfFacebookShares'] = this.numberOfFacebookShares;

    return data;
  }
}