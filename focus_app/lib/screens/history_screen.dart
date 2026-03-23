import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/session.dart';
import '../providers/session_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _focusedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  /// Groups completed sessions by the calendar date on which they ended.
  ///
  /// Uses [Session.endTime] so the dot appears on the day the work finished,
  /// not the day it started. Falls back to [Session.startTime] as a safety
  /// net (sessions that completed on the same day they started are unaffected).
  Map<DateTime, List<Session>> _groupByDay(List<Session> sessions) {
    final map = <DateTime, List<Session>>{};
    for (final s in sessions) {
      if (!s.wasCompleted) continue;
      final day = _dateOnly(s.endTime ?? s.startTime);
      (map[day] ??= []).add(s);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<SessionProvider>().completedSessions;
    final grouped = _groupByDay(sessions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session History'),
      ),
      body: grouped.isEmpty
          ? const Center(
              child: Text(
                'No completed sessions yet.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : _CalendarView(
              grouped: grouped,
              focusedMonth: _focusedMonth,
              selectedDate: _selectedDate,
              onMonthChanged: (m) => setState(() {
                _focusedMonth = m;
                _selectedDate = null;
              }),
              onDateSelected: (d) => setState(() => _selectedDate = d),
            ),
    );
  }
}

// ── Calendar view ──────────────────────────────────────────────────────────────

class _CalendarView extends StatelessWidget {
  final Map<DateTime, List<Session>> grouped;
  final DateTime focusedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarView({
    required this.grouped,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final selectedSessions =
        selectedDate != null ? (grouped[selectedDate] ?? []) : <Session>[];

    return Column(
      children: [
        _MonthGrid(
          grouped: grouped,
          focusedMonth: focusedMonth,
          selectedDate: selectedDate,
          onMonthChanged: onMonthChanged,
          onDateSelected: onDateSelected,
        ),
        const Divider(height: 1),
        Expanded(
          child: selectedDate == null
              ? const Center(
                  child: Text(
                    'Tap a highlighted date to view sessions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : selectedSessions.isEmpty
                  ? Center(
                      child: Text(
                        'No sessions on ${_formatDate(selectedDate!)}.',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: selectedSessions.length,
                      itemBuilder: (context, index) =>
                          _SessionCard(session: selectedSessions[index]),
                    ),
        ),
      ],
    );
  }
}

// ── Month grid ─────────────────────────────────────────────────────────────────

class _MonthGrid extends StatelessWidget {
  final Map<DateTime, List<Session>> grouped;
  final DateTime focusedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  const _MonthGrid({
    required this.grouped,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  static const _dayLabels = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    // First weekday of the month. Dart weekday: 1=Mon…7=Sun.
    // Convert to Sunday-first offset: Sun=0, Mon=1 … Sat=6.
    final firstOfMonth = focusedMonth;
    final firstDow = firstOfMonth.weekday % 7;
    final daysInMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;

    final cells = <int?>[
      ...List<int?>.filled(firstDow, null),
      for (int d = 1; d <= daysInMonth; d++) d,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          // Month navigation header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => onMonthChanged(
                  DateTime(focusedMonth.year, focusedMonth.month - 1),
                ),
              ),
              Expanded(
                child: Text(
                  '${_monthNames[focusedMonth.month - 1]} ${focusedMonth.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => onMonthChanged(
                  DateTime(focusedMonth.year, focusedMonth.month + 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Day-of-week labels
          Row(
            children: _dayLabels
                .map(
                  (l) => Expanded(
                    child: Center(
                      child: Text(
                        l,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 4),
          // Day cells
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: cells.map((day) {
              if (day == null) return const SizedBox.shrink();

              final date = DateTime(
                focusedMonth.year,
                focusedMonth.month,
                day,
              );
              final hasSessions = grouped.containsKey(date);
              final isSelected = selectedDate == date;
              final isToday = date == todayOnly;

              return GestureDetector(
                onTap: hasSessions ? () => onDateSelected(date) : null,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        )
                      : isToday
                          ? BoxDecoration(
                              border: Border.all(
                                color: colorScheme.primary,
                                width: 1.5,
                              ),
                              shape: BoxShape.circle,
                            )
                          : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : hasSessions
                                  ? colorScheme.primary
                                  : null,
                        ),
                      ),
                      if (hasSessions)
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Session card ───────────────────────────────────────────────────────────────

class _SessionCard extends StatelessWidget {
  final Session session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final typeLabel =
        session.sessionType == SessionType.task ? 'Task' : 'Generic';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + type badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    session.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    typeLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Stats row
            Row(
              children: [
                _Stat(label: 'Duration', value: '${session.actualMinutes} min'),
                const SizedBox(width: 16),
                _Stat(label: 'Planned', value: '${session.plannedMinutes} min'),
                const SizedBox(width: 16),
                _Stat(label: 'XP', value: '+${session.xpEarned}'),
                const SizedBox(width: 16),
                _Stat(
                  label: 'Unlock',
                  value: '${session.unlockMinutesGranted} min',
                ),
              ],
            ),
            // Reflection preview
            if (session.reflectionText != null &&
                session.reflectionText!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(
                session.reflectionText!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
