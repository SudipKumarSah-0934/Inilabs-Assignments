import 'package:task_assignments/constants/enums.dart';
import 'package:task_assignments/core/service/github_service.dart';
import 'package:task_assignments/model/repositries.dart';
import 'package:task_assignments/model/user.dart';

class GithubRepository {
  final _githubService = GithubService();

  Future<List> getUserRepositoriesList(String? username) =>
      _githubService.getUserRepositoriesList(username);

  Future getUserProfile(String? username) =>
      _githubService.getUserProfile(username);

  Future<List> getActionUserList(
          String? username, ActionUserListType actionUserListType) =>
      _githubService.getActionUserList(username, actionUserListType);

  Future<List> getRepoActionUserList(String? username,
          ActionUserListType actionUserListType, String? repoName) =>
      _githubService.getRepoActionUserList(
          username, actionUserListType, repoName);
}
