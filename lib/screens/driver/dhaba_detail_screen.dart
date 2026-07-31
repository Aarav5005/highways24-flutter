import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../models/dhaba_model.dart';
import '../../models/menu_item_model.dart';
import 'food_cart_screen.dart';

class DhabaDetailScreen extends StatefulWidget {
  final DhabaModel dhaba;

  const DhabaDetailScreen({super.key, required this.dhaba});

  @override
  State<DhabaDetailScreen> createState() => _DhabaDetailScreenState();
}

class _DhabaDetailScreenState extends State<DhabaDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isVegOnlyFilter = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: FoodCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final dhabaItems = appState.allMenuItems.where((m) => m.dhabaId == widget.dhaba.id || true).toList();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.dhaba.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.dhaba.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(color: AppTheme.primaryNavy),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.emeraldGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text('${widget.dhaba.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('${widget.dhaba.reviewCount} Reviews', style: const TextStyle(color: AppTheme.textSecondary)),
                      const Spacer(),
                      FilterChip(
                        label: const Text('Veg Only', style: TextStyle(fontSize: 12)),
                        selected: _isVegOnlyFilter,
                        selectedColor: AppTheme.emeraldGreenLight,
                        onSelected: (val) {
                          setState(() {
                            _isVegOnlyFilter = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.dhaba.location,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: widget.dhaba.amenities.map((a) {
                      return Chip(
                        label: Text(a, style: const TextStyle(fontSize: 11)),
                        backgroundColor: AppTheme.backgroundLight,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppTheme.accentGold,
                unselectedLabelColor: Colors.white70,
                indicatorColor: AppTheme.accentGold,
                tabs: FoodCategory.values.map((c) => Tab(text: c.label)).toList(),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: FoodCategory.values.map((category) {
            var items = dhabaItems.where((i) => i.category == category).toList();
            if (_isVegOnlyFilter) {
              items = items.where((i) => i.isVeg).toList();
            }

            if (items.isEmpty) {
              return const Center(
                child: Text('No items available in this category.', style: TextStyle(color: AppTheme.textSecondary)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (ctx, idx) {
                final item = items[idx];
                final cartIndex = appState.cart.indexWhere((c) => c.item.id == item.id);
                final qty = cartIndex >= 0 ? appState.cart[cartIndex].quantity : 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.isVeg ? AppTheme.emeraldGreen : AppTheme.sosRed,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.description,
                                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '₹${item.price.round()}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryNavy),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Add / Remove Cart Button
                        if (qty == 0) ...[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentGold,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            onPressed: () {
                              appState.addToCart(item);
                            },
                            child: const Text('ADD', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ] else ...[
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.accentGoldLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.accentGold),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 16, color: AppTheme.primaryDark),
                                  onPressed: () => appState.removeFromCart(item),
                                ),
                                Text(
                                  '$qty',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 16, color: AppTheme.primaryDark),
                                  onPressed: () => appState.addToCart(item),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: appState.cart.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryDark,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8)],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${appState.cart.fold(0, (sum, i) => sum + i.quantity)} Items in Cart',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        '₹${appState.cartTotalAmount.round()}',
                        style: const TextStyle(color: AppTheme.accentGold, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGold,
                      foregroundColor: AppTheme.primaryDark,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => FoodCartScreen(dhaba: widget.dhaba),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text('VIEW CART', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.primaryDark,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
