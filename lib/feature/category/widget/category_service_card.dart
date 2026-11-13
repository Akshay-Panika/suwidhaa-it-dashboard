import 'package:flutter/material.dart';
import '../../../core/utils/app_color.dart';

// ═══════════════════════════════════════════════
//  MODELS
// ═══════════════════════════════════════════════
class ITService {
  final String title;
  final String description;
  final String price;
  final String duration;
  final IconData icon;
  final String status;
  const ITService(
      this.title,
      this.description,
      this.price,
      this.duration,
      this.icon,
      this.status,
      );
}

class ITCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<ITService> services;
  const ITCategory(this.name, this.icon, this.color, this.services);
}

// ═══════════════════════════════════════════════
//  DATA
// ═══════════════════════════════════════════════
const itCategories = <ITCategory>[
  ITCategory('Web Development', Icons.language_rounded, AppColor.primary, [
    ITService('Static Website', 'Basic info & portfolio sites',
        '15,000', '7 days', Icons.web_rounded, 'Active'),
    ITService('Dynamic Web App', 'Custom business web applications',
        '45,000', '30 days', Icons.code_rounded, 'Active'),
    ITService('E-Commerce Store', 'Online shopping platform',
        '65,000', '45 days', Icons.shopping_cart_rounded, 'Draft'),
  ]),
  ITCategory('Mobile App', Icons.phone_iphone_rounded,
      const Color(0xFF3B82F6), [
        ITService('Android App', 'Native Android applications',
            '35,000', '25 days', Icons.android_rounded, 'Active'),
        ITService('iOS App', 'Native iOS applications',
            '45,000', '30 days', Icons.apple_rounded, 'Active'),
        ITService('Cross-Platform App', 'Flutter / React Native',
            '55,000', '35 days', Icons.devices_rounded, 'Active'),
      ]),
  ITCategory('UI/UX Design', Icons.palette_rounded, const Color(0xFFEC4899), [
    ITService('Logo Design', 'Brand identity design',
        '5,000', '3 days', Icons.brush_rounded, 'Active'),
    ITService('UI Kit Design', 'Component libraries for app/web',
        '20,000', '10 days', Icons.design_services_rounded, 'Active'),
    ITService('Prototype Design', 'Interactive clickable prototypes',
        '12,000', '7 days', Icons.fingerprint_rounded, 'Active'),
  ]),
  ITCategory('Digital Marketing', Icons.campaign_rounded,
      const Color(0xFFF59E0B), [
        ITService('SEO Optimization', 'Search engine ranking improvement',
            '18,000', 'Monthly', Icons.search_rounded, 'Active'),
        ITService('Google Ads', 'PPC campaign management',
            '25,000', 'Monthly', Icons.ads_click_rounded, 'Active'),
        ITService('Social Media Marketing', 'Content + growth strategy',
            '15,000', 'Monthly', Icons.share_rounded, 'Active'),
      ]),
  ITCategory('Cloud Services', Icons.cloud_rounded, const Color(0xFF10B981), [
    ITService('Cloud Migration', 'Move infra to AWS/GCP/Azure',
        '50,000', '20 days', Icons.cloud_upload_rounded, 'Active'),
    ITService('Server Setup', 'VPS & dedicated server config',
        '12,000', '5 days', Icons.dns_rounded, 'Active'),
    ITService('Backup Solution', 'Automated cloud backup',
        '8,000', '4 days', Icons.backup_rounded, 'Active'),
  ]),
  ITCategory('DevOps', Icons.settings_suggest_rounded,
      const Color(0xFF8B5CF6), [
        ITService('CI/CD Pipeline', 'Automated build & deploy',
            '30,000', '15 days', Icons.rocket_launch_rounded, 'Active'),
        ITService('Docker Setup', 'Containerization of apps',
            '18,000', '10 days', Icons.view_in_ar_rounded, 'Active'),
        ITService('Kubernetes', 'K8s cluster management',
            '60,000', '25 days', Icons.hub_rounded, 'Draft'),
      ]),
  ITCategory('Cyber Security', Icons.security_rounded, const Color(0xFFEF4444),
      [
        ITService('Security Audit', 'Vulnerability assessment',
            '35,000', '10 days', Icons.fact_check_rounded, 'Active'),
        ITService('Penetration Testing', 'Ethical hacking test',
            '45,000', '15 days', Icons.bug_report_rounded, 'Active'),
        ITService('SSL & Firewall', 'SSL cert + WAF setup',
            '6,000', '2 days', Icons.lock_rounded, 'Active'),
      ]),
  ITCategory('Data Analytics', Icons.analytics_rounded,
      const Color(0xFF06B6D4), [
        ITService('Dashboard Setup', 'BI dashboards with Power BI / Tableau',
            '28,000', '14 days', Icons.bar_chart_rounded, 'Active'),
        ITService('Data Pipeline', 'ETL pipelines & warehouses',
            '55,000', '25 days', Icons.timeline_rounded, 'Draft'),
      ]),
  ITCategory('AI / ML Solutions', Icons.smart_toy_rounded,
      const Color(0xFFF97316), [
        ITService('Chatbot Integration', 'AI-powered customer chatbot',
            '25,000', '12 days', Icons.chat_rounded, 'Active'),
        ITService('ML Model', 'Custom prediction model',
            '80,000', '40 days', Icons.auto_graph_rounded, 'Draft'),
      ]),
  ITCategory('E-Commerce', Icons.shopping_bag_rounded,
      const Color(0xFF14B8A6), [
        ITService('Shopify Store', 'Ready-to-sell Shopify setup',
            '20,000', '10 days', Icons.shopping_cart_checkout_rounded, 'Active'),
        ITService('WooCommerce', 'WordPress e-commerce',
            '18,000', '12 days', Icons.storefront_rounded, 'Active'),
      ]),
  ITCategory('IT Support', Icons.support_agent_rounded,
      const Color(0xFF64748B), [
        ITService('AMC Contract', 'Annual maintenance contract',
            '30,000', 'Yearly', Icons.handshake_rounded, 'Active'),
        ITService('Remote Support', 'On-demand IT helpdesk',
            '5,000', 'Monthly', Icons.headset_mic_rounded, 'Active'),
      ]),
];

// ═══════════════════════════════════════════════
//  CategoryServiceCard
// ═══════════════════════════════════════════════
class CategoryServiceCard extends StatefulWidget {
  final int? categoryIndex;
  const CategoryServiceCard({super.key, this.categoryIndex});

  @override
  State<CategoryServiceCard> createState() => _CategoryServiceCardState();
}

class _CategoryServiceCardState extends State<CategoryServiceCard> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  bool _isGridView = false;

  // ── selection / form state ──
  ITService? _selectedService;
  bool _isAdding = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  ITCategory? get _category =>
      widget.categoryIndex == null ? null : itCategories[widget.categoryIndex!];

  Color get _accent => _category?.color ?? AppColor.primary;

  String get _title => _category?.name ?? 'All Services';

  List<ITService> get _services {
    final list = widget.categoryIndex == null
        ? itCategories.expand((c) => c.services).toList()
        : itCategories[widget.categoryIndex!].services;

    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list
        .where((s) =>
    s.title.toLowerCase().contains(q) ||
        s.description.toLowerCase().contains(q))
        .toList();
  }

  bool get _isWide => MediaQuery.sizeOf(context).width >= 1000;

  // ═══════════════════════════════════════════════
  //  HANDLERS
  // ═══════════════════════════════════════════════
  void _onServiceTap(ITService service) {
    setState(() {
      _selectedService = service;
      _isAdding = false;
    });
    if (!_isWide) _showFormSheet(service: service);
  }

  void _onAddTap() {
    setState(() {
      _selectedService = null;
      _isAdding = true;
    });
    if (!_isWide) _showFormSheet();
  }

  Future<void> _onDeleteTap(ITService service) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Service'),
        content: Text('Are you sure you want to delete "${service.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete',
                style: TextStyle(color: AppColor.red)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${service.title}" deleted (demo)')),
      );
    }
  }

  void _closePanel() {
    setState(() {
      _selectedService = null;
      _isAdding = false;
    });
  }

  void _showFormSheet({ITService? service}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _ServiceFormCard(
              key: ValueKey(service?.title ?? 'add'),
              accent: _accent,
              service: service,
              isAdding: service == null,
              onCancel: () => Navigator.of(sheetCtx).pop(),
              onSave: (_) {
                Navigator.of(sheetCtx).pop();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(service == null
                          ? 'Service added (demo)'
                          : 'Service updated (demo)'),
                      backgroundColor: AppColor.primary,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final services = _services;
    final showPanel = _isWide && (_selectedService != null || _isAdding);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── header ──
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _category?.icon ?? Icons.apps_rounded,
                          color: _accent,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${services.length} service${services.length == 1 ? '' : 's'} available',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _onAddTap,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── search + view toggle ──
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(fontSize: 13.5),
                  decoration: InputDecoration(
                    hintText: 'Search services by name or description…',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: Colors.grey.shade500,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      tooltip: 'Clear',
                      icon: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    filled: true,
                    fillColor: AppColor.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColor.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColor.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: _accent, width: 1.4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _toggleBtn(
                      icon: Icons.view_list_rounded,
                      tooltip: 'List view',
                      active: !_isGridView,
                      onTap: () => setState(() => _isGridView = false),
                    ),
                    const SizedBox(width: 2),
                    _toggleBtn(
                      icon: Icons.grid_view_rounded,
                      tooltip: 'Grid view',
                      active: _isGridView,
                      onTap: () => setState(() => _isGridView = true),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── results + right panel ──
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildResults(services)),
                if (showPanel)
                  SizedBox(
                    width: 360,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: _buildRightPanel(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  RIGHT PANEL
  // ═══════════════════════════════════════════════
  Widget _buildRightPanel() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: _ServiceFormCard(
          key: ValueKey(_isAdding ? 'add' : _selectedService?.title),
          accent: _accent,
          service: _isAdding ? null : _selectedService,
          isAdding: _isAdding,
          onCancel: _closePanel,
          onSave: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_isAdding
                    ? 'Service added (demo)'
                    : 'Service updated (demo)'),
                backgroundColor: AppColor.primary,
              ),
            );
            _closePanel();
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  RESULTS
  // ═══════════════════════════════════════════════
  Widget _buildResults(List<ITService> services) {
    if (services.isEmpty) return _emptyState();
    if (_isGridView) return _gridLayout(services);
    return _listLayout(services);
  }

  Widget _listLayout(List<ITService> services) {
    return ListView(
      children: services.map((s) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ServiceItem(
            service: s,
            accentColor: _accent,
            isList: true,
            isSelected: _selectedService?.title == s.title,
            onTap: () => _onServiceTap(s),
            onEdit: () => _onServiceTap(s),
            onDelete: () => _onDeleteTap(s),
          ),
        );
      }).toList(),
    );
  }

  Widget _gridLayout(List<ITService> services) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth < 650 ? 1 : c.maxWidth < 1100 ? 2 : 3;
        const gap = 16.0;
        final w = (c.maxWidth - gap * (cols - 1)) / cols;

        return SingleChildScrollView(
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: services.map((s) {
              return SizedBox(
                width: w,
                child: _ServiceItem(
                  service: s,
                  accentColor: _accent,
                  isList: false,
                  isSelected: _selectedService?.title == s.title,
                  onTap: () => _onServiceTap(s),
                  onEdit: () => _onServiceTap(s),
                  onDelete: () => _onDeleteTap(s),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No services match "$_searchQuery"'
                  : 'No services in this category yet',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleBtn({
    required IconData icon,
    required String tooltip,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color:
        active ? AppColor.primary.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 18,
              color: active ? AppColor.primary : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  _ServiceItem — single service card
// ═══════════════════════════════════════════════
class _ServiceItem extends StatelessWidget {
  final ITService service;
  final Color accentColor;
  final bool isList;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ServiceItem({
    required this.service,
    required this.accentColor,
    required this.isList,
    this.isSelected = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = service.status.toLowerCase() == 'active';
    final statusColor = isActive ? const Color(0xFF10B981) : AppColor.red;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? accentColor : AppColor.border,
              width: isSelected ? 1.8 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? accentColor.withOpacity(0.12)
                    : Colors.black.withOpacity(0.03),
                blurRadius: isSelected ? 14 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isList ? _list(statusColor) : _grid(statusColor),
        ),
      ),
    );
  }

  Widget _grid(Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _iconBox(),
            const Spacer(),
            _statusBadge(statusColor),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          service.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          service.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.5,
            color: Colors.grey.shade600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 14),
        Divider(color: AppColor.border, height: 1),
        const SizedBox(height: 12),
        Row(
          children: [
            _priceWidget(),
            const SizedBox(width: 10),
            _durationWidget(),
            const Spacer(),
            _actions(),
          ],
        ),
      ],
    );
  }

  Widget _list(Color statusColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _iconBox(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      service.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _statusBadge(statusColor),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                service.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _priceWidget(),
                  const SizedBox(width: 12),
                  _durationWidget(),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _actions(),
      ],
    );
  }

  Widget _iconBox() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(service.icon, color: accentColor, size: 22),
    );
  }

  Widget _statusBadge(Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            service.status,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.currency_rupee_rounded, size: 14, color: accentColor),
        Text(
          service.price,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
      ],
    );
  }

  Widget _durationWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule_rounded, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 3),
        Text(
          service.duration,
          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _actions() {
    return GestureDetector(
      onTap: () {}, // consume tap, don't bubble to parent
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconBtn(
            Icons.edit_outlined,
            AppColor.black.withOpacity(0.55),
            onEdit,
          ),
          const SizedBox(width: 4),
          _iconBtn(Icons.delete_outline_rounded, AppColor.red, onDelete),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  _ServiceFormCard — right panel / bottom sheet
// ═══════════════════════════════════════════════
class _ServiceFormCard extends StatefulWidget {
  final ITService? service;
  final Color accent;
  final bool isAdding;
  final VoidCallback onCancel;
  final void Function(Map<String, String>)? onSave;

  const _ServiceFormCard({
    super.key,
    required this.accent,
    required this.isAdding,
    required this.onCancel,
    this.service,
    this.onSave,
  });

  @override
  State<_ServiceFormCard> createState() => _ServiceFormCardState();
}

class _ServiceFormCardState extends State<_ServiceFormCard> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _durationCtrl;
  late String _status;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.service?.title ?? '');
    _descCtrl = TextEditingController(text: widget.service?.description ?? '');
    _priceCtrl = TextEditingController(text: widget.service?.price ?? '');
    _durationCtrl = TextEditingController(text: widget.service?.duration ?? '');
    _status = widget.service?.status ?? 'Active';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave?.call({
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'price': _priceCtrl.text.trim(),
      'duration': _durationCtrl.text.trim(),
      'status': _status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── header ──
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.service?.icon ?? Icons.add_circle_outline_rounded,
                color: widget.accent,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isAdding ? 'Add New Service' : 'Edit Service',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.isAdding
                        ? 'Create a new service'
                        : 'Update service details',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: widget.onCancel,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(color: AppColor.border, height: 1),
        const SizedBox(height: 16),

        // ── fields ──
        _fieldLabel('Service Title'),
        const SizedBox(height: 6),
        _textField(_titleCtrl, 'e.g. Static Website'),
        const SizedBox(height: 14),

        _fieldLabel('Description'),
        const SizedBox(height: 6),
        _textField(_descCtrl, 'Brief description', maxLines: 2),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Price (₹)'),
                  const SizedBox(height: 6),
                  _textField(_priceCtrl, 'e.g. 25,000'),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Duration'),
                  const SizedBox(height: 6),
                  _textField(_durationCtrl, 'e.g. 15 days'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        _fieldLabel('Status'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _status,
          decoration: _inputDecoration(),
          items: const [
            DropdownMenuItem(value: 'Active', child: Text('Active')),
            DropdownMenuItem(value: 'Draft', child: Text('Draft')),
          ],
          onChanged: (v) => setState(() => _status = v ?? _status),
        ),
        const SizedBox(height: 20),

        // ── actions ──
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: AppColor.border),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.isAdding ? 'Add Service' : 'Save Changes',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColor.black,
      ),
    );
  }

  Widget _textField(
      TextEditingController ctrl,
      String hint, {
        int maxLines = 1,
      }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: _inputDecoration(hint: hint),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12.5, color: Colors.grey.shade500),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      filled: true,
      fillColor: AppColor.bg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColor.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColor.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: widget.accent, width: 1.4),
      ),
    );
  }
}