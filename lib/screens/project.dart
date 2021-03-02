import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/db/database.dart';
import '../services/bloc/work_bloc.dart';
import '../utils/extensions.dart';

/// This page displays a project time entries, and allows to manually create
/// time entries.
class ProjectPage extends StatefulWidget {
  const ProjectPage({
    Key key,
    @required this.project,
  })  : assert(project != null, 'Project should not be null'),
        super(key: key);

  final Project project;

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
      ),
      body: StreamBuilder<Map<DateTime, List<Rush>>>(
        stream: context
            .read<DB>()
            .rushesDao
            .watchProjectRushesByDate(widget.project.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return const Center(
                child: Text('No rush for this project yet'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.keys.length,
                itemBuilder: (context, i) {
                  final day = snapshot.data.keys.elementAt(i);
                  final dayTotal = snapshot.data[day]
                      .map((e) => e.duration)
                      .reduce((a, b) => a + b);
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('EEE, MMM d').format(day),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(
                              'Total: ${dayTotal.pretty()}',
                              style: Theme.of(context).textTheme.headline6,
                            )
                          ],
                        ),
                        for (final rush in snapshot.data[day])
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(rush.prettyInterval),
                              Text(rush.duration.pretty()),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'manual-entry',
            tooltip: 'Manual entry',
            onPressed: () {
              // TODO(areille): manual entries
            },
            child: const Icon(Icons.edit),
          ),
          const SizedBox(height: 16),
          BlocBuilder<WorkBloc, WorkState>(
            builder: (context, state) {
              if (state is InProgress) {
                return FloatingActionButton(
                  tooltip: 'Stop activity',
                  onPressed: () =>
                      context.read<WorkBloc>().add(Stopped(DateTime.now())),
                  child: const Icon(Icons.stop),
                );
              } else {
                return FloatingActionButton(
                  tooltip: 'Start activity',
                  onPressed: () => context
                      .read<WorkBloc>()
                      .add(Started(widget.project.id, DateTime.now())),
                  child: const Icon(Icons.play_arrow),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
