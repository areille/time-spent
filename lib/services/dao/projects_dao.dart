import 'package:moor/moor.dart';

import '../../data/db/database.dart';

part 'projects_dao.g.dart';

@UseDao(tables: [Projects, Rushes])
class ProjectsDao extends DatabaseAccessor<DB> with _$ProjectsDaoMixin {
  ProjectsDao(DB db) : super(db);

  Stream<List<Project>> watchProjects() => select(projects).watch();

  Future<Project> getById(int id) =>
      (select(projects)..where((p) => p.id.equals(id))).getSingle();

  Future<void> addProject(String name, double hourlyBillRate) {
    return into(projects).insert(
      ProjectsCompanion(
        name: Value(name),
        hourlyBillRate: Value(hourlyBillRate),
      ),
    );
  }

  Future<void> updateProject(
    int id,
    String name,
    double hourlyBillRate,
  ) {
    return (update(projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(
        name: Value(name),
        hourlyBillRate: Value(hourlyBillRate),
      ),
    );
  }

  Future<void> deleteProject(Project project) {
    return transaction(() async {
      await (delete(rushes)..where((rush) => rush.projectId.equals(project.id)))
          .go();
      await delete(projects).delete(project);
    });
  }
}
