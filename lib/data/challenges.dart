class Challenge {
  final String title;
  final String content;
  late  bool checked;
  late DateTime startDate;
  late DateTime endDate;

  Challenge({required this.title, required this.content,required this.checked,    required this.startDate,
    required this.endDate,});
}

 List<Challenge> Challenges = [
   Challenge(
     checked: true,
     title: "Digital Detox",
     content:
     "Spend a day away from screens, phones, and computers.\nEngage in offline activities like reading, nature walks, meditation, or quality time with loved ones without digital distractions.",
     startDate: DateTime.now(),
     endDate: DateTime.now().add(Duration(days: 1)),
   ),
   Challenge(
     checked: true,
     title: "Gratitude",
     content:
     "Express gratitude towards people in your life.\nWrite down or tell them what you appreciate about them.",
     startDate: DateTime.now().add(Duration(days: 2)),
     endDate: DateTime.now().add(Duration(days: 3)),
   ),
   Challenge(
     checked: false,
     title: "Fitness",
     content:
     "Incorporate at least 30 minutes of physical activity into your day.\nThis could be a workout, a walk, or any form of exercise you enjoy.",
     startDate: DateTime.now().add(Duration(days: 4)),
     endDate: DateTime.now().add(Duration(days: 5)),
   ),

];
