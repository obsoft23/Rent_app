import 'dart:math' as math;
import 'package:flutter/material.dart';

class ViewAgentMetricsPage extends StatelessWidget {
  final AgentMetrics? metrics;

  const ViewAgentMetricsPage({super.key, this.metrics});

  AgentMetrics get _m => metrics ?? AgentMetrics.sample();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Metrics'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderCard(metrics: _m),
          const SizedBox(height: 16),
          _MetricsGrid(metrics: _m),
          const SizedBox(height: 24),
          Text('Traffic Overview', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          _TrafficChart(months: _m.trafficLastMonths),
          const SizedBox(height: 24),
          Text('Listing Performance', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          _TopListingsList(listings: _m.topListings),
          const SizedBox(height: 32),
          Text('Insights', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          _Insights(metrics: _m),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined),
            label: const Text('Export report'),
          ),
        ],
      ),
      backgroundColor: cs.surface,
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final AgentMetrics metrics;
  const _HeaderCard({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _Avatar(name: metrics.agentName, imageUrl: metrics.avatarUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(metrics.agentName, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(metrics.email, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                _KpiChip(
                  icon: Icons.star_rate_rounded,
                  label: metrics.rating.toStringAsFixed(1),
                  color: Colors.amber.shade700,
                  background: Colors.amber.withOpacity(.15),
                ),
                const SizedBox(width: 8),
                _KpiChip(
                  icon: Icons.schedule_rounded,
                  label: _formatDuration(metrics.avgResponseTime),
                  color: cs.primary,
                  background: cs.primary.withOpacity(.12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    title: 'This month visits',
                    value: _formatCompact(metrics.visitsThisMonth),
                    icon: Icons.bar_chart_rounded,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStat(
                    title: 'Conversion',
                    value: '${(metrics.conversionRate * 100).toStringAsFixed(1)}%',
                    icon: Icons.trending_up_rounded,
                    color: Colors.teal.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStat(
                    title: 'Avg. response',
                    value: _formatDuration(metrics.avgResponseTime),
                    icon: Icons.timelapse_rounded,
                    color: Colors.indigo.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  const _KpiChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: ShapeDecoration(
        color: background,
        shape: StadiumBorder(side: BorderSide(color: color.withOpacity(.15))),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  final AgentMetrics metrics;
  const _MetricsGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final items = <_MetricItem>[
      _MetricItem(
        title: 'Listings',
        subtitle: 'Total',
        value: _formatCompact(metrics.totalListings),
        icon: Icons.home_work_outlined,
        color: Colors.blue,
      ),
      _MetricItem(
        title: 'Active',
        subtitle: 'Live listings',
        value: _formatCompact(metrics.activeListings),
        icon: Icons.check_circle_outline,
        color: Colors.green,
      ),
      _MetricItem(
        title: 'Paused',
        subtitle: 'Hidden/paused',
        value: _formatCompact(metrics.pausedListings),
        icon: Icons.pause_circle_outline,
        color: Colors.orange,
      ),
      _MetricItem(
        title: 'Inquiries',
        subtitle: 'This month',
        value: _formatCompact(metrics.inquiriesThisMonth),
        icon: Icons.mark_email_unread_outlined,
        color: Colors.purple,
      ),
      _MetricItem(
        title: 'Favorites',
        subtitle: 'This month',
        value: _formatCompact(metrics.favoritesThisMonth),
        icon: Icons.favorite_border,
        color: Colors.pink,
      ),
      _MetricItem(
        title: 'Rating',
        subtitle: 'Out of 5',
        value: metrics.rating.toStringAsFixed(1),
        icon: Icons.star_border_rounded,
        color: Colors.amber.shade800,
      ),
    ];

    final width = MediaQuery.of(context).size.width;
    final columns = width >= 1100 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 110,
      ),
      itemBuilder: (_, i) => _MetricCard(item: items[i]),
    );
  }
}

class _MetricItem {
  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final Color color;
  _MetricItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricItem item;
  const _MetricCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.color.withOpacity(.12),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(item.icon, color: item.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(item.subtitle, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
            Text(item.value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _TrafficChart extends StatelessWidget {
  final List<MonthlyTraffic> months;
  const _TrafficChart({required this.months});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (months.isEmpty) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        decoration: _chartDecoration(context),
        child: Text('No data', style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
      );
    }

    final maxVal = months.map((m) => m.visits).fold<int>(0, (p, e) => math.max(p, e));
    final normalizedMax = math.max(1, maxVal);

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: _chartDecoration(context),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final m in months) ...[
                  Expanded(
                    child: _Bar(
                      value: m.visits / normalizedMax,
                      color: cs.primary,
                      label: _formatCompact(m.visits),
                    ),
                  ),
                  if (m != months.last) const SizedBox(width: 8),
                ]
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final m in months) ...[
                Expanded(
                  child: Text(
                    m.label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                if (m != months.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _chartDecoration(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: cs.outlineVariant),
    );
  }
}

class _Bar extends StatelessWidget {
  final double value; // 0..1
  final Color color;
  final String label;
  const _Bar({required this.value, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, c) {
        final barHeight = (c.maxHeight - 22) * value.clamp(0, 1);
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: barHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
          ],
        );
      },
    );
  }
}

class _TopListingsList extends StatelessWidget {
  final List<ListingPerformance> listings;
  const _TopListingsList({required this.listings});

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return Card(
        child: SizedBox(
          height: 80,
          child: Center(
            child: Text('No listings', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listings.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final l = listings[i];
          final conv = l.views == 0 ? 0.0 : l.inquiries / l.views;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: _ListingThumb(title: l.title),
            title: Text(l.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _BulletStat(icon: Icons.visibility_outlined, text: _formatCompact(l.views)),
                    _BulletStat(icon: Icons.mark_email_unread_outlined, text: _formatCompact(l.inquiries)),
                    _BulletStat(icon: Icons.swap_vert_rounded, text: '${(conv * 100).toStringAsFixed(1)}%'),
                  ],
                ),
                const SizedBox(height: 8),
                _ProgressLine(progress: conv.clamp(0, 1), color: Colors.teal),
              ],
            ),
            trailing: _StatusChip(status: l.status),
          );
        },
      ),
    );
  }
}

class _ListingThumb extends StatelessWidget {
  final String title;
  const _ListingThumb({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.12),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.apartment_rounded, color: cs.primary),
    );
  }
}

class _BulletStat extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BulletStat({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
      ],
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final double progress; // 0..1
  final Color color;
  const _ProgressLine({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: progress.clamp(0, 1),
        minHeight: 6,
        color: color,
        backgroundColor: cs.surfaceContainerHighest,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final ListingStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color fg;
    final Color bg;
    final String label;
    switch (status) {
      case ListingStatus.active:
        fg = Colors.green.shade800;
        bg = Colors.green.withOpacity(.12);
        label = 'Active';
        break;
      case ListingStatus.paused:
        fg = Colors.orange.shade800;
        bg = Colors.orange.withOpacity(.12);
        label = 'Paused';
        break;
      case ListingStatus.archived:
        fg = Colors.grey.shade800;
        bg = Colors.grey.withOpacity(.16);
        label = 'Archived';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: ShapeDecoration(
        color: bg,
        shape: StadiumBorder(side: BorderSide(color: fg.withOpacity(.15))),
      ),
      child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

class _Insights extends StatelessWidget {
  final AgentMetrics metrics;
  const _Insights({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final tips = <String>[
      if (metrics.conversionRate < 0.05)
        'Low conversion. Improve listing photos and descriptions.',
      if (metrics.avgResponseTime > const Duration(hours: 8))
        'Slow response time. Respond faster to increase conversions.',
      if (metrics.activeListings < math.max(1, (metrics.totalListings * 0.6).round()))
        'Many listings are paused. Reactivate high performers.',
      if (metrics.visitsThisMonth < 50)
        'Low traffic. Share your listings on social media.',
    ];

    if (tips.isEmpty) {
      tips.add('Great job! Your metrics look healthy.');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final t in tips) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline, color: cs.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(t, style: theme.textTheme.bodyMedium)),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  const _Avatar({required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? 'A'
        : name.trim().split(RegExp(r'\s+')).map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();
    return CircleAvatar(
      radius: 26,
      backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty) ? NetworkImage(imageUrl!) : null,
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? Text(initials, style: const TextStyle(fontWeight: FontWeight.w700))
          : null,
    );
  }
}

/* ====================== Data Models & Sample ====================== */

class AgentMetrics {
  final String agentName;
  final String email;
  final String? avatarUrl;

  final int totalListings;
  final int activeListings;
  final int pausedListings;

  final int visitsThisMonth;
  final int favoritesThisMonth;
  final int inquiriesThisMonth;

  final double conversionRate; // 0..1
  final Duration avgResponseTime;
  final double rating; // 0..5

  final List<MonthlyTraffic> trafficLastMonths;
  final List<ListingPerformance> topListings;

  AgentMetrics({
    required this.agentName,
    required this.email,
    this.avatarUrl,
    required this.totalListings,
    required this.activeListings,
    required this.pausedListings,
    required this.visitsThisMonth,
    required this.favoritesThisMonth,
    required this.inquiriesThisMonth,
    required this.conversionRate,
    required this.avgResponseTime,
    required this.rating,
    required this.trafficLastMonths,
    required this.topListings,
  });

  factory AgentMetrics.sample() {
    return AgentMetrics(
      agentName: 'Alex Johnson',
      email: 'alex.johnson@example.com',
      avatarUrl: null,
      totalListings: 24,
      activeListings: 16,
      pausedListings: 6,
      visitsThisMonth: 482,
      favoritesThisMonth: 73,
      inquiriesThisMonth: 58,
      conversionRate: 0.092,
      avgResponseTime: const Duration(hours: 6, minutes: 30),
      rating: 4.6,
      trafficLastMonths: [
        MonthlyTraffic(label: 'May', visits: 310),
        MonthlyTraffic(label: 'Jun', visits: 365),
        MonthlyTraffic(label: 'Jul', visits: 402),
        MonthlyTraffic(label: 'Aug', visits: 378),
        MonthlyTraffic(label: 'Sep', visits: 455),
        MonthlyTraffic(label: 'Oct', visits: 482),
      ],
      topListings: [
        ListingPerformance(title: '2BR Apartment • Downtown', views: 920, inquiries: 105, status: ListingStatus.active),
        ListingPerformance(title: 'Studio • Riverside', views: 610, inquiries: 44, status: ListingStatus.active),
        ListingPerformance(title: '3BR Townhouse • West End', views: 410, inquiries: 18, status: ListingStatus.paused),
      ],
    );
  }
}

class MonthlyTraffic {
  final String label;
  final int visits;
  MonthlyTraffic({required this.label, required this.visits});
}

class ListingPerformance {
  final String title;
  final int views;
  final int inquiries;
  final ListingStatus status;

  ListingPerformance({
    required this.title,
    required this.views,
    required this.inquiries,
    required this.status,
  });
}

enum ListingStatus { active, paused, archived }

/* ====================== Helpers ====================== */

String _formatCompact(num n) {
  if (n >= 1000000000) return '${(n / 1000000000).toStringAsFixed(n % 1000000000 == 0 ? 0 : 1)}B';
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(n % 1000000 == 0 ? 0 : 1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
  return n.toStringAsFixed(0);
}

String _formatDuration(Duration d) {
  if (d.inHours >= 24) return '${(d.inHours / 24).floor()}d';
  if (d.inHours >= 1) return '${d.inHours}h';
  final m = d.inMinutes;
  return '${m}m';
}