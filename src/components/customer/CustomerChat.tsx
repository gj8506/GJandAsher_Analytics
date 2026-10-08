import React, { useState, useRef, useEffect } from 'react';
import { ChatMessage, ChatType } from '../../types';
import {
  Send,
  Package,
  ShoppingBag,
  RotateCcw,
  MessageSquare,
  Sparkles,
  X,
  CheckCheck,
  Clock,
  HelpCircle,
} from 'lucide-react';

interface CustomerChatProps {
  messages: ChatMessage[];
  onSendMessage: (
    text: string,
    attachedItem?: { type: 'parcel' | 'product'; id: string; name: string },
    chatType?: ChatType
  ) => void;
  isAdminTyping?: boolean;
  pendingAttachment?: { type: 'parcel' | 'product'; id: string; name: string } | null;
  onClearAttachment?: () => void;
  customerName: string;
}

interface ChatTypeOption {
  id: ChatType;
  label: string;
  icon: React.ElementType;
  badgeColor: string;
  placeholder: string;
  quickPrompts: string[];
}

const CHAT_TYPES: ChatTypeOption[] = [
  {
    id: 'order',
    label: 'Order Tracking',
    icon: Package,
    badgeColor: 'bg-sky-50 text-sky-700 border-sky-200',
    placeholder: 'Ask Admin about parcel tracking or courier status...',
    quickPrompts: [
      'Where is my dispatched order?',
      'When will courier tracking update?',
      'Can I change my delivery address?',
      'Expected arrival date in Manila?',
    ],
  },
  {
    id: 'return',
    label: 'Returns & RTS',
    icon: RotateCcw,
    badgeColor: 'bg-amber-50 text-amber-700 border-amber-200',
    placeholder: 'Ask Admin about returns, damages, or refund inspection...',
    quickPrompts: [
      'How do I process a damaged return?',
      'What is the status of my refund inspection?',
      'My package arrived with broken seal',
      'Return drop-off hub location?',
    ],
  },
  {
    id: 'product',
    label: 'Product Stock',
    icon: ShoppingBag,
    badgeColor: 'bg-emerald-50 text-emerald-700 border-emerald-200',
    placeholder: 'Ask Admin about product specs, stock, and availability...',
    quickPrompts: [
      'Is the mechanical keyboard in stock?',
      'Do you offer wholesale bulk pricing?',
      'When will new electronics arrive?',
      'Are prices inclusive of shipping?',
    ],
  },
  {
    id: 'general',
    label: 'General Help',
    icon: HelpCircle,
    badgeColor: 'bg-indigo-50 text-indigo-700 border-indigo-200',
    placeholder: 'Type your message or inquiry to warehouse admin...',
    quickPrompts: [
      'What are your warehouse operating hours?',
      'Where is the main distribution center?',
      'How do I contact customer support?',
      'Request official sales invoice (BIR)',
    ],
  },
];

export const CustomerChat: React.FC<CustomerChatProps> = ({
  messages,
  onSendMessage,
  isAdminTyping = false,
  pendingAttachment,
  onClearAttachment,
  customerName,
}) => {
  const [selectedType, setSelectedType] = useState<ChatType>(() => {
    if (pendingAttachment?.type === 'parcel') return 'order';
    if (pendingAttachment?.type === 'product') return 'product';
    return 'order';
  });

  const [inputText, setInputText] = useState('');
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Auto-switch type if attachment arrives
  useEffect(() => {
    if (pendingAttachment?.type === 'parcel') {
      setSelectedType('order');
    } else if (pendingAttachment?.type === 'product') {
      setSelectedType('product');
    }
  }, [pendingAttachment]);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages, isAdminTyping]);

  const activeTypeConfig = CHAT_TYPES.find((t) => t.id === selectedType) || CHAT_TYPES[0];

  const handleSend = (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (!inputText.trim() && !pendingAttachment) return;

    onSendMessage(inputText.trim(), pendingAttachment || undefined, selectedType);
    setInputText('');
  };

  const getChatTypeBadge = (type?: ChatType) => {
    switch (type) {
      case 'order':
        return (
          <span className="inline-flex items-center gap-1 text-[9px] font-semibold px-1.5 py-0.5 rounded-md bg-sky-100 text-sky-800">
            <Package className="w-2.5 h-2.5" /> Order Inquiry
          </span>
        );
      case 'return':
        return (
          <span className="inline-flex items-center gap-1 text-[9px] font-semibold px-1.5 py-0.5 rounded-md bg-amber-100 text-amber-800">
            <RotateCcw className="w-2.5 h-2.5" /> Return / RTS
          </span>
        );
      case 'product':
        return (
          <span className="inline-flex items-center gap-1 text-[9px] font-semibold px-1.5 py-0.5 rounded-md bg-emerald-100 text-emerald-800">
            <ShoppingBag className="w-2.5 h-2.5" /> Product Inquiry
          </span>
        );
      case 'general':
      default:
        return (
          <span className="inline-flex items-center gap-1 text-[9px] font-semibold px-1.5 py-0.5 rounded-md bg-slate-100 text-slate-700">
            <HelpCircle className="w-2.5 h-2.5" /> General Help
          </span>
        );
    }
  };

  return (
    <div className="h-full flex-1 flex flex-col min-h-0 w-full bg-[#F8FAFC] overflow-hidden">
      {/* Chat Header */}
      <div className="p-3 bg-white border-b border-slate-200 flex items-center justify-between shadow-2xs shrink-0">
        <div className="flex items-center gap-2.5 min-w-0">
          <div className="relative shrink-0">
            <div className="w-9 h-9 rounded-full bg-[#0F172A] text-white flex items-center justify-center font-bold text-xs shadow-xs">
              GJ
            </div>
            <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 border-2 border-white absolute bottom-0 right-0" />
          </div>
          <div className="min-w-0">
            <div className="flex items-center gap-1.5">
              <h2 className="text-xs font-bold text-[#0F172A] truncate">
                Admin Support (gj8506)
              </h2>
              <span className="text-[9px] bg-sky-100 text-[#0EA5E9] font-bold px-1.5 py-0.2 rounded-md shrink-0">
                Verified Admin
              </span>
            </div>
            <p className="text-[10px] text-slate-500 truncate">
              GJ & Asher Logistics Management • Online
            </p>
          </div>
        </div>
        <div className="text-[10px] text-emerald-700 bg-emerald-50 font-bold px-2 py-0.5 rounded-lg border border-emerald-200 shrink-0">
          Live Help
        </div>
      </div>

      {/* Inquiry Type / Category Selector */}
      <div className="px-3 py-2 bg-white border-b border-slate-200 shrink-0">
        <div className="flex items-center justify-between mb-1.5">
          <span className="text-[10px] font-bold text-slate-500 uppercase tracking-wider">
            Select Inquiry Type:
          </span>
          <span className="text-[10px] text-sky-600 font-semibold">
            {activeTypeConfig.label}
          </span>
        </div>
        <div className="grid grid-cols-4 gap-1.5">
          {CHAT_TYPES.map((type) => {
            const Icon = type.icon;
            const isSelected = selectedType === type.id;
            return (
              <button
                key={type.id}
                onClick={() => setSelectedType(type.id)}
                className={`py-1.5 px-1 rounded-xl text-[10px] font-bold flex flex-col items-center justify-center gap-1 transition-all cursor-pointer border ${
                  isSelected
                    ? 'bg-[#0F172A] text-white border-[#0F172A] shadow-xs'
                    : 'bg-slate-50 text-slate-600 border-slate-200/80 hover:bg-slate-100 hover:text-slate-900'
                }`}
              >
                <Icon className={`w-3.5 h-3.5 ${isSelected ? 'text-sky-300' : 'text-slate-500'}`} />
                <span className="leading-tight text-center truncate max-w-full">
                  {type.label.split(' ')[0]}
                </span>
              </button>
            );
          })}
        </div>
      </div>

      {/* Messages Feed */}
      <div className="flex-1 min-h-0 overflow-y-auto p-3.5 space-y-3">
        {/* Intro notice banner */}
        <div className="bg-sky-50/80 border border-sky-200/70 rounded-2xl p-2.5 text-center">
          <p className="text-[11px] font-semibold text-[#0F172A]">
            Direct Customer-Admin Messaging Log
          </p>
          <p className="text-[10px] text-slate-500 mt-0.5">
            Logged securely under RA 10173 Philippine Data Privacy Act.
          </p>
        </div>

        {/* Empty State when no messages exist */}
        {messages.length === 0 && (
          <div className="py-10 text-center text-slate-400">
            <div className="w-12 h-12 rounded-2xl bg-sky-50 text-[#0EA5E9] flex items-center justify-center mx-auto mb-2 border border-sky-100">
              <MessageSquare className="w-6 h-6" />
            </div>
            <p className="text-xs font-bold text-slate-700">No conversation history yet</p>
            <p className="text-[11px] text-slate-400 mt-1 max-w-xs mx-auto leading-relaxed">
              Select an inquiry type above or type a message to start direct communication with the warehouse administration desk.
            </p>
          </div>
        )}

        {/* Render chat messages */}
        {messages.map((msg) => {
          const isCustomer = msg.sender === 'customer';

          return (
            <div
              key={msg.id}
              className={`flex flex-col ${isCustomer ? 'items-end' : 'items-start'}`}
            >
              <div className="flex items-center gap-1.5 text-[10px] text-slate-400 mb-1 px-1">
                <span className="font-medium text-slate-600">
                  {isCustomer ? `${customerName} (You)` : msg.senderName}
                </span>
                <span>•</span>
                <span>{msg.timestamp}</span>
              </div>

              {/* Message Bubble */}
              <div
                className={`max-w-[85%] p-3 rounded-2xl text-xs leading-relaxed shadow-2xs break-words ${
                  isCustomer
                    ? 'bg-[#0F172A] text-white rounded-tr-xs'
                    : 'bg-white text-slate-800 border border-slate-200 rounded-tl-xs'
                }`}
              >
                {/* Inquiry Type and Tracking Header */}
                <div className="flex flex-wrap items-center gap-1.5 mb-1.5">
                  {getChatTypeBadge(msg.chatType)}

                  {msg.trackingNumber && (
                    <span
                      className={`inline-flex items-center gap-1 text-[9px] font-mono font-bold px-1.5 py-0.5 rounded-md ${
                        isCustomer ? 'bg-white/10 text-sky-300' : 'bg-slate-100 text-slate-700'
                      }`}
                    >
                      <Package className="w-2.5 h-2.5" />
                      #{msg.trackingNumber}
                    </span>
                  )}
                </div>

                <p className="whitespace-pre-wrap">{msg.text}</p>
              </div>
            </div>
          );
        })}

        {/* Admin is typing simulation indicator */}
        {isAdminTyping && (
          <div className="flex flex-col items-start animate-fade-in">
            <div className="flex items-center gap-1 text-[10px] text-slate-400 mb-1 px-1">
              <span>Admin (gj8506)</span>
              <span>•</span>
              <span className="text-sky-600 font-medium">typing...</span>
            </div>
            <div className="bg-white border border-slate-200 p-2.5 px-3 rounded-2xl rounded-tl-xs flex items-center gap-1.5 shadow-2xs">
              <span className="w-2 h-2 rounded-full bg-sky-500 animate-bounce" />
              <span
                className="w-2 h-2 rounded-full bg-sky-500 animate-bounce"
                style={{ animationDelay: '0.2s' }}
              />
              <span
                className="w-2 h-2 rounded-full bg-sky-500 animate-bounce"
                style={{ animationDelay: '0.4s' }}
              />
              <span className="text-[10px] text-slate-500 font-medium ml-1">
                Admin is replying...
              </span>
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* Quick Prompts Bar based on selected chat type */}
      <div className="px-3 py-1.5 bg-slate-100/90 border-t border-slate-200 shrink-0 overflow-x-auto no-scrollbar flex items-center gap-1.5">
        <Sparkles className="w-3 h-3 text-sky-600 shrink-0 ml-0.5" />
        {activeTypeConfig.quickPrompts.map((prompt) => (
          <button
            key={prompt}
            onClick={() => {
              setInputText(prompt);
            }}
            className="text-[10px] px-2.5 py-1 rounded-lg bg-white border border-slate-200/90 text-slate-600 hover:text-slate-900 shrink-0 font-medium hover:border-slate-300 transition-colors cursor-pointer"
          >
            {prompt}
          </button>
        ))}
      </div>

      {/* Attachment indicator if present */}
      {pendingAttachment && (
        <div className="px-3 py-1.5 bg-sky-50 border-t border-sky-100 flex items-center justify-between text-xs shrink-0">
          <div className="flex items-center gap-1.5 text-sky-950 font-medium text-[11px] truncate">
            <Package className="w-3.5 h-3.5 text-sky-600 shrink-0" />
            <span className="truncate">Inquiring: {pendingAttachment.name}</span>
          </div>
          {onClearAttachment && (
            <button
              onClick={onClearAttachment}
              className="text-[10px] font-bold text-sky-700 hover:text-sky-900 ml-2 shrink-0 flex items-center gap-0.5 cursor-pointer"
            >
              <X className="w-3 h-3" />
              Clear
            </button>
          )}
        </div>
      )}

      {/* Text Input Form */}
      <form
        onSubmit={handleSend}
        className="p-2.5 bg-white border-t border-slate-200 flex items-center gap-2 shrink-0"
      >
        <div className="relative flex-1 flex items-center">
          <input
            type="text"
            value={inputText}
            onChange={(e) => setInputText(e.target.value)}
            placeholder={activeTypeConfig.placeholder}
            className="w-full pl-3.5 pr-8 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9]"
          />
          {inputText && (
            <button
              type="button"
              onClick={() => setInputText('')}
              className="absolute right-2.5 text-slate-400 hover:text-slate-600 cursor-pointer p-0.5"
            >
              <X className="w-3.5 h-3.5" />
            </button>
          )}
        </div>

        <button
          type="submit"
          disabled={!inputText.trim() && !pendingAttachment}
          className={`p-2.5 rounded-xl font-bold transition-all shrink-0 flex items-center justify-center ${
            inputText.trim() || pendingAttachment
              ? 'bg-[#0F172A] hover:bg-slate-800 text-white cursor-pointer shadow-xs active:scale-95'
              : 'bg-slate-100 text-slate-300 cursor-not-allowed'
          }`}
          title="Send Message"
        >
          <Send className="w-4 h-4" />
        </button>
      </form>
    </div>
  );
};
