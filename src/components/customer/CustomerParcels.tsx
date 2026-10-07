import React, { useState } from 'react';
import { Parcel } from '../../types';
import { Package, Search, Copy, Check, Truck, Clock, MapPin, ChevronRight, MessageSquare, ExternalLink } from 'lucide-react';

interface CustomerParcelsProps {
  parcels: Parcel[];
  customerName: string;
  onSelectParcel: (parcel: Parcel) => void;
  onInquireParcelInChat: (parcel: Parcel) => void;
}

export const CustomerParcels: React.FC<CustomerParcelsProps> = ({
  parcels,
  customerName,
  onSelectParcel,
  onInquireParcelInChat,
}) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [copiedId, setCopiedId] = useState<string | null>(null);
  const [statusFilter, setStatusFilter] = useState<'All' | 'Active' | 'Delivered'>('All');

  const handleCopy = (e: React.MouseEvent, text: string) => {
    e.stopPropagation();
    navigator.clipboard.writeText(text);
    setCopiedId(text);
    setTimeout(() => setCopiedId(null), 2000);
  };

  // Filter parcels for customer (or display customer parcels)
  const customerParcels = parcels.filter((p) => {
    const isCustomerMatch =
      p.customer.toLowerCase().includes(customerName.toLowerCase()) ||
      customerName.toLowerCase().includes(p.customer.toLowerCase()) ||
      true; // show user's orders

    const matchesSearch =
      p.trackingNumber.toLowerCase().includes(searchQuery.toLowerCase()) ||
      (p.items && p.items.toLowerCase().includes(searchQuery.toLowerCase())) ||
      p.courier.toLowerCase().includes(searchQuery.toLowerCase());

    const matchesStatus =
      statusFilter === 'All'
        ? true
        : statusFilter === 'Active'
        ? p.status === 'Dispatched' || p.status === 'In Transit'
        : p.status === 'Delivered' || p.status === 'Return Logged';

    return isCustomerMatch && matchesSearch && matchesStatus;
  });

  return (
    <div className="flex flex-col gap-3.5 px-4 pt-3 pb-24 max-w-md mx-auto w-full animate-fade-in">
      {/* Header */}
      <div className="flex items-center justify-between pt-1">
        <div>
          <span className="text-[11px] font-bold text-sky-600 uppercase tracking-wider">
            Customer Order Tracker
          </span>
          <h1 className="text-xl font-bold tracking-tight text-[#0F172A]">
            My Ordered Parcels
          </h1>
          <p className="text-xs text-slate-500 font-medium">
            Live delivery status across Shopee, Lazada & TikTok
          </p>
        </div>
        <div className="bg-sky-50 px-3 py-1.5 rounded-2xl border border-sky-200 text-right">
          <div className="text-[10px] text-slate-400 font-medium">Customer</div>
          <div className="text-xs font-bold text-[#0F172A]">{customerName}</div>
        </div>
      </div>

      {/* Search Bar */}
      <div className="relative">
        <Search className="absolute left-3.5 top-2.5 w-4 h-4 text-slate-400" />
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          placeholder="Search by tracking #, item name, courier..."
          className="w-full pl-10 pr-4 py-2 bg-white border border-slate-200 rounded-xl text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9]"
        />
        {searchQuery && (
          <button
            onClick={() => setSearchQuery('')}
            className="absolute right-3 top-2.5 text-xs text-slate-400 hover:text-slate-600 font-bold"
          >
            Clear
          </button>
        )}
      </div>

      {/* Status Filter Tabs */}
      <div className="flex items-center gap-1.5 bg-slate-100 p-1 rounded-xl text-xs font-semibold">
        {(['All', 'Active', 'Delivered'] as const).map((tab) => (
          <button
            key={tab}
            onClick={() => setStatusFilter(tab)}
            className={`flex-1 py-1.5 rounded-lg text-center transition-all ${
              statusFilter === tab
                ? 'bg-white text-[#0F172A] shadow-xs font-bold'
                : 'text-slate-500 hover:text-slate-800'
            }`}
          >
            {tab}
          </button>
        ))}
      </div>

      {/* Parcels List */}
      <div className="flex flex-col gap-3">
        {customerParcels.length === 0 ? (
          <div className="bg-white rounded-2xl p-8 border border-slate-200 text-center text-slate-400">
            <Package className="w-10 h-10 mx-auto text-slate-300 mb-2" />
            <p className="text-sm font-semibold text-slate-600">No ordered parcels found</p>
            <p className="text-xs text-slate-400 mt-1">
              Your recent shipments will appear here once booked by the warehouse.
            </p>
          </div>
        ) : (
          customerParcels.map((parcel) => {
            const isDelivered = parcel.status === 'Delivered';
            const isInTransit = parcel.status === 'In Transit';
            const isDispatched = parcel.status === 'Dispatched';

            return (
              <div
                key={parcel.id}
                onClick={() => onSelectParcel(parcel)}
                className="bg-white rounded-2xl p-4 border border-slate-200 shadow-2xs hover:border-sky-300 transition-all cursor-pointer group"
              >
                {/* Header row: Platform chip & Status badge */}
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <span
                      className={`text-[10px] font-bold px-2 py-0.5 rounded-md ${
                        parcel.platform === 'Shopee'
                          ? 'bg-[#FFECE7] text-[#EE4D2D]'
                          : parcel.platform === 'Lazada'
                          ? 'bg-[#E8EBFF] text-[#0F146D]'
                          : 'bg-[#F1F5F9] text-black'
                      }`}
                    >
                      {parcel.platform}
                    </span>
                    <span className="text-xs font-mono font-bold text-slate-800">
                      {parcel.trackingNumber}
                    </span>
                    <button
                      onClick={(e) => handleCopy(e, parcel.trackingNumber)}
                      className="p-1 hover:bg-slate-100 rounded text-slate-400 hover:text-slate-600"
                      title="Copy Tracking #"
                    >
                      {copiedId === parcel.trackingNumber ? (
                        <Check className="w-3 h-3 text-emerald-600" />
                      ) : (
                        <Copy className="w-3 h-3" />
                      )}
                    </button>
                  </div>

                  <span
                    className="px-2 py-0.5 rounded-full text-[10px] font-bold"
                    style={{
                      backgroundColor: `${parcel.statusColor}1F`,
                      color: parcel.statusColor,
                    }}
                  >
                    {parcel.status}
                  </span>
                </div>

                {/* Item Details */}
                <div className="mt-2 text-xs font-semibold text-[#0F172A] line-clamp-1">
                  {parcel.items || 'General E-Commerce Package'}
                </div>

                {/* Delivery Timeline Indicator */}
                <div className="mt-3 bg-slate-50 p-2.5 rounded-xl border border-slate-100">
                  <div className="flex items-center justify-between text-[10px] font-semibold text-slate-400 mb-1.5">
                    <span className={isDispatched || isInTransit || isDelivered ? 'text-sky-600 font-bold' : ''}>
                      Dispatched
                    </span>
                    <span className={isInTransit || isDelivered ? 'text-sky-600 font-bold' : ''}>
                      In Transit
                    </span>
                    <span className={isDelivered ? 'text-emerald-600 font-bold' : ''}>
                      Delivered
                    </span>
                  </div>
                  {/* Progress bar line */}
                  <div className="w-full h-1.5 bg-slate-200 rounded-full overflow-hidden flex">
                    <div
                      className={`h-full transition-all ${
                        isDelivered
                          ? 'w-full bg-emerald-500'
                          : isInTransit
                          ? 'w-2/3 bg-sky-500'
                          : 'w-1/3 bg-sky-500'
                      }`}
                    />
                  </div>
                  <div className="flex items-center justify-between mt-1.5 text-[10px] text-slate-500">
                    <span className="flex items-center gap-1">
                      <Truck className="w-3 h-3 text-slate-400" />
                      {parcel.courier}
                    </span>
                    <span>{parcel.dispatchedAt}</span>
                  </div>
                </div>

                {/* Card footer: Amount & Chat Action */}
                <div className="mt-3 pt-2.5 border-t border-slate-100 flex items-center justify-between">
                  <div>
                    <span className="text-[10px] text-slate-400 block leading-none">Order Total</span>
                    <span className="text-sm font-bold text-[#0F172A]">{parcel.amount}</span>
                  </div>

                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      onInquireParcelInChat(parcel);
                    }}
                    className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-sky-50 hover:bg-sky-100 border border-sky-200 text-[#0EA5E9] font-bold text-xs rounded-xl transition-colors"
                  >
                    <MessageSquare className="w-3.5 h-3.5" />
                    <span>Ask Support</span>
                  </button>
                </div>
              </div>
            );
          })
        )}
      </div>
    </div>
  );
};
