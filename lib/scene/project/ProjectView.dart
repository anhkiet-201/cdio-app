import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/component/HouseHorizontalListView.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/model/ProjectRresponseModel.dart';
import 'package:cdio/network/services/QueryServices.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'ViewModel.dart';

class ProjectView extends StatelessWidget {
  const ProjectView(this.project, {super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _ViewModel(context)..fetch(project.projectName ?? ''),
      child: _View(project),
    );
  }
}

class _View extends StatefulWidget {
  const _View(this.project, {super.key});

  final Project project;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final viewModel = Provider.of<_ViewModel>(context);
    return Scaffold(
      appBar: AppBar(),
      body: BaseScrollView.single(
        child: Column(
          children: [
            CDImage(url: widget.project.projectThumbNailUrl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${project.projectName}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('${project.contactInfo}'),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    (project.projectStatus ?? '') == 'DaHoanThanh'
                        ? 'Đã bàn giao'
                        : 'Đang thi công',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('${project.projectDescription}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                      visible: viewModel.house.isNotEmpty,
                      child: HouseHorizontalListView(
                          house: viewModel.house,
                          title: 'Các căn hộ trong dự án',
                          isLoading: viewModel.isLoading)
                  ),
                  const SizedBox(height: 50,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
