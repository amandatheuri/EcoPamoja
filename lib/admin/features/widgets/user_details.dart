import 'package:flutter/material.dart';

class UserDetailsRow extends StatelessWidget {
  final String detailTitle;
  final dynamic detailData;

  const UserDetailsRow({super.key, required this.detailTitle, this.detailData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          detailTitle,
          style: Theme.of(context).textTheme.bodySmall,
          softWrap: true,
        ),
        Text(
          detailData,
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(fontStyle: FontStyle.italic),
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }
}
