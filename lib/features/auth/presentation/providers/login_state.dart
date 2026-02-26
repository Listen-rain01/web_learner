/// 登录状态
class LoginState {
  const LoginState({
    this.idCard = '',
    this.password = '',
    this.rememberAccount = false,
    this.showPassword = false,
    this.isLoading = false,
    this.idCardError,
    this.passwordError,
    this.errorMessage,
  });

  /// 身份证号
  final String idCard;

  /// 密码
  final String password;

  /// 是否记住账号
  final bool rememberAccount;

  /// 是否显示密码
  final bool showPassword;

  /// 是否正在加载
  final bool isLoading;

  /// 身份证号错误信息
  final String? idCardError;

  /// 密码错误信息
  final String? passwordError;

  /// 通用错误信息
  final String? errorMessage;

  /// 复制并修改状态
  LoginState copyWith({
    String? idCard,
    String? password,
    bool? rememberAccount,
    bool? showPassword,
    bool? isLoading,
    String? idCardError,
    bool clearIdCardError = false,
    String? passwordError,
    bool clearPasswordError = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LoginState(
      idCard: idCard ?? this.idCard,
      password: password ?? this.password,
      rememberAccount: rememberAccount ?? this.rememberAccount,
      showPassword: showPassword ?? this.showPassword,
      isLoading: isLoading ?? this.isLoading,
      idCardError: clearIdCardError ? null : (idCardError ?? this.idCardError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  /// 清除错误信息
  LoginState clearErrors() {
    return LoginState(
      idCard: idCard,
      password: password,
      rememberAccount: rememberAccount,
      showPassword: showPassword,
      isLoading: isLoading,
      idCardError: null,
      passwordError: null,
      errorMessage: null,
    );
  }
}
