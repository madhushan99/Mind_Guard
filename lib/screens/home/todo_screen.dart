import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../services/auth_service.dart';
import '../../models/models.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<WellnessTaskModel> _tasks = [];
  bool _isLoading = true;
  final _taskController = TextEditingController();
  final _subtitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await DataService().getTasks();
      if (mounted)
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  double get _progress => _tasks.isEmpty ? 0 : _completedCount / _tasks.length;

  Future<void> _toggleTask(WellnessTaskModel task) async {
    setState(() {
      if (task.isCompleted) {
        task.uncomplete();
      } else {
        task.complete();
      }
    });
    try {
      await DataService().updateTask(task);
    } catch (e) {
      // revert on error
      setState(() {
        if (task.isCompleted)
          task.uncomplete();
        else
          task.complete();
      });
    }
  }

  Future<void> _deleteTask(WellnessTaskModel task) async {
    setState(() => _tasks.remove(task));
    try {
      await DataService().deleteTask(task.id);
    } catch (e) {
      setState(() => _tasks.add(task));
    }
  }

  Future<void> _clearCompleted() async {
    final completed = _tasks.where((t) => t.isCompleted).toList();
    setState(() => _tasks.removeWhere((t) => t.isCompleted));
    for (final task in completed) {
      try {
        await DataService().deleteTask(task.id);
      } catch (_) {}
    }
  }

  void _showAddTaskDialog() {
    _taskController.clear();
    _subtitleController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Add New Task',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A))),
              const SizedBox(height: 20),
              TextField(
                controller: _taskController,
                autofocus: true,
                decoration: _inputDeco('Task name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _subtitleController,
                decoration: _inputDeco('Note (optional)'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_taskController.text.trim().isEmpty) return;
                    final task = WellnessTaskModel(
                      id: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
                          .replaceAllMapped(
                        RegExp(r'[xy]'),
                        (c) {
                          final r = DateTime.now().microsecondsSinceEpoch % 16;
                          final v = c.group(0) == 'x' ? r : (r & 0x3 | 0x8);
                          return v.toRadixString(16);
                        },
                      ),
                      createdAt: DateTime.now(),
                      title: _taskController.text.trim(),
                      subtitle: _subtitleController.text.trim().isEmpty
                          ? 'Tap to mark complete'
                          : _subtitleController.text.trim(),
                    );
                    setState(() => _tasks.insert(0, task));
                    Navigator.pop(context);
                    try {
                      await DataService().saveTask(task);
                    } catch (e) {
                      setState(() => _tasks.remove(task));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Add Task',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mind Guard',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A))),
                    Text('Wellness Checklist',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.calendar_today_outlined,
                      color: Color(0xFF2563EB), size: 20),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Progress card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Daily Progress',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                        '$_completedCount/${_tasks.length} Done',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: _progress,
                                  minHeight: 8,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.3),
                                  valueColor: const AlwaysStoppedAnimation(
                                      Colors.white),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _tasks.isEmpty
                                    ? 'Add your first wellness task!'
                                    : _completedCount == _tasks.length
                                        ? '🎉 All done! Amazing work today!'
                                        : 'Almost there! Your mind will thank you later.',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Today's Tasks",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A))),
                            TextButton(
                              onPressed: _clearCompleted,
                              child: const Text('Clear Completed',
                                  style: TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        if (_tasks.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(32),
                            child: const Column(
                              children: [
                                Icon(Icons.checklist,
                                    size: 48, color: Color(0xFFCBD5E1)),
                                SizedBox(height: 12),
                                Text('No tasks yet. Add one below!',
                                    style: TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 14)),
                              ],
                            ),
                          ),

                        ..._tasks.map((task) => _buildTaskCard(task)),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _showAddTaskDialog,
                            icon: const Icon(Icons.add,
                                color: Colors.white, size: 22),
                            label: const Text('Add New Wellness Task',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(WellnessTaskModel task) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      onDismissed: (_) {
        _deleteTask(task);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task removed')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: task.isCompleted
                ? const Color(0xFFBBF7D0)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _toggleTask(task),
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted
                      ? const Color(0xFF2563EB)
                      : Colors.transparent,
                  border: Border.all(
                    color: task.isCompleted
                        ? const Color(0xFF2563EB)
                        : const Color(0xFFCBD5E1),
                    width: 2,
                  ),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: task.isCompleted
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF0F172A),
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(task.subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
