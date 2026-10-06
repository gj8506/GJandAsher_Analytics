import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  double forecastHorizon = 6;

  @override
  Widget build(BuildContext context) {
    final projectedPkgs = (185 * pow(1.08, forecastHorizon) * (forecastHorizon >= 2 ? 1.15 : 1.0)).round();
    final projectedRevenue = projectedPkgs * 1420;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        Center(
          child: Column(
            children: const [
              Icon(Icons.bar_chart, size: 40, color: AppColors.shipTealAccent),
              SizedBox(height: 8),
              Text(
                'Admin Visual Analytics & Forecasts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.shipNavyPrimary),
              ),
              SizedBox(height: 4),
              Text(
                'Interactive multi-platform line graphs, trends, and predictive forecasting.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // KPI Grid
        Row(
          children: [
            Expanded(child: _buildKpiCard('Total Dispatches', '57 pkgs', '+14.2% vs last week', Colors.green)),
            const SizedBox(width: 8),
            Expanded(child: _buildKpiCard('Outbound GMV', '₱134,850', 'Avg ₱2,365 / parcel', Colors.green)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildKpiCard('Success Rate', '94.7%', '54 delivered / 57 total', Colors.green)),
            const SizedBox(width: 8),
            Expanded(child: _buildKpiCard('Return / RTS Rate', '3.8%', '3 parcels returned', Colors.red)),
          ],
        ),
        const SizedBox(height: 16),

        // Predictive Forecasting Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.shipTealAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.trending_up, color: AppColors.shipTealAccent, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Predictive Forecasting', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('AI Logistics Projections', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      border: Border.all(color: Colors.blue.shade800),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${forecastHorizon.toInt()} Mo Horizon',
                      style: const TextStyle(color: AppColors.shipTealAccent, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('1 Month', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  Text('${forecastHorizon.toInt()} Months Forward', style: const TextStyle(color: AppColors.shipTealAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                  const Text('12 Months', style: TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
              Slider(
                value: forecastHorizon,
                min: 1,
                max: 12,
                divisions: 11,
                activeColor: AppColors.shipTealAccent,
                onChanged: (val) => setState(() => forecastHorizon = val),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Projected Outbound', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          const SizedBox(height: 2),
                          Text('$projectedPkgs pkgs', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Forecasted Revenue', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          const SizedBox(height: 2),
                          Text('₱${(projectedRevenue / 1000).toStringAsFixed(0)}k', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, Color subColor) {
    return Card(
      color: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.shipNavyPrimary)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: subColor, fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
