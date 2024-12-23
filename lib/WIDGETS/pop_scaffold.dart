import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// create_modal.dart

class CreateModal extends StatelessWidget {
  const CreateModal({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Tapping within the modal content doesn't dismiss
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
                // Create Post Option
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            // Handle icon tap
                            Navigator.pushNamed(context, '/create-post');

                            print('Create post icon tapped');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0F3FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit_note_rounded,
                              color: Color(0xFF2486C2),
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/create-post');
                                  if (kDebugMode) {
                                    print('Create post text tapped');
                                  }
                                },
                                child: const Text(
                                  'Create a Town Square Post',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Create a post in a group you have joined',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Create Group Option
              ],
            ),
          );
        },
      ),
    );
  }
}
