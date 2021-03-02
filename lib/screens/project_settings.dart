import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db/database.dart';
import '../utils/delete_dialog.dart';
import '../widgets/snackbars.dart';

/// This page allows to change project name, billing rate, and deletion
class ProjectSettings extends StatefulWidget {
  const ProjectSettings({Key key, @required this.project})
      : assert(project != null, 'Project should not be null'),
        super(key: key);

  final Project project;

  @override
  _ProjectSettingsState createState() => _ProjectSettingsState();
}

class _ProjectSettingsState extends State<ProjectSettings> {
  TextEditingController projectNameController;
  TextEditingController billRateController;

  @override
  void initState() {
    super.initState();
    projectNameController = TextEditingController(text: widget.project.name);
    billRateController =
        TextEditingController(text: widget.project.hourlyBillRate?.toString());
  }

  @override
  void dispose() {
    projectNameController.dispose();
    billRateController.dispose();
    super.dispose();
  }

  Future<void> updateProject() async {
    final name = projectNameController.text;
    final hourlyBillRate = double.tryParse(billRateController.text);
    await context
        .read<DB>()
        .projectsDao
        .updateProject(widget.project.id, name, hourlyBillRate);
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
      await context.read<DB>().projectsDao.deleteProject(widget.project);
      Navigator.pop(context);
      successSnackBar(context, 'Project deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.project.name)),
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
