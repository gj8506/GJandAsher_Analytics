import React, { useState } from 'react';
import { Parcel, ReturnRecord } from '../types';
import { DispatchScreen } from './DispatchScreen';
import { ReturnsScreen } from './ReturnsScreen';
import { Send, RotateCcw, ArrowRightLeft } from 'lucide-react';

interface OperationsScreenProps {
  onAddParcel: (parcel: Parcel) => void;
  onNavigateToParcels: () => void;
  returns: ReturnRecord[];
  onAddReturn: (record: ReturnRecord) => void;
  initialProcess?: 'dispatch' | 'returns';
}

export const OperationsScreen: React.FC<OperationsScreenProps> = ({
  onAddParcel,
  onNavigateToParcels,
  returns,
  onAddReturn,
  initialProcess = 'dispatch',
}) => {
  const [activeProcess, setActiveProcess] = useState<'dispatch' | 'returns'>(initialProcess);
  const pendingCount = returns.filter((r) => r.refundStatus === 'Pending Inspection').length;

  return (
    <div className="flex flex-col min-h-full pb-20">
      {/* Top Process Switcher / Toggle Header */}
      <div className="sticky top-0 z-30 bg-white/95 backdrop-blur-md border-b border-slate-200 px-4 py-3 shadow-2xs">
        <div className="flex items-center justify-between mb-2">
          <div className="flex items-center gap-2">
            <div className="w-7 h-7 rounded-lg bg-slate-900 text-white flex items-center justify-center">
              <ArrowRightLeft className="w-3.5 h-3.5" />
            </div>
            <div>
              <h1 className="text-xs font-bold text-slate-900 leading-tight">
                Logistics Operations
              </h1>
              <p className="text-[10px] text-slate-500">
                Switch between Outbound Dispatch & RTS Return workflows
              </p>
            </div>
          </div>
          <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-slate-100 text-slate-700 border border-slate-200">
            {activeProcess === 'dispatch' ? 'Outbound Mode' : 'Inbound RTS Mode'}
          </span>
        </div>

        {/* Segmented Switcher Controls */}
        <div className="bg-slate-100 p-1 rounded-xl flex items-center gap-1 border border-slate-200/80">
          <button
            type="button"
            data-testid="toggle_process_dispatch"
            onClick={() => setActiveProcess('dispatch')}
            className={`flex-1 py-1.5 px-3 rounded-lg text-xs font-bold flex items-center justify-center gap-2 transition-all cursor-pointer ${
              activeProcess === 'dispatch'
                ? 'bg-white text-slate-900 shadow-xs border border-slate-200/60'
                : 'text-slate-500 hover:text-slate-800'
            }`}
          >
            <Send className="w-3.5 h-3.5 text-sky-600" />
            <span>1. Dispatch Process</span>
          </button>

          <button
            type="button"
            data-testid="toggle_process_returns"
            onClick={() => setActiveProcess('returns')}
            className={`flex-1 py-1.5 px-3 rounded-lg text-xs font-bold flex items-center justify-center gap-2 transition-all cursor-pointer relative ${
              activeProcess === 'returns'
                ? 'bg-white text-slate-900 shadow-xs border border-slate-200/60'
                : 'text-slate-500 hover:text-slate-800'
            }`}
          >
            <RotateCcw className="w-3.5 h-3.5 text-amber-600" />
            <span>2. Returns Process</span>
            {pendingCount > 0 && (
              <span className="text-[9px] font-bold px-1.5 py-0.2 rounded-full bg-amber-500 text-white leading-none">
                {pendingCount}
              </span>
            )}
          </button>
        </div>
      </div>

      {/* Render selected process screen */}
      <div className="flex-1">
        {activeProcess === 'dispatch' ? (
          <DispatchScreen
            onAddParcel={onAddParcel}
            onNavigateToParcels={onNavigateToParcels}
          />
        ) : (
          <ReturnsScreen
            returns={returns}
            onAddReturn={onAddReturn}
          />
        )}
      </div>
    </div>
  );
};
