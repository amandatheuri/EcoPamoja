import "package:flutter/material.dart";

class RewardContainer extends StatelessWidget {
  final String category;
  final bool unlockedCategory;

  const RewardContainer({
    super.key,
    required this.category,
    required this.unlockedCategory,
  });

  @override
  Widget build(BuildContext context) {
    // 'Unlocked' reward color
    final Color unlocked = Color(0xff35B89B);
    final Color rewardBorder = Color(0xff747474);

    return Opacity(
      opacity: unlockedCategory ? 1 : 0.5,
      child: Container(
        color: null,
        width: 132,
        height: 114,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: rewardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.star_outline_rounded),
            Text(category, style: Theme.of(context).textTheme.labelMedium),
            ?(unlockedCategory)
                ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: unlocked,
                    ),
                    child: Text(
                      "Unlocked",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                : null,
          ],
        ),
      ),
    );
  }
}
