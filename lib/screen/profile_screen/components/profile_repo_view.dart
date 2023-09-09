import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_assignments/core/bloc/github_bloc/github_bloc.dart';
import 'package:task_assignments/model/repositries.dart';

import 'package:task_assignments/screen/profile_screen/components/repo_card.dart';
import 'package:task_assignments/constants/enums.dart';
import 'package:task_assignments/utils/responsive_size.dart';
import 'package:task_assignments/widgets/card_image.dart';
import 'package:task_assignments/widgets/fade_widget.dart';
import 'package:task_assignments/widgets/shimmer_loader.dart';
import 'package:provider/provider.dart';

class ProfileRepoView extends StatefulWidget {
  final bool showProfile;
  final bool showBackButton;
  final String? username;
  final bool isFullPage;
  const ProfileRepoView({
    Key? key,
    required this.showProfile,
    this.showBackButton = false,
    this.username,
    this.isFullPage = false,
  }) : super(key: key);

  @override
  State<ProfileRepoView> createState() => _ProfileRepoViewState();
}

class _ProfileRepoViewState extends State<ProfileRepoView> {
  final ScrollController _scrollController2 = ScrollController();
  bool isGridView = true;
  String selectedFilter = 'Date';
  bool isAscending = true;

  @override
  void initState() {
    if (context.read<GithubBloc>().currentUserState ==
        CurrentUserState.initial &&
        widget.username != null) {
      context.read<GithubBloc>().getUserProfile(widget.username);
    }
    if (context.read<GithubBloc>().currentUserRepoListState ==
        CurrentUserRepoListState.initial &&
        widget.username != null) {
      context.read<GithubBloc>().getUserRepositoriesList(widget.username);
    }

    super.initState();
  }


  void filterRepositories() {
    final githubBloc = context.read<GithubBloc>();

    setState(() {
      switch (selectedFilter) {
        case 'Date':
          githubBloc.currentUserRepoList.sort((a, b) => a.lastPushed.compareTo(b.lastPushed));
          break;
        case 'Name':
          githubBloc.currentUserRepoList.sort((a, b) => a.repoName.compareTo(b.repoName));
          break;
        case 'Star':
          githubBloc.currentUserRepoList.sort((a, b) => a.stars!.compareTo(b.stars!));
          break;
        case 'Fork':
          githubBloc.currentUserRepoList.sort((a, b) => a.forks!.compareTo(b.forks!));
          break;
        default:
          break;
      }

      if (!isAscending) {
        githubBloc.currentUserRepoList = githubBloc.currentUserRepoList.reversed.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GithubBloc>(builder: (context, githubBloc, _) {
      if (githubBloc.currentUserRepoListState ==
          CurrentUserRepoListState.loading) {
        return const ShimmerLoader(
          showPadding: true,
        );
      } else if (githubBloc.currentUserRepoListState ==
          CurrentUserRepoListState.error) {
        return const Center(child: Text("An error occurs"));
      } else if (githubBloc.currentUserRepoListState ==
          CurrentUserRepoListState.loaded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.showProfile,
              child: FadeWidget(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 0,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      widget.showBackButton && !kIsWeb
                          ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                          : Container(),
                      CardImage(
                        imageUrl: githubBloc.currentUser!.imageUrl,
                        height: 35,
                        width: 35,
                        shape: BoxShape.circle,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          githubBloc.currentUser!.name.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(
                top: widget.showProfile ? 0 : 0,
                bottom: 0,
                left: 16,
                right: 5,
              ),
              child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Repositories",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                      filterRepositories();
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Date',
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 5),
                          Text('Date'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Name',
                      child: Row(
                        children: [
                          Icon(Icons.sort_by_alpha),
                          SizedBox(width: 5),
                          Text('Name'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Star',
                      child: Row(
                        children: [
                          Icon(Icons.star),
                          SizedBox(width: 5),
                          Text('Star'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Fork',
                      child: Row(
                        children: [
                          Icon(Icons.device_hub),
                          SizedBox(width: 5),
                          Text('Fork'),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                  onPressed: () {
                    setState(() {
                      isAscending = !isAscending;
                      filterRepositories();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    isGridView ? Icons.view_list : Icons.grid_view,
                  ),
                  onPressed: () {
                    setState(() {
                      isGridView = !isGridView;
                    });
                  },
                ),
              ],
            ),
            ),
            isGridView
                ? Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: LayoutBuilder(builder: (ctx, screen) {
                    dynamic ratio;
                    dynamic count;
                    var size = ResponsiveSize.sizeWidth(context);
                    if (size > 2000) {
                      count = 5;
                      ratio =
                          ResponsiveSize.sizeWidth(context) * 0.22 / 190;
                    } else if (size > 1700) {
                      count = 4;
                      ratio =
                          ResponsiveSize.sizeWidth(context) * 0.22 / 190;
                    } else if (size > 1200) {
                      count = 3;
                      ratio =
                          ResponsiveSize.sizeWidth(context) * 0.35 / 190;
                    } else {
                      count = 2;
                      ratio =
                          ResponsiveSize.sizeWidth(context) * 0.47 / 190;
                    }

                    return ResponsiveSize.sizeWidth(context) > 700
                        ? GridView.builder(
                      physics:
                      const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount:
                      githubBloc.currentUserRepoList.length,
                      itemBuilder: (ctx, proindex) {
                        Repositries repositry = githubBloc
                            .currentUserRepoList[proindex];
                        return RepoCard(repository: repositry);
                      },
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: count,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 1,
                          childAspectRatio: ratio),
                    )
                        : ListView.builder(
                      controller: _scrollController2,
                      shrinkWrap: true,
                      itemCount:
                      githubBloc.currentUserRepoList.length,
                      itemBuilder: (ctx, i) {
                        Repositries repositry =
                        githubBloc.currentUserRepoList[i];
                        return RepoCard(repository: repositry);
                      },
                    );
                  }),
                ),
              ),
            )
                : Expanded(
              child: Container(
                margin:
                const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: githubBloc.currentUserRepoList.length,
                  itemBuilder: (ctx, i) {
                    Repositries repositry =
                    githubBloc.currentUserRepoList[i];
                    return RepoCard(repository: repositry);
                  },
                ),
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }
}
