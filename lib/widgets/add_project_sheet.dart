import 'package:flutter/material.dart';
import '../models/project_item.dart';

class AddProjectSheet extends StatefulWidget {
  final VoidCallback onClose;
  final ValueChanged<ProjectItem> onSubmit;

  const AddProjectSheet({
    super.key,
    required this.onClose,
    required this.onSubmit,
  });

  @override
  State<AddProjectSheet> createState() => _AddProjectSheetState();
}

class _AddProjectSheetState extends State<AddProjectSheet> {
  static const Color NAVY = Color(0xFF101D6E);

  final _titleC = TextEditingController();
  final _subC = TextEditingController();
  final _deadlineC = TextEditingController(text: '25 Feb 2026');

  String _status = 'To Do';
  int _percent = 0;
  int _total = 1;
  int _done = 0;

  @override
  void dispose() {
    _titleC.dispose();
    _subC.dispose();
    _deadlineC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = (_total - _done).clamp(0, 9999);

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x22000000), blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('New Project',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 8),

          _Field(label: 'Title', controller: _titleC, hint: 'Contoh: Renovasi Kantor'),
          const SizedBox(height: 10),
          _Field(label: 'Subtitle', controller: _subC, hint: 'Deskripsi singkat'),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _Dropdown(
                  label: 'Status',
                  value: _status,
                  items: const ['To Do', 'In Progress', 'Done'],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _status = v;
                      if (_status == 'Done') _percent = 100;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Field(
                  label: 'Deadline',
                  controller: _deadlineC,
                  hint: '25 Feb 2026',
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _NumberStepper(
                  label: 'Total Task',
                  value: _total,
                  min: 1,
                  onChanged: (v) => setState(() {
                    _total = v;
                    if (_done > _total) _done = _total;
                  }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _NumberStepper(
                  label: 'Done',
                  value: _done,
                  min: 0,
                  max: _total,
                  onChanged: (v) => setState(() => _done = v),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Text('Progress', style: TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('$_percent%', style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
          Slider(
            value: _percent.toDouble(),
            min: 0,
            max: 100,
            activeColor: NAVY,
            onChanged: (v) => setState(() => _percent = v.round()),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NAVY,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final title = _titleC.text.trim();
                if (title.isEmpty) return;

                widget.onSubmit(
                  ProjectItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    subtitle: _subC.text.trim().isEmpty ? '-' : _subC.text.trim(),
                    percent: _status == 'Done' ? 100 : _percent,
                    status: _status,
                    totalTask: _total,
                    doneTask: _done,
                    remainingTask: remaining,
                    deadline: _deadlineC.text.trim().isEmpty ? '-' : _deadlineC.text.trim(),
                  ),
                );
              },
              child: const Text('Create Project', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;

  const _Field({required this.label, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

class _NumberStepper extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int? max;
  final ValueChanged<int> onChanged;

  const _NumberStepper({
    required this.label,
    required this.value,
    required this.min,
    this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final canMinus = value > min;
    final canPlus = max == null ? true : value < max!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCBD5FF)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: canMinus ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove),
              ),
              Expanded(
                child: Center(
                  child: Text('$value', style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
              IconButton(
                onPressed: canPlus ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}