class StudyMaterialEntity {
  const StudyMaterialEntity({
    required this.knowledgeSubjectId,
    required this.title,
    required this.rootUrl,
    this.imageUrl,
    required this.readCount,
    required this.createTime,
  });

  final String knowledgeSubjectId;
  final String title;
  final String rootUrl;
  final String? imageUrl;
  final int readCount;
  final String createTime;
}
