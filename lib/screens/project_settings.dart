import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db/database.dart';
import '../utils/delete_dialog.dart';
import '../widgets/snackbars.dart';

class ProjectSettings extends StatefulWidget {
  const ProjectSettings({Key key, @required this.id}) : super(key: key);

  final int id;

  @override
  _ProjectSettingsState createState() => _ProjectSettingsState();
}

class _ProjectSettingsState extends State<ProjectSettings> {
  TextEditingController projectNameController;
  TextEditingController billRateController;
  Project project;

  @override
  void initState() {
    super.initState();
    retrieveProject();
  }

  @override
  void dispose() {
    projectNameController.dispose();
    billRateController.dispose();
    super.dispose();
  }

  Future<void> retrieveProject() async {
    final _project = await context.read<DB>().projectsDao.getById(widget.id);
    setState(() {
      project = _project;
      projectNameController = TextEditingController(text: project.name);
      billRateController =
          TextEditingController(text: project.hourlyBillRate?.toString());
    });
  }

  Future<void> updateProject() async {
    final name = projectNameController.text;
    final hourlyBillRate = double.tryParse(billRateController.text);
    await context
        .read<DB>()
        .projectsDao
        .updateProject(widget.id, name, hourlyBillRate);
    Navigator.pop(context);
    successSnackBar(context, 'Project updated');
  }

  Future<void> deleteProject() async {
    final confirm = await confirmationDialog(
      context,
      'Delete this project ?\nThis action is irreversible',
      'DELETE',
    );
    if (confirm == true) {
      await context.read<DB>().projectsDao.deleteProject(project);
      Navigator.pop(context);
      successSnackBar(context, 'Project deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return project == null
        ? const Scaffold()
        : Scaffold(
            appBar: AppBar(title: Text(project.name)),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: projectNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: 'Project Name',
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: billRateController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: 'Hourly bill rate',
                    ),
                  ),
                  const SizedBox(height: 32),
                  RaisedButton(
                    onPressed: updateProject,
                    color: Colors.blueGrey,
                    child: const Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RaisedButton(
                    onPressed: deleteProject,
                    color: Colors.red,
                    child: const Text(
                      'DELETE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
