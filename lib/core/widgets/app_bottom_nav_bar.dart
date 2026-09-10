import 'package:flutter/material.dart';

class BottomNavItem{
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final VoidCallback onTap;
  final bool isSpecialButton;

  BottomNavItem({required this.icon,
    required this.label,
    required this.onTap,
    this.activeIcon,
    this.isSpecialButton = false,});
}


class AppBottomNavBar  extends StatelessWidget{
  final int selectedIndex;
  final List<BottomNavItem> items;
  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.items,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding:  const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE8ECE9),
            width: 1.0,
          )
        )
      ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final bool isSelected = selectedIndex == index;

          if (item.isSpecialButton) {
            return _buildSpecialButton(item: item, isSelected: isSelected);
          }
          return _buildNavItem(item: item, isSelected: isSelected);
        },)
      ),
    );
  }

  Widget _buildNavItem({
    required BottomNavItem item,
    required bool isSelected,
  }) {
    const Color activeColor = Color(0xFF1E3A2B);
    const Color inactiveColor = Color(0xFF8C9A91);

    return InkWell(
      onTap: item.onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? (item.activeIcon ?? item.icon) : item.icon,
            size: 24,
            color: isSelected ? activeColor : inactiveColor,
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }

  /// special button add
  Widget _buildSpecialButton({
    required BottomNavItem item,
    required bool isSelected,
  }) {
    const Color activeColor = Color(0xFF1E3A2B);
    const Color inactiveColor = Color(0xFF8C9A91);

    return InkWell(
      onTap: item.onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2D5A42),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2D5A42).withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              item.icon,
              size: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }

}