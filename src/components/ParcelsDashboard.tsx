import React, { useState } from 'react';
import { Parcel, Platform, Courier, ParcelStatus, DateFilterOption } from '../types';
import { Search, Filter, QrCode, Check, Copy, Calendar, RotateCcw, X, ChevronDown, ChevronUp } from 'lucide-react';

interface ParcelsDashboardProps {
  parcels: Parcel[];
  onSelectParcel: (parcel: Parcel) => void;
  userRole: string;
}

export const ParcelsDashboard: React.FC<ParcelsDashboardProps> = ({
  parcels,
  onSelectParcel,
  userRole,
}) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedPlatform, setSelectedPlatform] = useState<Platform | 'All'>('All');
  const [selectedStatus, setSelectedStatus] = useState<ParcelStatus | 'All'>('All');
  const [selectedCourier, setSelectedCourier] = useState<Courier | 'All'>('All');
  const [selectedDateFilter, setSelectedDateFilter] = useState<DateFilterOption>('all');
  const [customStartDate, setCustomStartDate] = useState<string>('2026-10-01');
  const [customEndDate, setCustomEndDate] = useState<string>('2026-10-05');
  const [showFiltersExpanded, setShowFiltersExpanded] = useState<boolean>(true);
  const [copiedId, setCopiedId] = useState<string | null>(null);

  const handleCopy = (e: React.MouseEvent, text: string) => {
    e.stopPropagation();
    navigator.clipboard.writeText(text);
    setCopiedId(text);
    setTimeout(() => setCopiedId(null), 2000);
  };

  const isDateInRange = (parcelDateStr: string): boolean => {
    if (selectedDateFilter === 'all') return true;

    const parcelDate = new Date(parcelDateStr);
    const now = new Date(); // e.g. 2026-10-05

    // Normalize parcel date & reference dates
    const parcelTime = parcelDate.getTime();
    const nowTime = now.getTime();
    const oneDayMs = 24 * 60 * 60 * 1000;

    if (selectedDateFilter === 'today') {
      // Same calendar day check or within last 24h
      const isSameDay =
        parcelDate.getFullYear() === now.getFullYear() &&
        parcelDate.getMonth() === now.getMonth() &&
        parcelDate.getDate() === now.getDate();
      return isSameDay;
    }

    if (selectedDateFilter === 'last_week') {
      // Dispatched within past 7 days
      const sevenDaysAgo = nowTime - 7 * oneDayMs;
      return parcelTime >= sevenDaysAgo && parcelTime <= nowTime + oneDayMs;
    }

    if (selectedDateFilter === 'last_month') {
      // Dispatched within past 30 days
      const thirtyDaysAgo = nowTime - 30 * oneDayMs;
      return parcelTime >= thirtyDaysAgo && parcelTime <= nowTime + oneDayMs;
    }

    if (selectedDateFilter === 'custom') {
      if (!customStartDate && !customEndDate) return true;

      let validStart = true;
      let validEnd = true;

      if (customStartDate) {
        const start = new Date(`${customStartDate}T00:00:00`).getTime();
        validStart = parcelTime >= start;
      }

      if (customEndDate) {
        const end = new Date(`${customEndDate}T23:59:59`).getTime();
        validEnd = parcelTime <= end;
      }

      return validStart && validEnd;
    }

    return true;
  };

  const filteredParcels = parcels.filter((p) => {
    const matchesSearch =
      p.trackingNumber.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.customer.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.courier.toLowerCase().includes(searchQuery.toLowerCase()) ||
      (p.destination && p.destination.toLowerCase().includes(searchQuery.toLowerCase()));

    const matchesPlatform = selectedPlatform === 'All' || p.platform === selectedPlatform;
    const matchesStatus = selectedStatus === 'All' || p.status === selectedStatus;
    const matchesCourier = selectedCourier === 'All' || p.courier === selectedCourier;
    const matchesDate = isDateInRange(p.dateISO);

    return matchesSearch && matchesPlatform && matchesStatus && matchesCourier && matchesDate;
  });

  const hasActiveFilters =
    selectedPlatform !== 'All' ||
    selectedStatus !== 'All' ||
    selectedCourier !== 'All' ||
    selectedDateFilter !== 'all' ||
    searchQuery.trim().length > 0;

  const resetAllFilters = () => {
    setSelectedPlatform('All');
    setSelectedStatus('All');
    setSelectedCourier('All');
    setSelectedDateFilter('all');
    setSearchQuery('');
  };

  const shopeeCount = parcels.filter((p) => p.platform === 'Shopee').length;
  const lazadaCount = parcels.filter((p) => p.platform === 'Lazada').length;
  const tikTokCount = parcels.filter((p) => p.platform === 'TikTok Shop').length;

  return (
    <div className="flex flex-col gap-3 px-4 pt-3 pb-24 max-w-md mx-auto w-full">
      {/* Header */}
      <div className="flex items-center justify-between pt-1">
        <div>
          <h1 className="text-xl font-bold tracking-tight text-[#0F172A]">
            GJandAsher ShipTracker
          </h1>
          <p className="text-xs text-slate-500 font-medium">
            Outbound Logistics & Returns Hub
          </p>
        </div>
        <div className="bg-[#E0F2FE] px-2.5 py-1 rounded-full border border-sky-200">
          <span className="text-xs font-semibold text-[#0F172A]">
            {userRole}
          </span>
        </div>
      </div>

      {/* Platform Summary Chips (Interactive) */}
      <div className="grid grid-cols-3 gap-2.5">
        {/* Shopee */}
        <button
          onClick={() => setSelectedPlatform(selectedPlatform === 'Shopee' ? 'All' : 'Shopee')}
          className={`text-left rounded-xl p-3 border transition-all ${
            selectedPlatform === 'Shopee'
              ? 'ring-2 ring-[#EE4D2D] shadow-sm bg-[#FFECE7] border-[#EE4D2D]'
              : 'bg-[#FFECE7] border-[#FFD9CE] hover:opacity-90'
          }`}
        >
          <div className="text-[13px] font-bold text-[#EE4D2D]">Shopee</div>
          <div className="text-base font-extrabold text-[#0F172A] mt-1">
            {shopeeCount} pkgs
          </div>
        </button>

        {/* Lazada */}
        <button
          onClick={() => setSelectedPlatform(selectedPlatform === 'Lazada' ? 'All' : 'Lazada')}
          className={`text-left rounded-xl p-3 border transition-all ${
            selectedPlatform === 'Lazada'
              ? 'ring-2 ring-[#0F146D] shadow-sm bg-[#E8EBFF] border-[#0F146D]'
              : 'bg-[#E8EBFF] border-[#D7DCFF] hover:opacity-90'
          }`}
        >
          <div className="text-[13px] font-bold text-[#0F146D]">Lazada</div>
          <div className="text-base font-extrabold text-[#0F172A] mt-1">
            {lazadaCount} pkgs
          </div>
        </button>

        {/* TikTok */}
        <button
          onClick={() => setSelectedPlatform(selectedPlatform === 'TikTok Shop' ? 'All' : 'TikTok Shop')}
          className={`text-left rounded-xl p-3 border transition-all ${
            selectedPlatform === 'TikTok Shop'
              ? 'ring-2 ring-black shadow-sm bg-[#F1F5F9] border-black'
              : 'bg-[#F1F5F9] border-slate-200 hover:opacity-90'
          }`}
        >
          <div className="text-[13px] font-bold text-[#010101]">TikTok</div>
          <div className="text-base font-extrabold text-[#0F172A] mt-1">
            {tikTokCount} pkgs
          </div>
        </button>
      </div>

      {/* Search Input */}
      <div className="relative">
        <Search className="absolute left-3.5 top-2.5 w-4 h-4 text-slate-400" />
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          placeholder="Search tracking #, customer, courier, city..."
          className="w-full pl-10 pr-14 py-2 bg-white border border-slate-200 rounded-xl text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9] focus:border-transparent"
        />
        {searchQuery && (
          <button
            onClick={() => setSearchQuery('')}
            className="absolute right-3 top-2.5 text-xs text-slate-400 hover:text-slate-600 font-semibold"
          >
            Clear
          </button>
        )}
      </div>

      {/* Filter Frame */}
      <div className="bg-white rounded-2xl p-3 border border-slate-200 shadow-2xs space-y-3">
        {/* Filter Frame Header */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-1.5">
            <Filter className="w-3.5 h-3.5 text-[#0EA5E9]" />
            <span className="text-xs font-bold text-[#0F172A]">
              Filter Outbound Logs
            </span>
            {hasActiveFilters && (
              <span className="text-[10px] bg-sky-100 text-[#0EA5E9] font-bold px-1.5 py-0.2 rounded-full">
                Active
              </span>
            )}
          </div>

          <div className="flex items-center gap-2">
            {hasActiveFilters && (
              <button
                onClick={resetAllFilters}
                className="text-[11px] font-semibold text-rose-500 hover:text-rose-700 flex items-center gap-1"
              >
                <RotateCcw className="w-3 h-3" />
                Reset
              </button>
            )}
            <button
              onClick={() => setShowFiltersExpanded(!showFiltersExpanded)}
              className="text-slate-400 hover:text-slate-600 p-0.5"
              title={showFiltersExpanded ? 'Collapse filters' : 'Expand filters'}
            >
              {showFiltersExpanded ? (
                <ChevronUp className="w-4 h-4" />
              ) : (
                <ChevronDown className="w-4 h-4" />
              )}
            </button>
          </div>
        </div>

        {showFiltersExpanded && (
          <div className="space-y-2.5 pt-0.5">
            {/* 1. Status Filter Pills */}
            <div>
              <div className="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-1 flex items-center justify-between">
                <span>Status</span>
                <span className="text-[10px] text-slate-500 font-normal">
                  {selectedStatus}
                </span>
              </div>
              <div className="flex items-center gap-1.5 overflow-x-auto no-scrollbar py-0.5">
                {(['All', 'Dispatched', 'In Transit', 'Delivered', 'Return Logged'] as const).map(
                  (status) => (
                    <button
                      key={status}
                      onClick={() => setSelectedStatus(status)}
                      className={`px-2.5 py-1 rounded-lg text-[11px] font-medium whitespace-nowrap transition-colors shrink-0 ${
                        selectedStatus === status
                          ? 'bg-[#0F172A] text-white shadow-xs'
                          : 'bg-slate-50 text-slate-600 border border-slate-200 hover:bg-slate-100'
                      }`}
                    >
                      {status}
                    </button>
                  )
                )}
              </div>
            </div>

            {/* 2. Platform / Marketplace Classification Filter */}
            <div>
              <div className="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-1 flex items-center justify-between">
                <span>Marketplace Platform</span>
                <span className="text-[10px] text-slate-500 font-normal">
                  {selectedPlatform}
                </span>
              </div>
              <div className="flex items-center gap-1.5 overflow-x-auto no-scrollbar py-0.5">
                {[
                  { label: 'All', value: 'All' },
                  { label: 'Shopee', value: 'Shopee', color: 'text-[#EE4D2D] border-[#EE4D2D]/30 bg-[#FFECE7]' },
                  { label: 'Lazada', value: 'Lazada', color: 'text-[#0F146D] border-[#0F146D]/30 bg-[#E8EBFF]' },
                  { label: 'TikTok Shop', value: 'TikTok Shop', color: 'text-black border-black/30 bg-[#F1F5F9]' },
                ].map((item) => {
                  const isSelected = selectedPlatform === item.value;
                  return (
                    <button
                      key={item.value}
                      onClick={() => setSelectedPlatform(item.value as Platform | 'All')}
                      className={`px-2.5 py-1 rounded-lg text-[11px] font-bold whitespace-nowrap transition-all shrink-0 border ${
                        isSelected
                          ? 'bg-[#0F172A] text-white border-[#0F172A] shadow-xs'
                          : `${item.color || 'bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100'}`
                      }`}
                    >
                      {item.label}
                    </button>
                  );
                })}
              </div>
            </div>

            {/* 3. Courier Services Filter (SPX, J&T, etc.) */}
            <div>
              <div className="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-1 flex items-center justify-between">
                <span>Courier Service</span>
                <span className="text-[10px] text-slate-500 font-normal">
                  {selectedCourier}
                </span>
              </div>
              <div className="flex items-center gap-1.5 overflow-x-auto no-scrollbar py-0.5">
                {[
                  { label: 'All Couriers', value: 'All' },
                  { label: 'SPX Express', value: 'SPX Express' },
                  { label: 'J&T Express', value: 'J&T Express' },
                  { label: 'Flash Express', value: 'Flash Express' },
                  { label: 'Lazada Express', value: 'Lazada Express' },
                ].map((item) => {
                  const isSelected = selectedCourier === item.value;
                  return (
                    <button
                      key={item.value}
                      onClick={() => setSelectedCourier(item.value as Courier | 'All')}
                      className={`px-2.5 py-1 rounded-lg text-[11px] font-medium whitespace-nowrap transition-colors shrink-0 ${
                        isSelected
                          ? 'bg-[#0EA5E9] text-white font-bold shadow-xs'
                          : 'bg-slate-50 text-slate-600 border border-slate-200 hover:bg-slate-100'
                      }`}
                    >
                      {item.label}
                    </button>
                  );
                })}
              </div>
            </div>

            {/* 4. Date Range Filter (Today, Last Week, Last Month, Custom Date Range) */}
            <div>
              <div className="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-1 flex items-center justify-between">
                <span>Dispatch Date</span>
                <span className="text-[10px] text-slate-500 font-normal">
                  {selectedDateFilter === 'all'
                    ? 'All Time'
                    : selectedDateFilter === 'today'
                    ? 'Today'
                    : selectedDateFilter === 'last_week'
                    ? 'Past 7 Days'
                    : selectedDateFilter === 'last_month'
                    ? 'Past 30 Days'
                    : 'Custom Range'}
                </span>
              </div>
              <div className="flex items-center gap-1.5 overflow-x-auto no-scrollbar py-0.5">
                {[
                  { label: 'All Time', value: 'all' },
                  { label: 'Today', value: 'today' },
                  { label: 'Last Week', value: 'last_week' },
                  { label: 'Last Month', value: 'last_month' },
                  { label: 'Custom Range 📅', value: 'custom' },
                ].map((item) => {
                  const isSelected = selectedDateFilter === item.value;
                  return (
                    <button
                      key={item.value}
                      onClick={() => setSelectedDateFilter(item.value as DateFilterOption)}
                      className={`px-2.5 py-1 rounded-lg text-[11px] font-medium whitespace-nowrap transition-colors shrink-0 ${
                        isSelected
                          ? 'bg-[#0F172A] text-white font-bold shadow-xs'
                          : 'bg-slate-50 text-slate-600 border border-slate-200 hover:bg-slate-100'
                      }`}
                    >
                      {item.label}
                    </button>
                  );
                })}
              </div>

              {/* Custom Date Range Picker between two dates */}
              {selectedDateFilter === 'custom' && (
                <div className="mt-2 p-2.5 bg-slate-50 border border-sky-200 rounded-xl flex flex-col gap-2">
                  <div className="flex items-center justify-between">
                    <span className="text-[11px] font-bold text-slate-700 flex items-center gap-1.5">
                      <Calendar className="w-3.5 h-3.5 text-[#0EA5E9]" />
                      Date Range Filter (Between Two Dates)
                    </span>
                    <button
                      onClick={() => {
                        setCustomStartDate('2026-10-01');
                        setCustomEndDate('2026-10-05');
                      }}
                      className="text-[10px] font-semibold text-[#0EA5E9] hover:underline"
                    >
                      Reset Range
                    </button>
                  </div>
                  <div className="grid grid-cols-2 gap-2 text-xs">
                    <div>
                      <label className="block text-[10px] font-semibold text-slate-500 mb-1">
                        Start Date
                      </label>
                      <input
                        type="date"
                        value={customStartDate}
                        onChange={(e) => setCustomStartDate(e.target.value)}
                        className="w-full bg-white border border-slate-300 rounded-lg px-2 py-1.5 text-xs text-slate-800 font-medium focus:outline-none focus:ring-2 focus:ring-sky-400"
                      />
                    </div>
                    <div>
                      <label className="block text-[10px] font-semibold text-slate-500 mb-1">
                        End Date
                      </label>
                      <input
                        type="date"
                        value={customEndDate}
                        onChange={(e) => setCustomEndDate(e.target.value)}
                        className="w-full bg-white border border-slate-300 rounded-lg px-2 py-1.5 text-xs text-slate-800 font-medium focus:outline-none focus:ring-2 focus:ring-sky-400"
                      />
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        )}
      </div>

      {/* Recent Dispatches Section Header with active count */}
      <div className="flex items-center justify-between mt-1">
        <div className="flex items-center gap-2">
          <h2 className="text-sm font-bold text-[#0F172A]">
            Outbound Dispatches
          </h2>
          {hasActiveFilters && (
            <span className="text-[10px] bg-slate-100 text-slate-600 font-semibold px-2 py-0.5 rounded-full border border-slate-200">
              Filtered
            </span>
          )}
        </div>
        <span className="text-[11px] text-slate-500 font-medium">
          Showing <span className="font-bold text-[#0F172A]">{filteredParcels.length}</span> of {parcels.length} parcels
        </span>
      </div>

      {/* Parcel Cards */}
      <div className="flex flex-col gap-2.5">
        {filteredParcels.length === 0 ? (
          <div className="bg-white rounded-2xl p-8 border border-slate-200 text-center text-slate-400">
            <p className="text-sm font-medium">No parcels match the selected filters</p>
            <p className="text-xs text-slate-400 mt-1">
              Try broadening your platform, courier, or date range filters.
            </p>
            <button
              onClick={resetAllFilters}
              className="mt-3 text-xs font-semibold text-[#0EA5E9] bg-sky-50 px-3 py-1.5 rounded-xl border border-sky-200 hover:bg-sky-100 transition-colors"
            >
              Reset All Filters
            </button>
          </div>
        ) : (
          filteredParcels.map((parcel) => (
            <div
              key={parcel.id}
              onClick={() => onSelectParcel(parcel)}
              className="bg-white rounded-2xl p-4 border border-slate-200 shadow-sm hover:border-slate-300 transition-all cursor-pointer group"
            >
              {/* Top Row: Tracking Number + Status Badge */}
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-1.5">
                  <span className="text-[13px] font-bold text-[#0F172A] tracking-tight font-mono">
                    {parcel.trackingNumber}
                  </span>
                  <button
                    onClick={(e) => handleCopy(e, parcel.trackingNumber)}
                    className="p-1 hover:bg-slate-100 rounded text-slate-400 hover:text-slate-600 transition-colors"
                    title="Copy Tracking #"
                  >
                    {copiedId === parcel.trackingNumber ? (
                      <Check className="w-3 h-3 text-emerald-600" />
                    ) : (
                      <Copy className="w-3 h-3" />
                    )}
                  </button>
                </div>

                {/* Status Badge */}
                <div
                  className="px-2 py-0.5 rounded-full text-[11px] font-bold"
                  style={{
                    backgroundColor: `${parcel.statusColor}1F`,
                    color: parcel.statusColor,
                  }}
                >
                  {parcel.status}
                </div>
              </div>

              {/* Bottom Row: Customer & Courier + Amount */}
              <div className="flex items-end justify-between mt-2.5">
                <div>
                  <div className="text-[13px] font-semibold text-slate-900 leading-tight">
                    {parcel.customer}
                  </div>
                  <div className="text-[11px] text-slate-500 mt-0.5 flex items-center gap-1">
                    <span className="font-medium">{parcel.platform}</span>
                    <span>•</span>
                    <span className="text-[#0EA5E9] font-medium">{parcel.courier}</span>
                  </div>
                </div>

                <div className="text-right">
                  <div className="text-sm font-bold text-[#0F172A]">
                    {parcel.amount}
                  </div>
                  <div className="text-[10px] text-slate-400">
                    {parcel.dispatchedAt}
                  </div>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};
