import 'package:flutter/material.dart';

class CreateModal2 extends StatefulWidget {
  const CreateModal2({super.key});

  @override
  _CreateModal2State createState() => _CreateModal2State();
}

class _CreateModal2State extends State<CreateModal2> {
  // State for each circular tick box
  bool isNewestFirst = false;
  bool isOldestFirst = false;
  bool isAZ = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: DraggableScrollableSheet(
        initialChildSize: 0.4,
        maxChildSize: 0.4,
        minChildSize: 0.3,
        builder: (_, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                // "Filter" Text
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),

                // Newest First Option
                _buildFilterOption(
                  title: 'Newest First',
                  value: isNewestFirst,
                  onChanged: (value) {
                    setState(() {
                      isNewestFirst = value;
                      isOldestFirst = false; // Reset other options
                      isAZ = false;
                    });
                  },
                ),

                // Oldest First Option
                _buildFilterOption(
                  title: 'Oldest First',
                  value: isOldestFirst,
                  onChanged: (value) {
                    setState(() {
                      isOldestFirst = value;
                      isNewestFirst = false; // Reset other options
                      isAZ = false;
                    });
                  },
                ),

                // A-Z Option
                _buildFilterOption(
                  title: '(A-Z)',
                  value: isAZ,
                  onChanged: (value) {
                    setState(() {
                      isAZ = value;
                      isNewestFirst = false; // Reset other options
                      isOldestFirst = false;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget for a filter option
  Widget _buildFilterOption({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Aligns text and checkbox
          children: [
            // Filter Title
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.left, // Ensures text is left-aligned
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Circular Checkbox
            GestureDetector(
              onTap: () => onChanged(!value),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                  color: value ? Colors.blue : Colors.transparent,
                ),
                child: value
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
