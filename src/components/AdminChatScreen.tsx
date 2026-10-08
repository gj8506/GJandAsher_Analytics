import React, { useState, useRef, useEffect } from 'react';
import { ChatMessage, Parcel } from '../types';
import { Send, MessageSquare, Package, CheckCheck, Clock, User, Sparkles, AlertCircle, RefreshCw } from 'lucide-react';

interface AdminChatScreenProps {
  messages: ChatMessage[];
  onSendMessage: (text: string, trackingNumber?: string) => void;
  parcels: Parcel[];
  adminName?: string;
}

export const AdminChatScreen: React.FC<AdminChatScreenProps> = ({
  messages,
  onSendMessage,
  parcels,
  adminName = 'Admin (gj8506)',
}) => {
  const [inputText, setInputText] = useState('');
  const [selectedTracking, setSelectedTracking] = useState<string>('');
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleSend = (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (!inputText.trim()) return;

    onSendMessage(inputText.trim(), selectedTracking || undefined);
    setInputText('');
    setSelectedTracking('');
  };

  const quickAdminReplies = [
    '📦 Your parcel has been dispatched and is currently in transit with the courier.',
    '✅ We have received your return package and the refund inspection is approved.',
    '🚚 Handed over to courier hub today. Airway bill tracking updates within 12 hours.',
    '⏳ We are checking this order with our warehouse fulfillment staff.',
  ];

  return (
    <div className="flex flex-col h-[calc(100vh-7rem)] max-w-md mx-auto w-full bg-[#F8FAFC]">
      {/* Top Header */}
      <div className="p-3.5 bg-white border-b border-slate-200 flex items-center justify-between shadow-2xs">
        <div className="flex items-center gap-2.5">
          <div className="relative">
            <div className="w-10 h-10 rounded-full bg-[#0F172A] text-white flex items-center justify-center font-bold text-xs">
              <MessageSquare className="w-5 h-5 text-sky-400" />
            </div>
            <span className="w-3 h-3 rounded-full bg-emerald-500 border-2 border-white absolute bottom-0 right-0" />
          </div>
          <div>
            <div className="flex items-center gap-1.5">
              <h2 className="text-xs font-bold text-[#0F172A]">
                Customer Support Hub
              </h2>
              <span className="text-[9px] bg-emerald-100 text-emerald-800 font-bold px-1.5 py-0.2 rounded-md">
                Admin Channel
              </span>
            </div>
            <p className="text-[10px] text-slate-500">
              Direct live messages with registered customers
            </p>
          </div>
        </div>

        <div className="text-right">
          <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-sky-50 text-sky-700 border border-sky-200">
            {messages.length} Messages
          </span>
        </div>
      </div>

      {/* Info notice bar */}
      <div className="px-4 py-2 bg-slate-100/90 border-b border-slate-200 flex items-center justify-between text-[11px] text-slate-600">
        <div className="flex items-center gap-1.5">
          <User className="w-3.5 h-3.5 text-slate-500" />
          <span className="font-medium">Active Channel: All Registered Customers</span>
        </div>
        <span className="text-[10px] text-slate-400">RA 10173 DPA Protected</span>
      </div>

      {/* Messages Feed */}
      <div className="flex-1 overflow-y-auto p-4 space-y-3.5">
        {messages.length === 0 ? (
          <div className="py-14 text-center text-slate-400">
            <div className="w-12 h-12 rounded-full bg-sky-50 text-sky-600 flex items-center justify-center mx-auto mb-2.5">
              <MessageSquare className="w-6 h-6" />
            </div>
            <p className="text-xs font-bold text-slate-700">No customer messages yet</p>
            <p className="text-[11px] text-slate-400 mt-1 max-w-xs mx-auto">
              When customers inquire about their parcels, returns, or products from the Customer Portal, their inquiries will appear here in real time.
            </p>
            <div className="mt-4">
              <button
                type="button"
                onClick={() =>
                  onSendMessage(
                    'Welcome to GJ & Asher Warehouse! We are online and ready to assist you with order tracking, dispatches, and returns.'
                  )
                }
                className="text-xs bg-slate-900 text-white font-medium px-3.5 py-1.5 rounded-lg hover:bg-slate-800 transition-colors cursor-pointer shadow-xs"
              >
                Send Welcome Message to Customers
              </button>
            </div>
          </div>
        ) : (
          messages.map((msg) => {
            const isAdmin = msg.sender === 'admin';

            return (
              <div
                key={msg.id}
                className={`flex flex-col ${isAdmin ? 'items-end' : 'items-start'}`}
              >
                <div className="flex items-center gap-1.5 text-[10px] text-slate-400 mb-1 px-1">
                  <span className="font-semibold text-slate-600">
                    {isAdmin ? `${msg.senderName} (You)` : msg.senderName}
                  </span>
                  <span>•</span>
                  <span>{msg.timestamp}</span>
                </div>

                <div
                  className={`max-w-[85%] p-3 rounded-2xl text-xs leading-relaxed shadow-2xs ${
                    isAdmin
                      ? 'bg-[#0F172A] text-white rounded-tr-xs'
                      : 'bg-white text-slate-800 border border-slate-200 rounded-tl-xs'
                  }`}
                >
                  {/* Attached Tracking Badge if present */}
                  <div className="flex flex-wrap items-center gap-1.5 mb-2">
                    {msg.chatType && (
                      <span className={`text-[9px] font-semibold px-1.5 py-0.5 rounded-md ${
                        isAdmin ? 'bg-white/10 text-sky-200' : 'bg-sky-100 text-sky-800'
                      }`}>
                        {msg.chatType === 'order' && '📦 Order Inquiry'}
                        {msg.chatType === 'return' && '🔄 Return / RTS'}
                        {msg.chatType === 'product' && '🛍️ Product Stock'}
                        {msg.chatType === 'general' && '💬 General Help'}
                      </span>
                    )}

                    {msg.trackingNumber && (
                      <div
                        className={`p-1 rounded-md text-[10px] font-mono font-bold flex items-center gap-1 ${
                          isAdmin
                            ? 'bg-white/10 text-sky-300'
                            : 'bg-slate-100 text-slate-700'
                        }`}
                      >
                        <Package className="w-3 h-3 shrink-0 text-sky-400" />
                        <span>#{msg.trackingNumber}</span>
                      </div>
                    )}
                  </div>

                  <p className="whitespace-pre-line">{msg.text}</p>
                </div>
              </div>
            );
          })
        )}
        <div ref={messagesEndRef} />
      </div>

      {/* Quick Admin Responses */}
      <div className="px-3 py-1.5 bg-slate-100/90 border-t border-slate-200 overflow-x-auto no-scrollbar flex items-center gap-1.5">
        <span className="text-[10px] text-slate-500 font-bold shrink-0 pl-1">
          Quick:
        </span>
        {quickAdminReplies.map((reply, idx) => (
          <button
            key={idx}
            type="button"
            onClick={() => setInputText(reply)}
            className="text-[10px] px-2.5 py-1 rounded-lg bg-white border border-slate-200 text-slate-700 hover:text-slate-900 shrink-0 font-medium hover:border-slate-300 transition-colors cursor-pointer truncate max-w-[220px]"
          >
            {reply}
          </button>
        ))}
      </div>

      {/* Parcel Reference Selector (Optional attachment) */}
      {parcels.length > 0 && (
        <div className="px-3 py-1.5 bg-white border-t border-slate-100 flex items-center gap-2 text-xs">
          <Package className="w-3.5 h-3.5 text-slate-400 shrink-0" />
          <span className="text-[10px] text-slate-500 font-medium shrink-0">
            Link Airway Bill:
          </span>
          <select
            value={selectedTracking}
            onChange={(e) => setSelectedTracking(e.target.value)}
            className="text-[11px] bg-slate-50 border border-slate-200 rounded-md px-2 py-0.5 text-slate-700 focus:outline-hidden focus:border-slate-400 flex-1 truncate"
          >
            <option value="">None (General Message)</option>
            {parcels.map((p) => (
              <option key={p.id} value={p.trackingNumber}>
                {p.trackingNumber} ({p.customer} - {p.platform})
              </option>
            ))}
          </select>
          {selectedTracking && (
            <button
              type="button"
              onClick={() => setSelectedTracking('')}
              className="text-[10px] text-rose-500 hover:underline cursor-pointer"
            >
              Clear
            </button>
          )}
        </div>
      )}

      {/* Admin Message Input Bar */}
      <form
        onSubmit={handleSend}
        className="p-2.5 bg-white border-t border-slate-200 flex items-center gap-2"
      >
        <input
          type="text"
          value={inputText}
          onChange={(e) => setInputText(e.target.value)}
          placeholder="Reply to customer as Admin..."
          className="flex-1 bg-slate-50 border border-slate-200 rounded-xl px-3.5 py-2 text-xs text-slate-800 placeholder-slate-400 focus:outline-hidden focus:ring-1 focus:ring-slate-900 focus:bg-white transition-all"
        />
        <button
          type="submit"
          disabled={!inputText.trim()}
          className={`p-2 rounded-xl flex items-center justify-center transition-colors cursor-pointer ${
            inputText.trim()
              ? 'bg-[#0F172A] text-white hover:bg-slate-800 shadow-xs'
              : 'bg-slate-100 text-slate-300 cursor-not-allowed'
          }`}
          title="Send Admin Reply"
        >
          <Send className="w-4 h-4" />
        </button>
      </form>
    </div>
  );
};
