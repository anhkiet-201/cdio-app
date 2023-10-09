import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/network/model/ProjectRresponseModel.dart';
import 'package:cdio/network/services/ProjectService.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class ProjectChoose extends StatelessWidget {
  const ProjectChoose({super.key, required this.picked});
  final Function(Project?) picked;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _ViewModel(context)..fetch(),
      child: _View(picked),
    );
  }
}

class _View extends StatefulWidget {
  const _View(this.picked, {super.key});
  final Function(Project?) picked;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  Project? _selectedProject;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<_ViewModel>(context);
    return BaseScrollView(
      itemCount: viewModel.projects.length,
      isLoading: viewModel.isLoading,
      hasNext: viewModel.hasNext,
      isEmpty: !viewModel.isLoading && viewModel.projects.isEmpty,
      loadingBuilder: (_, __) => _loading(),
      onLoadMore: viewModel.loadMore,
      itemBuilder: (_, index) {
        final project = viewModel.projects[index];
        return GestureDetector(
            child: _listItem(project),
          onTap: () {
              _selectedProject = viewModel.projects[index];
              Navigator.maybeOf(context)?.pop();
          },
        );
      },
    );
  }


  @override
  void dispose() {
    super.dispose();
    widget.picked(_selectedProject);
  }

  SizedBox _listItem(Project project) {
    return SizedBox(
        height: 120,
        child: Row(
          children: [
            CDImage(
              url: project.projectThumbNailUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${project.projectName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      (project.projectStatus ?? '') == 'DaHoanThanh' ? 'Đã bàn giao' : 'Đang thi công',
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                      '${project.projectDescription}',
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        fontSize: 10
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
  }

  Widget _loading() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      height: 120,
      child: Row(
        children: [
          const SizedBox(
            height: 120,
            width: 120,
            child: SkeletonAvatar(),
          ),
          Expanded(
            child: SkeletonParagraph(
              style: const SkeletonParagraphStyle(
                lines: 4,
                spacing: 8
              ),
            ),
          )
        ],
      ),
    );
  }


}

class _ViewModel with ChangeNotifier {
  _ViewModel(this.context);

  final BuildContext context;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final _service = ProjectService.shared;
  int _currentPage = 0;
  
  List<Project> projects = [];
  bool hasNext = false;

  Future<void> fetch({
    bool sortByDesc = true,
    int size = 10,
    bool clear = true
  }) async {
    isLoading = true;
    await _service
        .getAllProject(
        index: _currentPage,
        size: size
    )
        .then((value) {
      if(clear) {
        projects.clear();
      }
      projects.addAll(value.items ?? []);
      hasNext = value.hasNextPage ?? false;
    }).catchError(() {
      context.showSnackBar(SnackBarType.error);
    }).whenComplete(() {
      isLoading = false;
    });
  }

  Future<void> refresh() async {
    _currentPage = 0;
    await fetch();
  }

  Future<void> loadMore() async {
    _currentPage += 1;
    await fetch(clear: false);
  }
}


