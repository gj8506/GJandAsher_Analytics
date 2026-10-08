import React from 'react';
import { Package, ArrowLeftRight, MessageSquare, BarChart3, User } from 'lucide-react';

interface NavbarProps {
  currentTab: number;
  onSelectTab: (index: number) => void;
  pendingReturnsCount?: number;
  unreadMessagesCount?: number;
}

export const Navbar: React.FC<NavbarProps> = ({
  currentTab,
  onSelectTab,
  pendingReturnsCount = 1,
  unreadMessagesCount = 0,
}) => {
  const items = [
    { label: 'Parcels', icon: Package, index: 0, tag: 'parcels' },
    {
      label: 'Operations',
      icon: ArrowLeftRight,
      index: 1,
      tag: 'operations',
      badge: pendingReturnsCount,
    },
    {
      label: 'Chat',
      icon: MessageSquare,
      index: 2,
      tag: 'chat',
      badge: unreadMessagesCount,
    },
    { label: 'Analytics', icon: BarChart3, index: 3, tag: 'analytics' },
    { label: 'Profile', icon: User, index: 4, tag: 'profile' },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 max-w-md mx-auto bg-white border-t border-slate-200 z-40 shadow-lg px-2 py-1">
      <div className="flex items-center justify-around">
        {items.map((item) => {
          const Icon = item.icon;
          const isSelected = currentTab === item.index;

          return (
            <button
              key={item.index}
              data-testid={`nav_${item.tag}`}
              onClick={() => onSelectTab(item.index)}
              className={`flex flex-col items-center justify-center flex-1 py-1.5 px-1 relative transition-colors ${
                isSelected ? 'text-[#0F172A]' : 'text-slate-400 hover:text-slate-600'
              }`}
            >
              <div
                className={`flex items-center justify-center w-11 h-7 rounded-full transition-all duration-150 relative ${
                  isSelected ? 'bg-[#0F172A] text-white shadow-sm' : 'text-slate-500'
                }`}
              >
                <Icon className="w-4 h-4" />
                {item.badge !== undefined && item.badge > 0 && !isSelected && (
                  <span className="absolute -top-0.5 right-1 w-2.5 h-2.5 rounded-full bg-rose-500 ring-2 ring-white" />
                )}
              </div>
              <span
                className={`text-[11px] mt-0.5 tracking-tight ${
                  isSelected ? 'font-bold text-[#0F172A]' : 'font-normal text-slate-500'
                }`}
              >
                {item.label}
              </span>
            </button>
          );
        })}
      </div>
    </nav>
  );
};
