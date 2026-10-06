import React, { useState } from 'react';
import { Platform, Courier, Parcel } from '../types';
import { Send, QrCode, Sparkles, CheckCircle2, ArrowRight } from 'lucide-react';

interface DispatchScreenProps {
  onAddParcel: (parcel: Parcel) => void;
  onNavigateToParcels: () => void;
}

export const DispatchScreen: React.FC<DispatchScreenProps> = ({
  onAddParcel,
  onNavigateToParcels,
}) => {
  const [platform, setPlatform] = useState<Platform>('Shopee');
  const [courier, setCourier] = useState<Courier>('SPX Express');
  const [trackingNumber, setTrackingNumber] = useState('');
  const [customer, setCustomer] = useState('');
  const [phone, setPhone] = useState('');
  const [destination, setDestination] = useState('');
  const [amount, setAmount] = useState('');
  const [items, setItems] = useState('');
  const [submitted, setSubmitted] = useState(false);

  const couriersByPlatform: Record<Platform, Courier[]> = {
    Shopee: ['SPX Express', 'Flash Express', 'J&T Express', 'Ninja Van'],
    Lazada: ['Lazada Express', 'Flash Express', 'Ninja Van'],
    'TikTok Shop': ['J&T Express', 'Flash Express', 'Ninja Van'],
  };

  const handlePlatformChange = (newPlatform: Platform) => {
    setPlatform(newPlatform);
    const availableCouriers = couriersByPlatform[newPlatform];
    if (!availableCouriers.includes(courier)) {
      setCourier(availableCouriers[0]);
    }
  };

  const handleAutoGenerate = () => {
    const randomDigits = Math.floor(100000000 + Math.random() * 900000000);
    let sampleTracking = '';
    if (platform === 'Shopee') {
      sampleTracking = `SPXPH0${randomDigits}`;
    } else if (platform === 'Lazada') {
      sampleTracking = `LEX-PH-${randomDigits.toString().slice(0, 8)}`;
    } else {
      sampleTracking = `JT${randomDigits}`;
    }
    setTrackingNumber(sampleTracking);

    const demoCustomers = [
      { name: 'Angela Cortez', phone: '+63 917 552 1109', city: 'Mandaluyong City, Metro Manila', items: '1x Wireless Gaming Mouse', price: '1450' },
      { name: 'Gabriel Bautista', phone: '+63 928 331 4492', city: 'Bacoor, Cavite', items: '2x Heavyweight Crewneck Shirts', price: '980' },
      { name: 'Patricia Lim', phone: '+63 905 119 7731', city: 'Santa Rosa, Laguna', items: '1x Ceramic Thermal Mug 500ml', price: '650' },
    ];
    const picked = demoCustomers[Math.floor(Math.random() * demoCustomers.length)];
    setCustomer(picked.name);
    setPhone(picked.phone);
    setDestination(picked.city);
    setItems(picked.items);
    setAmount(picked.price);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!trackingNumber.trim() || !customer.trim()) return;

    const parsedAmount = parseFloat(amount.replace(/[^0-9.]/g, '')) || 0;
    const formattedAmount = `₱${parsedAmount.toLocaleString('en-PH', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    })}`;

    const newParcel: Parcel = {
      id: `p-${Date.now()}`,
      trackingNumber: trackingNumber.trim().toUpperCase(),
      platform,
      courier,
      customer: customer.trim(),
      phone: phone.trim() || '+63 917 *** ****',
      destination: destination.trim() || 'Metro Manila Hub',
      amount: formattedAmount,
      rawAmount: parsedAmount,
      status: 'Dispatched',
      statusColor: '#3B82F6',
      dispatchedAt: 'Just now',
      dateISO: new Date().toISOString(),
      items: items.trim() || 'General E-commerce Merchandise',
    };

    onAddParcel(newParcel);
    setSubmitted(true);
    setTimeout(() => {
      setSubmitted(false);
      onNavigateToParcels();
    }, 1200);
  };

  return (
    <div className="flex flex-col px-4 pt-3 pb-24 max-w-md mx-auto w-full">
      {/* Header Info matching Android Module 3 design */}
      <div className="flex flex-col items-center text-center py-2">
        <div className="w-12 h-12 rounded-2xl bg-slate-100 flex items-center justify-center text-[#0F172A] shadow-inner">
          <Send className="w-6 h-6 text-[#0F172A]" />
        </div>
        <h2 className="text-base font-bold text-[#0F172A] mt-2">
          Manual Dispatch Form
        </h2>
        <p className="text-xs text-slate-500 mt-1 max-w-xs leading-relaxed">
          Fast courier entry, platform selector (Shopee/Lazada/TikTok), and auto-fill customer QR code.
        </p>
      </div>

      {submitted ? (
        <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-6 text-center my-6 flex flex-col items-center animate-fade-in">
          <CheckCircle2 className="w-12 h-12 text-emerald-600 mb-2" />
          <h3 className="text-base font-bold text-emerald-900">
            Parcel Successfully Dispatched!
          </h3>
          <p className="text-xs text-emerald-700 mt-1">
            Tracking {trackingNumber} logged into outbound manifest.
          </p>
        </div>
      ) : (
        <form onSubmit={handleSubmit} className="mt-3 flex flex-col gap-3.5">
          {/* Quick Demo Autofill button */}
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-700">Platform Selector</span>
            <button
              type="button"
              onClick={handleAutoGenerate}
              className="text-[11px] font-semibold text-[#0EA5E9] hover:text-sky-700 flex items-center gap-1 bg-sky-50 px-2 py-1 rounded-lg border border-sky-200"
            >
              <Sparkles className="w-3 h-3" />
              Auto-Fill Sample Waybill
            </button>
          </div>

          {/* Platform Selector */}
          <div className="grid grid-cols-3 gap-2">
            {(['Shopee', 'Lazada', 'TikTok Shop'] as const).map((p) => {
              const isSelected = platform === p;
              const isShopee = p === 'Shopee';
              const isLazada = p === 'Lazada';
              const isTikTok = p === 'TikTok Shop';

              return (
                <button
                  key={p}
                  type="button"
                  onClick={() => handlePlatformChange(p)}
                  className={`py-2 px-2 rounded-xl text-xs font-bold transition-all border ${
                    isSelected
                      ? isShopee
                        ? 'bg-[#FFECE7] text-[#EE4D2D] border-[#EE4D2D] ring-2 ring-[#EE4D2D]/30'
                        : isLazada
                        ? 'bg-[#E8EBFF] text-[#0F146D] border-[#0F146D] ring-2 ring-[#0F146D]/30'
                        : 'bg-[#F1F5F9] text-black border-black ring-2 ring-black/20'
                      : 'bg-white text-slate-600 border-slate-200 hover:bg-slate-50'
                  }`}
                >
                  {p}
                </button>
              );
            })}
          </div>

          {/* Courier Selector */}
          <div>
            <label className="block text-xs font-semibold text-slate-700 mb-1">
              Courier Partner
            </label>
            <select
              value={courier}
              onChange={(e) => setCourier(e.target.value as Courier)}
              className="w-full bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs font-medium text-slate-800 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9]"
            >
              {couriersByPlatform[platform].map((c) => (
                <option key={c} value={c}>
                  {c}
                </option>
              ))}
            </select>
          </div>

          {/* Tracking Number Input with QR icon */}
          <div>
            <label className="block text-xs font-semibold text-slate-700 mb-1">
              Tracking / Airway Bill (AWB) #
            </label>
            <div className="relative">
              <input
                type="text"
                required
                value={trackingNumber}
                onChange={(e) => setTrackingNumber(e.target.value)}
                placeholder="e.g. SPXPH0394829104"
                className="w-full pl-3 pr-10 py-2 bg-white border border-slate-200 rounded-xl text-xs font-mono font-medium text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9]"
              />
              <button
                type="button"
                onClick={handleAutoGenerate}
                title="Scan QR/Barcode simulation"
                className="absolute right-2.5 top-2 text-slate-400 hover:text-slate-600"
              >
                <QrCode className="w-4 h-4" />
              </button>
            </div>
          </div>

          {/* Customer Name & Phone */}
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Customer Name
              </label>
              <input
                type="text"
                required
                value={customer}
                onChange={(e) => setCustomer(e.target.value)}
                placeholder="Recipient name"
                className="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9]"
              />
            </div>
            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Order Value (PHP)
              </label>
              <input
                type="text"
                required
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                placeholder="e.g. 1250"
                className="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9]"
              />
            </div>
          </div>

          {/* Delivery Address / Hub */}
          <div>
            <label className="block text-xs font-semibold text-slate-700 mb-1">
              Destination City / Province
            </label>
            <input
              type="text"
              value={destination}
              onChange={(e) => setDestination(e.target.value)}
              placeholder="e.g. Quezon City, Metro Manila"
              className="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9]"
            />
          </div>

          {/* Items Summary */}
          <div>
            <label className="block text-xs font-semibold text-slate-700 mb-1">
              Package Item Content
            </label>
            <input
              type="text"
              value={items}
              onChange={(e) => setItems(e.target.value)}
              placeholder="e.g. 2x Wireless Earbuds"
              className="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9]"
            />
          </div>

          {/* Submit Action Button */}
          <button
            type="submit"
            className="w-full mt-2 py-3 bg-[#0F172A] hover:bg-slate-800 text-white font-bold text-xs rounded-xl shadow-md flex items-center justify-center gap-2 transition-transform active:scale-[0.99]"
          >
            <span>Confirm & Dispatch Parcel</span>
            <ArrowRight className="w-4 h-4" />
          </button>
        </form>
      )}
    </div>
  );
};
