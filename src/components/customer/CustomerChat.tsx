import React, { useState, useRef, useEffect } from 'react';
import { ChatMessage, Parcel, Product } from '../../types';
import { Send, Shield, Package, ShoppingBag, CheckCheck, Clock, User, Sparkles } from 'lucide-react';

interface CustomerChatProps {
  messages: ChatMessage[];
  onSendMessage: (text: string, attachedItem?: { type: 'parcel' | 'product'; id: string; name: string }) => void;
  pendingAttachment?: { type: 'parcel' | 'product'; id: string; name: string } | null;
  onClearAttachment?: () => void;
  customerName: string;
}

export const CustomerChat: React.FC<CustomerChatProps> = ({
  messages,
  onSendMessage,
  pendingAttachment,
  onClearAttachment,
  customerName,
}) => {
  const [inputText, setInputText] = useState('');
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleSend = (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (!inputText.trim() && !pendingAttachment) return;

    onSendMessage(inputText.trim(), pendingAttachment || undefined);
    setInputText('');
  };

  const quickPrompts = [
    'Where is my dispatched order?',
    'How do I process a damaged return?',
    'Is the mechanical keyboard in stock?',
    'Can I change my delivery address?',
  ];

  return (
    <div className="flex flex-col h-[calc(100vh-4rem)] max-w-md mx-auto w-full bg-[#F8FAFC]">
      {/* Chat Header */}
      <div className="p-3.5 bg-white border-b border-slate-200 flex items-center justify-between shadow-2xs">
        <div className="flex items-center gap-2.5">
          <div className="relative">
            <div className="w-10 h-10 rounded-full bg-[#0F172A] text-white flex items-center justify-center font-bold text-xs">
              NC
            </div>
            <span className="w-3 h-3 rounded-full bg-emerald-500 border-2 border-white absolute bottom-0 right-0" />
          </div>
          <div>
            <div className="flex items-center gap-1.5">
              <h2 className="text-xs font-bold text-[#0F172A]">
                Admin Support (Nolan Caparros)
              </h2>
              <span className="text-[9px] bg-sky-100 text-[#0EA5E9] font-bold px-1.5 py-0.2 rounded-md">
                Admin
              </span>
            </div>
            <p className="text-[10px] text-slate-500">
              GJ & Asher Logistics Management • Online
            </p>
          </div>
        </div>
        <div className="text-[10px] text-emerald-700 bg-emerald-50 font-bold px-2 py-1 rounded-lg border border-emerald-200">
          Direct Log
        </div>
      </div>

      {/* Messages Feed */}
      <div className="flex-1 overflow-y-auto p-4 space-y-3.5">
        {/* Intro notice banner */}
        <div className="bg-sky-50 border border-sky-200 rounded-2xl p-3 text-center">
          <p className="text-[11px] font-semibold text-[#0F172A]">
            Direct Customer-Admin Messaging Log
          </p>
          <p className="text-[10px] text-slate-500 mt-0.5">
            Messages are recorded securely in compliance with RA 10173 Data Privacy Act.
          </p>
        </div>

        {messages.map((msg) => {
          const isCustomer = msg.sender === 'customer';

          return (
            <div
              key={msg.id}
              className={`flex flex-col ${isCustomer ? 'items-end' : 'items-start'}`}
            >
              <div className="flex items-center gap-1 text-[10px] text-slate-400 mb-1 px-1">
                <span>{msg.senderName}</span>
                <span>•</span>
                <span>{msg.timestamp}</span>
              </div>

              {/* Message Bubble */}
              <div
                className={`max-w-[82%] p-3 rounded-2xl text-xs leading-relaxed shadow-2xs ${
                  isCustomer
                    ? 'bg-[#0F172A] text-white rounded-tr-xs'
                    : 'bg-white text-slate-800 border border-slate-200 rounded-tl-xs'
                }`}
              >
                {/* Attached Tracking or Product Badge */}
                {msg.trackingNumber && (
                  <div
                    className={`mb-2 p-1.5 rounded-lg text-[10px] font-mono font-bold flex items-center gap-1.5 ${
                      isCustomer
                        ? 'bg-white/10 text-sky-300'
                        : 'bg-slate-100 text-slate-700'
                    }`}
                  >
                    <Package className="w-3 h-3 shrink-0" />
                    <span>Inquiry Tracking: {msg.trackingNumber}</span>
                  </div>
                )}

                <p>{msg.text}</p>
              </div>
            </div>
          );
        })}

        <div ref={messagesEndRef} />
      </div>

      {/* Quick Prompts Bar */}
      <div className="px-3 py-1.5 bg-slate-100/90 border-t border-slate-200 overflow-x-auto no-scrollbar flex items-center gap-1.5">
        {quickPrompts.map((prompt) => (
          <button
            key={prompt}
            onClick={() => {
              setInputText(prompt);
            }}
            className="text-[10px] font-medium bg-white text-slate-700 hover:bg-slate-50 border border-slate-200 px-2.5 py-1 rounded-full whitespace-nowrap shrink-0 shadow-2xs"
          >
            {prompt}
          </button>
        ))}
      </div>

      {/* Input Bar */}
      <form
        onSubmit={handleSend}
        className="p-3 bg-white border-t border-slate-200 flex flex-col gap-2"
      >
        {pendingAttachment && (
          <div className="flex items-center justify-between bg-sky-50 border border-sky-200 rounded-xl px-2.5 py-1 text-xs">
            <div className="flex items-center gap-1.5 text-sky-800">
              <Package className="w-3.5 h-3.5" />
              <span className="font-semibold text-[11px]">
                Attached: {pendingAttachment.name}
              </span>
            </div>
            {onClearAttachment && (
              <button
                type="button"
                onClick={onClearAttachment}
                className="text-xs text-sky-600 hover:text-sky-900 font-bold"
              >
                Remove
              </button>
            )}
          </div>
        )}

        <div className="flex items-center gap-2">
          <input
            type="text"
            value={inputText}
            onChange={(e) => setInputText(e.target.value)}
            placeholder="Type your message to Admin..."
            className="flex-1 px-3.5 py-2.5 bg-slate-100 border border-slate-200 rounded-xl text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9] focus:bg-white"
          />
          <button
            type="submit"
            disabled={!inputText.trim() && !pendingAttachment}
            className={`p-2.5 rounded-xl transition-all ${
              inputText.trim() || pendingAttachment
                ? 'bg-[#0F172A] text-white hover:bg-slate-800 shadow-xs cursor-pointer'
                : 'bg-slate-200 text-slate-400 cursor-not-allowed'
            }`}
          >
            <Send className="w-4 h-4" />
          </button>
        </div>
      </form>
    </div>
  );
};
