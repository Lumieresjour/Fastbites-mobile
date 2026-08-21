import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final bool enabled;
  final String? hintText;
  final Function(String?)? onCategoryChanged;
  final String? selectedCategory;

  const SearchField({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.controller,
    this.enabled = true,
    this.hintText = 'Cari makanan...',
    this.onCategoryChanged,
    this.selectedCategory,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;
  String? _selectedCategory;
  final GlobalKey _categoryButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showCategoryMenu() {
    final RenderBox renderBox =
        _categoryButtonKey.currentContext?.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromLTWH(
        renderBox.localToGlobal(Offset.zero).dx,
        renderBox.localToGlobal(Offset.zero).dy + renderBox.size.height,
        renderBox.size.width,
        renderBox.size.height,
      ),
      Offset.zero & MediaQuery.of(context).size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.all_inclusive,
                color: _selectedCategory == null
                    ? const Color(0xFFFF5962)
                    : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Semua Kategori',
                style: TextStyle(
                  fontWeight: _selectedCategory == null
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: _selectedCategory == null
                      ? const Color(0xFFFF5962)
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'makanan',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.restaurant,
                color: _selectedCategory == 'makanan'
                    ? const Color(0xFFFF5962)
                    : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Makanan',
                style: TextStyle(
                  fontWeight: _selectedCategory == 'makanan'
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: _selectedCategory == 'makanan'
                      ? const Color(0xFFFF5962)
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'minuman',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_drink,
                color: _selectedCategory == 'minuman'
                    ? const Color(0xFFFF5962)
                    : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Minuman',
                style: TextStyle(
                  fontWeight: _selectedCategory == 'minuman'
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: _selectedCategory == 'minuman'
                      ? const Color(0xFFFF5962)
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null || value == null) {
        setState(() => _selectedCategory = value);
        widget.onCategoryChanged?.call(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: _isFocused ? 15 : 8,
                  offset: const Offset(0, 2),
                  spreadRadius: _isFocused ? 1 : 0,
                ),
                if (_isFocused)
                  BoxShadow(
                    color: const Color(0xFFFF5962).withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: TextField(
              controller: widget.controller,
              enabled: widget.enabled,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.search_rounded,
                    color: _isFocused
                        ? const Color(0xFFFF5962)
                        : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                    size: 22,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.controller?.text.isNotEmpty == true)
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            size: 20,
                          ),
                          onPressed: () {
                            widget.controller?.clear();
                            widget.onChanged?.call('');
                          },
                        ),
                      ),
                    GestureDetector(
                      key: _categoryButtonKey,
                      onTap: _showCategoryMenu,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.tune_rounded,
                          color: _selectedCategory != null
                              ? const Color(0xFFFF5962)
                              : (isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600]),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF5962),
                    width: 2,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
              ),
              onTap: () {
                setState(() {
                  _isFocused = true;
                });
                _animationController.forward();
                widget.onTap?.call();
              },
              onTapOutside: (event) {
                setState(() {
                  _isFocused = false;
                });
                _animationController.reverse();
              },
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
            ),
          ),
        );
      },
    );
  }
}
