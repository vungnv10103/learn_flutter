import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyTask extends StatelessWidget {
  const MyTask({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Space Exploration Planner!"),
      ),
      body: const Column(
        children: [Progress(), TaskList()],
        // children: [MyDropDownMenu(), MyOverlayPortal()],
      ),
    );
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(tasks: [
    const Task(id: 1, label: "Load rocket with supplies"),
    const Task(id: 2, label: "Launch rocket"),
    const Task(id: 3, label: "Circle home planet"),
    const Task(id: 4, label: "head out to the first moon"),
    const Task(id: 5, label: "Launch moon lander #1"),
  ]);
});

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(taskProvider);

    return Column(
      children: tasks
          .map(
            (task) => TaskItem(task: task),
          )
          .toList(),
    );
  }
}

class TaskItem extends ConsumerWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Checkbox(
            value: task.completed,
            onChanged: (newValue) =>
                ref.read(taskProvider.notifier).toggle(task.id)),
        Text(task.label),
      ],
    );
  }
}

class Progress extends ConsumerWidget {
  const Progress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(taskProvider);
    var numCompletedTasks = tasks.where((task) {
      return task.completed;
    }).length;

    return Column(
      children: [
        const Text("You are this far away from exploring the whole universe: "),
        LinearProgressIndicator(value: numCompletedTasks / tasks.length),
      ],
    );
  }
}

@immutable
class Task {
  final int id;
  final String label;
  final bool completed;

  const Task({required this.id, required this.label, this.completed = false});

  Task copyWith({int? id, String? label, bool? completed}) {
    return Task(
        id: id ?? this.id,
        label: label ?? this.label,
        completed: completed ?? this.completed);
  }
}

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier({tasks}) : super(tasks);

  void add(Task task) {
    state = [...state, task];
  }

  void toggle(int taskId) {
    state = [
      for (final item in state)
        if (taskId == item.id)
          item.copyWith(completed: !item.completed)
        else
          item
    ];
  }
}
