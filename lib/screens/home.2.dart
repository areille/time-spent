import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../data/db/database.dart';
import '../services/bloc/work_bloc.dart';
import 'add_project.dart';
import 'project.dart';
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
                itemBuilder: (context, i) =>
                    _ProjectCard(project: snapshot.data[i]),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddProject()),
        ),
        tooltip: 'Create project',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    Key key,
    @required this.project,
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProjectPage(project: project)),
          ),
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
                      tooltip: 'Project settings',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProjectSettings(project: project),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bar_chart_sharp),
                      tooltip: 'Project stats',
                      onPressed: () {},
                    ),
                    BlocBuilder<WorkBloc, WorkState>(
                      builder: (context, state) => AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        firstChild: IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () => context
                              .read<WorkBloc>()
                              .add(Started(project.id, DateTime.now())),
                        ),
                        secondChild: IconButton(
                          icon: const Icon(Icons.stop),
                          onPressed: () => context
                              .read<WorkBloc>()
                              .add(Stopped(DateTime.now())),
                        ),
                        crossFadeState: state is InProgress
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
