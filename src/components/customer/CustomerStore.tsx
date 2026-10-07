import React, { useState } from 'react';
import { Product } from '../../types';
import { Search, ShoppingBag, Star, MessageSquare, Check, Sparkles, Filter, X } from 'lucide-react';

interface CustomerStoreProps {
  products: Product[];
  onInquireProductInChat: (product: Product) => void;
}

export const CustomerStore: React.FC<CustomerStoreProps> = ({
  products,
  onInquireProductInChat,
}) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('All');
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);

  const categories = ['All', 'Electronics', 'Accessories', 'Home & Living', 'Apparel'];

  const filteredProducts = products.filter((p) => {
    const matchesCategory = selectedCategory === 'All' || p.category === selectedCategory;
    const matchesSearch =
      p.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.description.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCategory && matchesSearch;
  });

  return (
    <div className="flex flex-col gap-3.5 px-4 pt-3 pb-24 max-w-md mx-auto w-full animate-fade-in">
      {/* Header */}
      <div className="flex items-center justify-between pt-1">
        <div>
          <span className="text-[11px] font-bold text-emerald-600 uppercase tracking-wider">
            Logistics Hub Store
          </span>
          <h1 className="text-xl font-bold tracking-tight text-[#0F172A]">
            Available Products
          </h1>
          <p className="text-xs text-slate-500 font-medium">
            In-stock items ready for immediate dispatch
          </p>
        </div>
        <div className="w-10 h-10 rounded-2xl bg-emerald-50 border border-emerald-200 flex items-center justify-center text-emerald-600">
          <ShoppingBag className="w-5 h-5" />
        </div>
      </div>

      {/* Search Input */}
      <div className="relative">
        <Search className="absolute left-3.5 top-2.5 w-4 h-4 text-slate-400" />
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          placeholder="Search products, earbuds, keyboards..."
          className="w-full pl-10 pr-4 py-2 bg-white border border-slate-200 rounded-xl text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-500"
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

      {/* Categories Filter Pills */}
      <div className="flex items-center gap-1.5 overflow-x-auto no-scrollbar py-0.5">
        {categories.map((cat) => (
          <button
            key={cat}
            onClick={() => setSelectedCategory(cat)}
            className={`px-3 py-1.5 rounded-xl text-xs font-semibold whitespace-nowrap transition-colors shrink-0 ${
              selectedCategory === cat
                ? 'bg-[#0F172A] text-white shadow-xs'
                : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50'
            }`}
          >
            {cat}
          </button>
        ))}
      </div>

      {/* Products Grid */}
      <div className="grid grid-cols-2 gap-3">
        {filteredProducts.map((prod) => (
          <div
            key={prod.id}
            onClick={() => setSelectedProduct(prod)}
            className="bg-white rounded-2xl border border-slate-200 overflow-hidden shadow-2xs hover:border-emerald-300 transition-all flex flex-col cursor-pointer group"
          >
            {/* Product Image */}
            <div className="relative h-32 bg-slate-100 overflow-hidden">
              <img
                src={prod.image}
                alt={prod.name}
                className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
              />
              <div className="absolute top-2 right-2 bg-black/60 backdrop-blur-xs text-white text-[10px] font-bold px-2 py-0.5 rounded-full flex items-center gap-1">
                <Star className="w-3 h-3 text-amber-400 fill-amber-400" />
                <span>{prod.rating}</span>
              </div>
              <div className="absolute bottom-2 left-2 bg-emerald-500 text-white text-[9px] font-bold px-2 py-0.5 rounded-md shadow-xs">
                {prod.stock} in stock
              </div>
            </div>

            {/* Product Details */}
            <div className="p-3 flex-1 flex flex-col justify-between">
              <div>
                <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block mb-0.5">
                  {prod.category}
                </span>
                <h3 className="text-xs font-bold text-[#0F172A] line-clamp-2 leading-snug">
                  {prod.name}
                </h3>
              </div>

              <div className="mt-2.5 pt-2 border-t border-slate-100 flex items-center justify-between">
                <div>
                  <span className="text-xs font-extrabold text-[#0F172A] block leading-none">
                    {prod.price}
                  </span>
                  <div className="flex gap-1 mt-1">
                    {prod.platforms.map((p) => (
                      <span
                        key={p}
                        className={`text-[8px] font-bold px-1 rounded ${
                          p === 'Shopee'
                            ? 'text-[#EE4D2D] bg-[#FFECE7]'
                            : p === 'Lazada'
                            ? 'text-[#0F146D] bg-[#E8EBFF]'
                            : 'text-black bg-slate-100'
                        }`}
                      >
                        {p.split(' ')[0]}
                      </span>
                    ))}
                  </div>
                </div>

                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    onInquireProductInChat(prod);
                  }}
                  className="p-2 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 rounded-xl transition-colors"
                  title="Inquire in Chat"
                >
                  <MessageSquare className="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Product Detail Modal */}
      {selectedProduct && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-fade-in">
          <div className="bg-white rounded-3xl max-w-sm w-full overflow-hidden shadow-2xl border border-slate-100">
            <div className="relative h-48 bg-slate-100">
              <img
                src={selectedProduct.image}
                alt={selectedProduct.name}
                className="w-full h-full object-cover"
              />
              <button
                onClick={() => setSelectedProduct(null)}
                className="absolute top-3 right-3 p-1.5 rounded-full bg-black/50 text-white hover:bg-black/70"
              >
                <X className="w-4 h-4" />
              </button>
              <div className="absolute bottom-3 left-3 bg-black/70 backdrop-blur-xs text-white text-[11px] font-bold px-2.5 py-1 rounded-lg">
                Available at MNL-HUB-04
              </div>
            </div>

            <div className="p-4 space-y-3">
              <div>
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-slate-400 uppercase">
                    {selectedProduct.category}
                  </span>
                  <span className="text-xs font-bold text-amber-500 flex items-center gap-1">
                    <Star className="w-3.5 h-3.5 fill-amber-400" />
                    {selectedProduct.rating} ({selectedProduct.reviewsCount} reviews)
                  </span>
                </div>
                <h3 className="text-base font-bold text-[#0F172A] mt-1">
                  {selectedProduct.name}
                </h3>
                <div className="text-lg font-extrabold text-[#0F172A] mt-1">
                  {selectedProduct.price}
                </div>
              </div>

              <p className="text-xs text-slate-600 leading-relaxed">
                {selectedProduct.description}
              </p>

              <div className="bg-slate-50 p-2.5 rounded-xl border border-slate-100 text-xs flex justify-between items-center">
                <span className="text-slate-500">Warehouse Inventory:</span>
                <span className="font-bold text-emerald-700">{selectedProduct.stock} units available</span>
              </div>

              <button
                onClick={() => {
                  const prod = selectedProduct;
                  setSelectedProduct(null);
                  onInquireProductInChat(prod);
                }}
                className="w-full py-3 bg-[#0F172A] hover:bg-slate-800 text-white font-bold text-xs rounded-xl flex items-center justify-center gap-2 shadow-xs"
              >
                <MessageSquare className="w-4 h-4" />
                <span>Chat with Admin to Order</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
