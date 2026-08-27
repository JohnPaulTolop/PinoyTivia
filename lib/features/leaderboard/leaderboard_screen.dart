import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/leaderboard_entry.dart';
import '../../services/firestore_service.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
        ),
      ),
      body: Column(
        children: [
          Container(
            width:
                double.infinity,
            padding:
                const EdgeInsets.all(
              22,
            ),
            decoration:
                const BoxDecoration(
              color: AppColors
                  .primaryBlue,
              borderRadius:
                  BorderRadius.only(
                bottomLeft:
                    Radius.circular(
                  28,
                ),
                bottomRight:
                    Radius.circular(
                  28,
                ),
              ),
            ),
            child:
                const Column(
              children: [
                Icon(
                  Icons
                      .leaderboard_rounded,
                  size: 55,
                  color:
                      AppColors.yellow,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Top Trivia Players',
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize: 23,
                    fontWeight:
                        FontWeight
                            .w900,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Earn points and climb the rankings!',
                  style:
                      TextStyle(
                    color: Colors
                        .white70,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<
                List<
                    LeaderboardEntry>>(
              stream:
                  FirestoreService
                      .instance
                      .getLeaderboard(),
              builder:
                  (context, snapshot) {
                if (snapshot
                        .connectionState ==
                    ConnectionState
                        .waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (snapshot
                    .hasError) {
                  return const Center(
                    child: Padding(
                      padding:
                          EdgeInsets
                              .all(30),
                      child: Text(
                        'Unable to load the leaderboard.',
                        textAlign:
                            TextAlign
                                .center,
                      ),
                    ),
                  );
                }

                final entries =
                    snapshot.data ??
                        [];

                if (entries
                    .isEmpty) {
                  return const Center(
                    child: Text(
                      'No leaderboard entries yet.',
                    ),
                  );
                }

                return ListView
                    .separated(
                  padding:
                      const EdgeInsets
                          .all(20),
                  itemCount:
                      entries.length,
                  separatorBuilder:
                      (_, _) =>
                          const SizedBox(
                    height: 10,
                  ),
                  itemBuilder:
                      (context,
                          index) {
                    final entry =
                        entries[
                            index];

                    return _LeaderboardCard(
                      position:
                          index + 1,
                      entry:
                          entry,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardCard
    extends StatelessWidget {
  final int position;
  final LeaderboardEntry entry;

  const _LeaderboardCard({
    required this.position,
    required this.entry,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final currentUid =
        FirebaseAuth.instance
            .currentUser
            ?.uid;

    final isCurrentStudent =
        currentUid ==
            entry.uid;

    Color rankColor;

    if (position == 1) {
      rankColor =
          AppColors.gold;
    } else if (position ==
        2) {
      rankColor =
          const Color(
        0xFFA7A7A7,
      );
    } else if (position ==
        3) {
      rankColor =
          const Color(
        0xFFCD7F32,
      );
    } else {
      rankColor =
          AppColors.primaryBlue;
    }

    return Container(
      padding:
          const EdgeInsets.all(
        15,
      ),
      decoration:
          BoxDecoration(
        color: isCurrentStudent
            ? AppColors.lightBlue
            : Theme.of(context)
                .colorScheme
                .surface,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: isCurrentStudent
              ? AppColors
                  .primaryBlue
              : Theme.of(context)
                  .colorScheme
                  .outlineVariant,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: Center(
              child: position <= 3
                  ? Icon(
                      Icons
                          .emoji_events_rounded,
                      color:
                          rankColor,
                      size: 30,
                    )
                  : Text(
                      '#$position',
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          CircleAvatar(
            backgroundColor:
                AppColors.primaryBlue,
            foregroundColor:
                Colors.white,
            child: Text(
              _initial(
                entry.name,
              ),
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(
            width: 13,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  isCurrentStudent
                      ? '${entry.name} (You)'
                      : entry.name,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight
                            .w900,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  'Level ${entry.level} • ${entry.rankTitle}',
                  style:
                      const TextStyle(
                    color: AppColors
                        .textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .end,
            children: [
              Text(
                '${entry.totalPoints}',
                style:
                    const TextStyle(
                  color: AppColors
                      .primaryBlue,
                  fontSize: 17,
                  fontWeight:
                      FontWeight
                          .w900,
                ),
              ),
              const Text(
                'points',
                style:
                    TextStyle(
                  color: AppColors
                      .textSecondary,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _initial(
    String name,
  ) {
    final cleanedName =
        name.trim();

    if (cleanedName
        .isEmpty) {
      return 'S';
    }

    return cleanedName[0]
        .toUpperCase();
  }
}