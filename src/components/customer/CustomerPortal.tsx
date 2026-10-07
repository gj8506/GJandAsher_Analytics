import React, { useState } from 'react';
import { Parcel, Product, ChatMessage } from '../../types';
import { CustomerParcels } from './CustomerParcels';
import { CustomerStore } from './CustomerStore';
import { CustomerChat } from './CustomerChat';
import { Package, ShoppingBag, MessageSquare, User, LogOut, ShieldCheck } from 'lucide-react';

interface CustomerPortalProps {
  parcels: Parcel[];
  products: Product[];
  chatMessages: ChatMessage[];
  onSendMessage: (text: string, attachedItem?: { type: 'parcel' | 'product'; id: string; name: string }) => void;
  onSelectParcel: (parcel: Parcel) => void;
  onSignOut: () => void;
  customerName?: string;
  customerEmail?: string;
}

export const CustomerPortal: React.FC<CustomerPortalProps> = ({
  parcels,
  products,
  chatMessages,
  onSendMessage,
  onSelectParcel,
  onSignOut,
  customerName = 'New Customer',
  customerEmail = 'new.customer@gmail.com',
}) => {
  const [currentTab, setCurrentTab] = useState<'parcels' | 'store' | 'chat' | 'account'>('parcels');
  const [pendingAttachment, setPendingAttachment] = useState<{
    type: 'parcel' | 'product';
    id: string;
    name: string;
  } | null>(null);

  const handleInquireParcelInChat = (parcel: Parcel) => {
    setPendingAttachment({
      type: 'parcel',
      id: parcel.id,
      name: `Tracking #${parcel.trackingNumber} (${parcel.items || 'Parcel'})`,
    });
    setCurrentTab('chat');
  };

  const handleInquireProductInChat = (product: Product) => {
    setPendingAttachment({
      type: 'product',
      id: product.id,
      name: `${product.name} (${product.price})`,
    });
    setCurrentTab('chat');
  };

  return (
    <div className="min-h-screen bg-[#F8FAFC] flex justify-center text-slate-900">
      <div className="w-full max-w-md min-h-screen bg-[#F8FAFC] flex flex-col relative shadow-sm border-x border-slate-200/60">
        {/* Top Header */}
        <header className="bg-[#0F172A] text-white px-4 py-3 flex items-center justify-between shadow-xs">
          <div className="flex items-center gap-2">
            <div className="w-7 h-7 rounded-lg bg-sky-500/20 text-[#0EA5E9] flex items-center justify-center font-bold">
              <Package className="w-4 h-4 text-sky-400" />
            </div>
            <div>
              <h1 className="text-xs font-bold tracking-tight text-white leading-tight">
                GJ & Asher Customer Portal
              </h1>
              <p className="text-[10px] text-slate-400">
                Official Buyer Tracking & Support
              </p>
            </div>
          </div>

          <div className="flex items-center gap-1.5 bg-slate-800/80 px-2.5 py-1 rounded-full border border-slate-700">
            <span className="w-2 h-2 rounded-full bg-emerald-400" />
            <span className="text-[10px] font-semibold text-slate-200">Customer Account</span>
          </div>
        </header>

        {/* Main Tab Views */}
        <main className="flex-1 overflow-y-auto">
          {currentTab === 'parcels' && (
            <CustomerParcels
              parcels={parcels}
              customerName={customerName}
              onSelectParcel={onSelectParcel}
              onInquireParcelInChat={handleInquireParcelInChat}
            />
          )}

          {currentTab === 'store' && (
            <CustomerStore
              products={products}
              onInquireProductInChat={handleInquireProductInChat}
            />
          )}

          {currentTab === 'chat' && (
            <CustomerChat
              messages={chatMessages}
              onSendMessage={onSendMessage}
              pendingAttachment={pendingAttachment}
              onClearAttachment={() => setPendingAttachment(null)}
              customerName={customerName}
            />
          )}

          {currentTab === 'account' && (
            <div className="flex flex-col gap-3.5 px-4 pt-4 pb-24 max-w-md mx-auto w-full animate-fade-in">
              {/* Account Profile Card */}
              <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-2xs">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 rounded-full bg-gradient-to-tr from-sky-600 to-indigo-600 text-white font-bold text-base flex items-center justify-center shadow-xs">
                    {customerName.substring(0, 2).toUpperCase()}
                  </div>
                  <div>
                    <h2 className="text-base font-bold text-[#0F172A]">{customerName}</h2>
                    <p className="text-xs text-slate-500 font-mono">{customerEmail}</p>
                    <span className="text-[10px] text-sky-800 bg-sky-50 px-2 py-0.5 rounded-full font-bold inline-block mt-1 border border-sky-200">
                      Role: Customer
                    </span>
                  </div>
                </div>
              </div>

              {/* Account Role Notice */}
              <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-2xs">
                <h3 className="text-xs font-bold text-[#0F172A] mb-1">
                  Account Type: Customer / Buyer
                </h3>
                <p className="text-[11px] text-slate-500 leading-relaxed">
                  This account has buyer permissions for tracking outbound parcels, browsing warehouse products, and direct chat with admin support. Staff and administrator roles are strictly provisioned by the Administrator in Cloud Firestore.
                </p>
              </div>

              {/* Connected Marketplaces Card */}
              <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-2xs">
                <h3 className="text-xs font-bold text-[#0F172A] mb-2.5">
                  Linked E-Commerce Platforms
                </h3>
                <div className="space-y-2 text-xs">
                  <div className="flex items-center justify-between p-2 rounded-xl bg-orange-50 border border-orange-200/60 text-orange-950">
                    <span className="font-bold">Shopee Philippines</span>
                    <span className="text-[10px] font-semibold bg-white px-2 py-0.5 rounded-md text-orange-600">
                      Synced Orders
                    </span>
                  </div>
                  <div className="flex items-center justify-between p-2 rounded-xl bg-blue-50 border border-blue-200/60 text-blue-950">
                    <span className="font-bold">Lazada Express Hub</span>
                    <span className="text-[10px] font-semibold bg-white px-2 py-0.5 rounded-md text-blue-600">
                      Synced Orders
                    </span>
                  </div>
                  <div className="flex items-center justify-between p-2 rounded-xl bg-slate-100 border border-slate-200 text-slate-900">
                    <span className="font-bold">TikTok Shop PH</span>
                    <span className="text-[10px] font-semibold bg-white px-2 py-0.5 rounded-md text-slate-800">
                      Synced Orders
                    </span>
                  </div>
                </div>
              </div>

              {/* Data Privacy Status */}
              <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-2xs">
                <div className="flex items-center gap-2 mb-1.5">
                  <ShieldCheck className="w-4 h-4 text-emerald-600" />
                  <h3 className="text-xs font-bold text-[#0F172A]">
                    RA 10173 Buyer Privacy Active
                  </h3>
                </div>
                <p className="text-[11px] text-slate-500 leading-relaxed">
                  Your delivery address and phone number are masked in outbound manifests in compliance with the National Privacy Commission.
                </p>
              </div>

              {/* Sign Out Button (Only action to exit customer view) */}
              <button
                onClick={onSignOut}
                className="w-full py-3 px-4 bg-rose-50 hover:bg-rose-100 border border-rose-200 text-rose-700 font-bold text-xs rounded-2xl flex items-center justify-center gap-2 transition-colors cursor-pointer mt-2"
              >
                <LogOut className="w-4 h-4" />
                <span>Sign Out of Customer Account</span>
              </button>
            </div>
          )}
        </main>

        {/* Customer Bottom Navigation Bar */}
        <nav className="fixed bottom-0 left-0 right-0 max-w-md mx-auto bg-white/95 backdrop-blur-md border-t border-slate-200 px-3 py-2 z-40 shadow-lg">
          <div className="flex items-center justify-around">
            <button
              onClick={() => setCurrentTab('parcels')}
              className={`flex flex-col items-center justify-center gap-1 py-1 px-3 rounded-xl transition-all cursor-pointer ${
                currentTab === 'parcels' ? 'text-[#0EA5E9]' : 'text-slate-400 hover:text-slate-600'
              }`}
            >
              <Package className={`w-5 h-5 ${currentTab === 'parcels' ? 'stroke-[2.5]' : ''}`} />
              <span className="text-[10px] font-bold">My Orders</span>
            </button>

            <button
              onClick={() => setCurrentTab('store')}
              className={`flex flex-col items-center justify-center gap-1 py-1 px-3 rounded-xl transition-all cursor-pointer ${
                currentTab === 'store' ? 'text-emerald-600' : 'text-slate-400 hover:text-slate-600'
              }`}
            >
              <ShoppingBag className={`w-5 h-5 ${currentTab === 'store' ? 'stroke-[2.5]' : ''}`} />
              <span className="text-[10px] font-bold">Store</span>
            </button>

            <button
              onClick={() => setCurrentTab('chat')}
              className={`flex flex-col items-center justify-center gap-1 py-1 px-3 rounded-xl transition-all relative cursor-pointer ${
                currentTab === 'chat' ? 'text-[#0F172A]' : 'text-slate-400 hover:text-slate-600'
              }`}
            >
              <div className="relative">
                <MessageSquare className={`w-5 h-5 ${currentTab === 'chat' ? 'stroke-[2.5]' : ''}`} />
                <span className="w-2 h-2 rounded-full bg-rose-500 absolute -top-0.5 -right-0.5" />
              </div>
              <span className="text-[10px] font-bold">Admin Chat</span>
            </button>

            <button
              onClick={() => setCurrentTab('account')}
              className={`flex flex-col items-center justify-center gap-1 py-1 px-3 rounded-xl transition-all cursor-pointer ${
                currentTab === 'account' ? 'text-[#0EA5E9]' : 'text-slate-400 hover:text-slate-600'
              }`}
            >
              <User className={`w-5 h-5 ${currentTab === 'account' ? 'stroke-[2.5]' : ''}`} />
              <span className="text-[10px] font-bold">Account</span>
            </button>
          </div>
        </nav>
      </div>
    </div>
  );
};
