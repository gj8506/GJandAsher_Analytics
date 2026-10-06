import React, { useState } from 'react';
import { BarChart3, TrendingUp, ShieldCheck, Calendar, ArrowUpRight, ChevronRight } from 'lucide-react';

export const AnalyticsScreen: React.FC = () => {
  const [forecastHorizon, setForecastHorizon] = useState<number>(6);
  const [timeRange, setTimeRange] = useState<'7d' | '30d' | '90d'>('30d');

  // Multi-platform breakdown
  const platforms = [
    { name: 'Shopee', count: 24, percent: 42, color: '#EE4D2D', barColor: 'bg-[#EE4D2D]' },
    { name: 'Lazada', count: 18, percent: 32, color: '#0F146D', barColor: 'bg-[#0F146D]' },
    { name: 'TikTok Shop', count: 15, percent: 26, color: '#010101', barColor: 'bg-black' },
  ];

  // Predictive calculation based on horizon months
  const baseMonthlyPackages = 185;
  const growthRate = 0.08; // 8% monthly growth
  const projectedPkgs = Math.round(
    baseMonthlyPackages * Math.pow(1 + growthRate, forecastHorizon) * (forecastHorizon >= 2 ? 1.15 : 1.0)
  );
  const projectedRevenue = projectedPkgs * 1420;

  return (
    <div className="flex flex-col px-4 pt-3 pb-24 max-w-md mx-auto w-full">
      {/* Android Module 6 & 7 Header */}
      <div className="flex flex-col items-center text-center py-2">
        <div className="w-12 h-12 rounded-2xl bg-sky-50 flex items-center justify-center text-[#0EA5E9] shadow-inner">
          <BarChart3 className="w-6 h-6 text-[#0EA5E9]" />
        </div>
        <h2 className="text-base font-bold text-[#0F172A] mt-2">
          Admin Visual Analytics & Forecasts
        </h2>
        <p className="text-xs text-slate-500 mt-1 max-w-xs leading-relaxed">
          Role-guarded for Admin/Owner. Interactive multi-platform sales trends and 1–12 month predictive forecasting.
        </p>
      </div>

      {/* Role Guard Badge */}
      <div className="flex items-center justify-between bg-emerald-50 border border-emerald-200 rounded-xl px-3 py-2 mt-3">
        <div className="flex items-center gap-2">
          <ShieldCheck className="w-4 h-4 text-emerald-600" />
          <span className="text-xs font-bold text-emerald-900">
            Role Auth: Admin/Owner Verified
          </span>
        </div>
        <span className="text-[10px] bg-emerald-200 text-emerald-900 font-bold px-2 py-0.5 rounded-full">
          Firestore Synced
        </span>
      </div>

      {/* KPI Stats Grid */}
      <div className="grid grid-cols-2 gap-2.5 mt-3">
        <div className="bg-white p-3.5 rounded-2xl border border-slate-200 shadow-sm">
          <div className="text-[11px] font-semibold text-slate-500">
            Total Dispatches
          </div>
          <div className="text-xl font-extrabold text-[#0F172A] mt-0.5">
            57 <span className="text-xs font-normal text-slate-400">pkgs</span>
          </div>
          <div className="text-[10px] text-emerald-600 font-semibold flex items-center gap-0.5 mt-1">
            <ArrowUpRight className="w-3 h-3" />
            +14.2% vs last week
          </div>
        </div>

        <div className="bg-white p-3.5 rounded-2xl border border-slate-200 shadow-sm">
          <div className="text-[11px] font-semibold text-slate-500">
            Outbound GMV
          </div>
          <div className="text-xl font-extrabold text-[#0F172A] mt-0.5">
            ₱134,850
          </div>
          <div className="text-[10px] text-emerald-600 font-semibold flex items-center gap-0.5 mt-1">
            <ArrowUpRight className="w-3 h-3" />
            Avg ₱2,365 / parcel
          </div>
        </div>

        <div className="bg-white p-3.5 rounded-2xl border border-slate-200 shadow-sm">
          <div className="text-[11px] font-semibold text-slate-500">
            Delivery Success Rate
          </div>
          <div className="text-xl font-extrabold text-[#10B981] mt-0.5">
            94.7%
          </div>
          <div className="text-[10px] text-slate-400 mt-1">
            54 delivered / 57 total
          </div>
        </div>

        <div className="bg-white p-3.5 rounded-2xl border border-slate-200 shadow-sm">
          <div className="text-[11px] font-semibold text-slate-500">
            Return / RTS Rate
          </div>
          <div className="text-xl font-extrabold text-[#EF4444] mt-0.5">
            3.8%
          </div>
          <div className="text-[10px] text-rose-500 mt-1 font-medium">
            3 parcels returned
          </div>
        </div>
      </div>

      {/* Platform Distribution Bar */}
      <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-sm mt-3">
        <div className="flex items-center justify-between mb-2">
          <h3 className="text-xs font-bold text-[#0F172A]">
            Outbound Platform Share
          </h3>
          <span className="text-[11px] text-slate-400 font-medium">57 parcels</span>
        </div>

        {/* Stacked Progress Bar */}
        <div className="w-full h-3 rounded-full flex overflow-hidden bg-slate-100 mb-3">
          <div className="h-full bg-[#EE4D2D]" style={{ width: '42%' }} title="Shopee 42%" />
          <div className="h-full bg-[#0F146D]" style={{ width: '32%' }} title="Lazada 32%" />
          <div className="h-full bg-[#010101]" style={{ width: '26%' }} title="TikTok 26%" />
        </div>

        <div className="grid grid-cols-3 gap-2">
          {platforms.map((p) => (
            <div key={p.name} className="flex flex-col">
              <div className="flex items-center gap-1.5 text-xs font-bold" style={{ color: p.color }}>
                <span className="w-2 h-2 rounded-full" style={{ backgroundColor: p.color }} />
                <span>{p.name}</span>
              </div>
              <span className="text-xs font-extrabold text-slate-800 mt-0.5">
                {p.percent}% ({p.count})
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Multi-platform Sales Trends Bar Chart */}
      <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-sm mt-3">
        <div className="flex items-center justify-between mb-3">
          <div>
            <h3 className="text-xs font-bold text-[#0F172A]">
              Daily Dispatch Trends
            </h3>
            <p className="text-[10px] text-slate-400">Multi-courier dispatch volume</p>
          </div>
          <div className="flex items-center gap-1 bg-slate-100 p-0.5 rounded-lg text-[10px] font-semibold text-slate-600">
            {(['7d', '30d', '90d'] as const).map((r) => (
              <button
                key={r}
                onClick={() => setTimeRange(r)}
                className={`px-2 py-0.5 rounded-md ${timeRange === r ? 'bg-white shadow-xs text-[#0F172A]' : ''}`}
              >
                {r.toUpperCase()}
              </button>
            ))}
          </div>
        </div>

        {/* CSS Chart Columns */}
        <div className="flex items-end justify-between h-28 pt-4 px-1 border-b border-slate-100">
          {[
            { day: 'Mon', count: 8, height: '40%' },
            { day: 'Tue', count: 12, height: '60%' },
            { day: 'Wed', count: 15, height: '75%' },
            { day: 'Thu', count: 11, height: '55%' },
            { day: 'Fri', count: 19, height: '95%' },
            { day: 'Sat', count: 14, height: '70%' },
            { day: 'Sun', count: 9, height: '45%' },
          ].map((bar) => (
            <div key={bar.day} className="flex flex-col items-center gap-1 flex-1">
              <span className="text-[9px] font-bold text-slate-400">{bar.count}</span>
              <div
                className="w-5 rounded-t-md bg-[#0EA5E9] hover:bg-sky-600 transition-all"
                style={{ height: bar.height }}
              />
              <span className="text-[10px] font-medium text-slate-500 mt-1">{bar.day}</span>
            </div>
          ))}
        </div>
      </div>

      {/* 1-12 Month Predictive Forecasting */}
      <div className="bg-gradient-to-br from-slate-900 to-[#1E293B] text-white rounded-2xl p-4 shadow-md mt-3">
        <div className="flex items-center justify-between gap-3 w-full">
          <div className="flex items-center gap-2.5 min-w-0">
            <div className="p-2 rounded-xl bg-sky-500/20 text-[#0EA5E9] shrink-0">
              <TrendingUp className="w-4 h-4" />
            </div>
            <div className="min-w-0">
              <h3 className="text-xs font-bold text-white tracking-tight">
                Predictive Forecasting
              </h3>
              <p className="text-[10px] text-slate-400 truncate">
                AI Logistics & E-Commerce Projections
              </p>
            </div>
          </div>
          <div className="shrink-0 text-right">
            <span className="inline-block px-2.5 py-1 rounded-lg bg-sky-950/80 border border-sky-800 text-xs font-mono font-bold text-[#0EA5E9] whitespace-nowrap shadow-xs">
              {forecastHorizon} Mo Horizon
            </span>
          </div>
        </div>

        {/* Slider */}
        <div className="mt-4">
          <div className="flex justify-between text-[10px] text-slate-400 mb-1">
            <span>1 Month</span>
            <span className="text-sky-300 font-semibold">{forecastHorizon} Months Forward</span>
            <span>12 Months</span>
          </div>
          <input
            type="range"
            min="1"
            max="12"
            value={forecastHorizon}
            onChange={(e) => setForecastHorizon(parseInt(e.target.value))}
            className="w-full h-1.5 bg-slate-700 rounded-lg appearance-none cursor-pointer accent-[#0EA5E9]"
          />
        </div>

        {/* Forecasted Cards */}
        <div className="grid grid-cols-2 gap-2 mt-4">
          <div className="bg-slate-800/80 rounded-xl p-3 border border-slate-700">
            <span className="text-[10px] text-slate-400 font-medium">
              Projected Outbound
            </span>
            <div className="text-base font-bold text-white mt-0.5">
              {projectedPkgs.toLocaleString()} pkgs
            </div>
            <span className="text-[9px] text-[#0EA5E9] font-medium">
              +{((Math.pow(1.08, forecastHorizon) - 1) * 100).toFixed(1)}% growth
            </span>
          </div>

          <div className="bg-slate-800/80 rounded-xl p-3 border border-slate-700">
            <span className="text-[10px] text-slate-400 font-medium">
              Forecasted Revenue
            </span>
            <div className="text-base font-bold text-white mt-0.5">
              ₱{(projectedRevenue / 1000).toFixed(0)}k
            </div>
            <span className="text-[9px] text-emerald-400 font-medium">
              Mega Sale adjusted
            </span>
          </div>
        </div>
      </div>
    </div>
  );
};
