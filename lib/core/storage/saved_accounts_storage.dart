import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 已保存账号的本地存储
class SavedAccountsStorage {
  static const _key = 'saved_accounts';
  static const _lastIdCardKey = 'last_id_card';
  static const _accountPasswordsKey = 'account_passwords';
  static const _rememberAccountKey = 'remember_account';

  /// 读取所有已保存的身份证号
  static Future<List<String>> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return [];
    return List<String>.from(jsonDecode(json) as List);
  }

  /// 添加一个账号（自动去重，最新的排在最前）
  static Future<void> saveAccount(String idCard) async {
    final accounts = await loadAccounts();
    accounts.remove(idCard);
    accounts.insert(0, idCard);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(accounts));
  }

  /// 读取所有账号对应的密码 Map
  static Future<Map<String, String>> _loadPasswordMap() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_accountPasswordsKey);
    if (json == null) return {};
    return Map<String, String>.from(jsonDecode(json) as Map);
  }

  /// 保存上次登录的账号、密码和记住状态
  static Future<void> saveLastLogin({
    required String idCard,
    required String password,
    required bool rememberAccount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastIdCardKey, idCard);
    await prefs.setBool(_rememberAccountKey, rememberAccount);
    // 保存该账号对应的密码
    final passwords = await _loadPasswordMap();
    passwords[idCard] = password;
    await prefs.setString(_accountPasswordsKey, jsonEncode(passwords));
  }

  /// 读取指定账号的密码
  static Future<String?> loadPasswordForAccount(String idCard) async {
    final passwords = await _loadPasswordMap();
    return passwords[idCard];
  }

  /// 读取上次登录的账号（仅当记住账号时有值）
  static Future<String?> loadLastIdCard() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_rememberAccountKey) ?? false;
    if (!remember) return null;
    return prefs.getString(_lastIdCardKey);
  }

  /// 读取上次登录的密码（仅当记住账号时有值）
  static Future<String?> loadLastPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_rememberAccountKey) ?? false;
    if (!remember) return null;
    final lastIdCard = prefs.getString(_lastIdCardKey);
    if (lastIdCard == null) return null;
    return loadPasswordForAccount(lastIdCard);
  }

  /// 读取记住账号的勾选状态
  static Future<bool> loadRememberAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberAccountKey) ?? false;
  }

  /// 清除上次登录记录
  static Future<void> clearLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastIdCardKey);
    await prefs.setBool(_rememberAccountKey, false);
  }

  /// 删除一个账号及其密码
  static Future<void> removeAccount(String idCard) async {
    final accounts = await loadAccounts();
    accounts.remove(idCard);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(accounts));
    // 同时删除该账号的密码
    final passwords = await _loadPasswordMap();
    passwords.remove(idCard);
    await prefs.setString(_accountPasswordsKey, jsonEncode(passwords));
  }
}
