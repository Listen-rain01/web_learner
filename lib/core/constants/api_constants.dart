/// API 常量配置
class ApiConstants {
  ApiConstants._();

  /// 基础 URL
  static const String baseUrl = 'http://61.150.84.25:100';

  /// 连接超时时间（毫秒）
  static const int connectTimeout = 30000;

  /// 接收超时时间（毫秒）
  static const int receiveTimeout = 30000;

  /// 发送超时时间（毫秒）
  static const int sendTimeout = 30000;

  // ==================== API 端点 ====================

  /// 登录接口
  static const String login = '/PersonWap/GetPersonInfo';

  /// 获取个人基本信息接口
  static const String myBaseInfo = '/PersonWap/MyBaseInfo';

  // ==================== 题库选择 ====================

  /// 获取可用单位列表（前置步骤）
  static const String selectExamType = '/PersonWap/SelectExamType';

  /// 获取考试类别列表
  static const String getAllTypeEx = '/ExamManger/P_ExamTypeStyle/GetAllTypeEx';

  /// 获取子类别（年份）列表
  static const String getAllChildTypeEx = '/ExamManger/P_ExamTypeStyle/GetAllChildTypeEx';

  /// 获取题库列表
  static const String getExamTypeListExOne = '/ExamManger/P_ExamType/GetExamTypeListExOne';

  /// 设置题库
  static const String saveExamTypeIdsOne = '/ArchiveManger/D_PersonManager/SaveExamTypeIdsOne';

  /// 获取当前题库
  static const String getCurExamTypeOne = '/ArchiveManger/D_Person/GetCurExamTypeOne';
}
