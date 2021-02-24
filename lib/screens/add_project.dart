import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db/database.dart';
import '../widgets/snackbars.dart';

class AddProject extends StatefulWidget {
  const AddProject({Key key}) : super(key: key);

  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  TextEditingController projectNameController;
  TextEditingController billRateController;

  @override
  void initState() {
    super.initState();
    projectNameController = TextEditingController();
    billRateController = TextEditingController();
  }

  @override
  void dispose() {
    projectNameController.dispose();
    billRateController.dispose();
    super.dispose();
  }

  Future<void> saveProject() async {
    final name = projectNameController.text;
    final hourlyBillRate = double.tryParse(billRateController.text);
    await context.read<DB>().projectsDao.addProject(name, hourlyBillRate);
    Navigator.pop(context);
    successSnackBar(context, 'Project saved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New project'),
      ),
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
              onPressed: saveProject,
              color: Colors.blueGrey,
              child: const Text(
                'SAVE',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
