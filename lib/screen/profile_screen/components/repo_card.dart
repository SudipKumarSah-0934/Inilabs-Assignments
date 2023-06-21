import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_assignments/core/bloc/github_bloc/github_bloc.dart';

import 'package:task_assignments/model/repositries.dart';
import 'package:task_assignments/routes/routes.dart';
import 'package:task_assignments/utils/app_date_utils.dart';
import 'package:task_assignments/utils/app_images.dart';
import 'package:task_assignments/utils/theme.dart';
import 'package:provider/provider.dart';

class RepoCard extends StatelessWidget {
  final Repositries repository;
  const RepoCard({
    Key? key,
    required this.repository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.grey),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          repository.repoName.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              context
                                  .read<GithubBloc>()
                                  .copyRepository(repository.url);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.copy),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              context
                                  .read<GithubBloc>()
                                  .downloadRepository(repository.url, context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.download),
                            ),
                          ),
                          kIsWeb
                              ? Container()
                              : InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    context.read<GithubBloc>().shareRepository(
                                        repository.url, context);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.share),
                                  ),
                                )
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      repository.description.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        repository.language == ""
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    right: 0, top: 8, bottom: 8),
                                child: Text(
                                  repository.language.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 8),
                                ),
                              ),
                        InkWell(
                          borderRadius: BorderRadius.circular(7),
                          onTap: () {
                            Routes.toPage(context,
                                "/profile/${Provider.of<GithubBloc>(context, listen: false).currentUserName}/${repository.repoName}/stars_users",
                                replace: false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  repository.stars.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(7),
                          onTap: () {
                            Routes.toPage(context,
                                "/profile/${Provider.of<GithubBloc>(context, listen: false).currentUserName}/${repository.repoName}/forks_users",
                                replace: false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Image.asset(AppImages.ic_fork,
                                    height: 20,
                                    width: 20,
                                    color: Theme.of(context).iconTheme.color),
                                const SizedBox(width: 3),
                                Text(
                                  repository.forks.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "Last Pushed: ${AppDateUtils.formatDate(repository.lastPushed.toString())}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
