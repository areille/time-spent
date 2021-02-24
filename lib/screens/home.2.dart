import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db/database.dart';
import 'add_project.dart';
import 'project_settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: StreamBuilder<List<Project>>(
        stream: context.read<DB>().projectsDao.watchProjects(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return const Center(child: Text('No projects yet'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  final project = snapshot.data[i];
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 4,
                            bottom: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(project.name),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.settings),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProjectSettings(id: project.id),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.bar_chart_sharp),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.play_arrow_rounded),
                                    onPressed: () {},
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddProject()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
