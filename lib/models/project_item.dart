class ProjectItem {
  final String id;
  final String title;
  final String subtitle;
  final int percent; // 0..100
  final String status; // To Do / In Progress / Done
  final int totalTask;
  final int doneTask;
  final int remainingTask;
  final String deadline; // tampil dulu string (nanti bisa DateTime kalau mau)

  const ProjectItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.percent,
    required this.status,
    required this.totalTask,
    required this.doneTask,
    required this.remainingTask,
    required this.deadline,
  });

  ProjectItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    int? percent,
    String? status,
    int? totalTask,
    int? doneTask,
    int? remainingTask,
    String? deadline,
  }) {
    return ProjectItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      percent: percent ?? this.percent,
      status: status ?? this.status,
      totalTask: totalTask ?? this.totalTask,
      doneTask: doneTask ?? this.doneTask,
      remainingTask: remainingTask ?? this.remainingTask,
      deadline: deadline ?? this.deadline,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'percent': percent,
        'status': status,
        'totalTask': totalTask,
        'doneTask': doneTask,
        'remainingTask': remainingTask,
        'deadline': deadline,
      };

  factory ProjectItem.fromJson(Map<String, dynamic> j) => ProjectItem(
        id: j['id'] as String,
        title: j['title'] as String,
        subtitle: j['subtitle'] as String,
        percent: (j['percent'] as num).toInt(),
        status: j['status'] as String,
        totalTask: (j['totalTask'] as num).toInt(),
        doneTask: (j['doneTask'] as num).toInt(),
        remainingTask: (j['remainingTask'] as num).toInt(),
        deadline: j['deadline'] as String,
      );
}