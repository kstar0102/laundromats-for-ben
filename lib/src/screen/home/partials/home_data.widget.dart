import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:logger/logger.dart';

class HomeDataWidget extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> questions;

  const HomeDataWidget({super.key, required this.questions});

  @override
  ConsumerState<HomeDataWidget> createState() => _HomeDataWidgetState();
}

class _HomeDataWidgetState extends ConsumerState<HomeDataWidget> {
  Map<int, int> userReactionMap =
      {}; // Stores the user's reaction for each question (1 for like, 0 for dislike, -1 for neutral)
  Map<int, int> likesCountMap = {}; // Stores likes count for each question
  Map<int, int> dislikesCountMap =
      {}; // Stores dislikes count for each question
  Set<int> expandedQuestions = {};
  Set<int> answerInputVisible = {}; // Tracks visible answer input fields
  Map<int, TextEditingController> answerControllers =
      {}; // Stores text controllers

  final logger = Logger();
  bool initialized = false;

  @override
  void initState() {
    super.initState();

    if (widget.questions.isNotEmpty) {
      initializeData();
    }
  }

  void initializeData() {
    for (var question in widget.questions) {
      int questionId = question["question_id"];
      likesCountMap[questionId] = question["likes_count"] ?? 0;
      dislikesCountMap[questionId] = question["dislikes_count"] ?? 0;
      userReactionMap[questionId] = -1; // Default to neutral (-1)
    }
    initialized = true; // Mark initialization as done
    // logger.i("Questions initialized: ${widget.questions}");
  }

  @override
  void didUpdateWidget(HomeDataWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.questions != oldWidget.questions) {
      initializeData();
    }
  }

  Future<void> submitAnswer(int questionId, int userID) async {
    String answerText = answerControllers[questionId]?.text.trim() ?? "";

    if (answerText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Answer cannot be empty!"),
            backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final authService = AuthService();
      final response = await authService.submitAnswer(
        questionId: questionId,
        userId: userID, // Replace with actual logged-in user ID
        answer: answerText,
      );

      if (response["created"] == true) {
        setState(() {
          widget.questions
              .firstWhere((q) => q["question_id"] == questionId)["answers"]
              .add({
            "answer_id": response["answer_id"],
            "answer": answerText,
            "user_id": 12, // Replace with actual user ID
            "user_name": "Current User", // Replace with logged-in user's name
            "created_at": DateTime.now().toIso8601String(),
          });
          answerControllers[questionId]?.clear();
          answerInputVisible.remove(questionId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Answer submitted successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response["message"] ?? "Failed to submit answer!")),
        );
      }
    } catch (e) {
      print("Error submitting answer: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Unable to submit answer.")),
      );
    }
  }

  void toggleAnswerInput(int questionId) {
    setState(() {
      if (answerInputVisible.contains(questionId)) {
        answerInputVisible.remove(questionId);
      } else {
        answerInputVisible.add(questionId);
        answerControllers[questionId] ??= TextEditingController();
      }
    });
  }

  void toggleAnswers(int questionId) {
    setState(() {
      if (expandedQuestions.contains(questionId)) {
        expandedQuestions.remove(questionId); // Collapse if already expanded
      } else {
        expandedQuestions.add(questionId); // Expand otherwise
      }
    });
  }

  Future<void> handleLikeDislike(int questionId, int type, int userId) async {
    try {
      final authserver = AuthService();
      final result = await authserver.createOrUpdateLikeDislike(
        userId: userId,
        questionId: questionId,
        type: type,
      );

      if (result['created'] == true || result['updated'] == true) {
        setState(() {
          int? previousLikedQuestionId;

          // Check if the user has previously liked another question
          for (var entry in userReactionMap.entries) {
            if (entry.value == 1) {
              // If the user has liked this question
              previousLikedQuestionId = entry.key;
              break;
            }
          }

          if (type == 1) {
            // User clicked "Like"
            if (userReactionMap[questionId] == 1) {
              // Undo the like
              likesCountMap[questionId] = (likesCountMap[questionId] ?? 0) - 1;
              userReactionMap[questionId] = -1;
            } else {
              // Unlike the previous liked question
              if (previousLikedQuestionId != null &&
                  previousLikedQuestionId != questionId) {
                likesCountMap[previousLikedQuestionId] =
                    (likesCountMap[previousLikedQuestionId] ?? 0) - 1;
                userReactionMap[previousLikedQuestionId] = -1;
              }

              // Like the new question
              likesCountMap[questionId] = (likesCountMap[questionId] ?? 0) + 1;

              // If the user had disliked it before, remove the dislike
              if (userReactionMap[questionId] == 0) {
                dislikesCountMap[questionId] =
                    (dislikesCountMap[questionId] ?? 0) - 1;
              }
              userReactionMap[questionId] = 1;
            }
          } else if (type == 0) {
            // User clicked "Dislike"
            if (userReactionMap[questionId] == 0) {
              // Undo the dislike
              dislikesCountMap[questionId] =
                  (dislikesCountMap[questionId] ?? 0) - 1;
              userReactionMap[questionId] = -1;
            } else {
              // Dislike the question
              dislikesCountMap[questionId] =
                  (dislikesCountMap[questionId] ?? 0) + 1;

              // Remove the like if it exists
              if (userReactionMap[questionId] == 1) {
                likesCountMap[questionId] =
                    (likesCountMap[questionId] ?? 0) - 1;
              }
              userReactionMap[questionId] = 0;
            }
          }
        });
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to update like/dislike'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Unable to update like/dislike.'),
          backgroundColor: Colors.red,
        ),
      );
      logger.i("Error updating like/dislike: $e");
    }
  }

  String getTimeAgo(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      return "Unknown Date";
    }

    try {
      DateTime createdDate = DateTime.parse(createdAt);
      DateTime today = DateTime.now();
      Duration difference = today.difference(createdDate);

      if (difference.inDays == 0) {
        return "Today";
      } else if (difference.inDays == 1) {
        return "Yesterday";
      } else {
        return "${difference.inDays} days ago";
      }
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.questions.map((question) {
        final aiAnswer = (question["answers"] ?? []).firstWhere(
            (answer) => answer["isWho"] == "AI",
            orElse: () => null);
        return Container(
          margin: EdgeInsets.only(bottom: vMin(context, 5)),
          decoration: BoxDecoration(
            color: kColorWhite,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: kColorQuestionBorder, width: 1),
          ),
          child: Card(
            elevation: 0,
            color: kColorWhite,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Category & Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        question["category"] ?? "Unknown Category",
                        style: const TextStyle(
                          fontFamily: 'Onset-Regular',
                          fontSize: 14,
                          color: kColorPrimary,
                        ),
                      ),
                      Text(
                        getTimeAgo(question["created_at"]),
                        style: const TextStyle(
                          fontFamily: 'Onset-Regular',
                          fontSize: 12,
                          color: kColorPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: vMin(context, 2)),

                  // User Name
                  Row(
                    children: [
                      Image.asset('assets/images/icons/user.png'),
                      SizedBox(width: vMin(context, 2)),
                      Text(
                        question["user"]?["user_name"] ?? "Anonymous",
                        style: const TextStyle(
                          color: kColorSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: vMin(context, 3)),

                  // Question Content
                  Text(
                    question["question"] ?? "No question provided.",
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Onset-Normal',
                      fontWeight: FontWeight.bold,
                      color: kColorSecondary,
                    ),
                  ),
                  SizedBox(height: vMin(context, 1)),

                  // Tags
                  Wrap(
                    spacing: 8,
                    children: (question["tags"] != null &&
                            question["tags"] is String)
                        ? question["tags"]
                            .toString()
                            .split(',') // Split the string into a list of tags
                            .map<Widget>((tag) => OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Image.asset(
                                      "assets/images/icons/solar-linear.png"), // Replace with your icon
                                  label: Text(
                                    tag.trim(), // Trim whitespace around the tag
                                    style: const TextStyle(
                                      fontFamily: 'Onset-Regular',
                                      color: kColorSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side:
                                        const BorderSide(color: kColorPrimary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 3),
                                    minimumSize: const Size(0, 24),
                                  ),
                                ))
                            .toList()
                        : [], // Default empty list if tags is null or not a String
                  ),
                  SizedBox(height: vMin(context, 2)),
                  if (aiAnswer != null) ...[
                    Container(
                      padding: EdgeInsets.all(vMin(context, 2)),
                      decoration: BoxDecoration(
                        border: Border.all(color: kColorPrimary, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/icons/gpt.png"),
                              SizedBox(width: vMin(context, 2)),
                              const Text(
                                "LaundromatAI says",
                                style: TextStyle(
                                  fontFamily: 'Onset-Regular',
                                  color: kColorSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: vMin(context, 2)),
                          Text(
                            aiAnswer["answer"] ?? "No response available.",
                            style: const TextStyle(
                              fontFamily: 'Onset-Regular',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: kColorSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: vMin(context, 2)),
                  ],

                  // Answer Input Field (Only Visible When Chat Icon is Clicked)
                  if (answerInputVisible.contains(question["question_id"])) ...[
                    SizedBox(height: vMin(context, 2)),

                    // Answer Input Field with Green Border on Focus
                    Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {}); // Redraw when focus changes
                      },
                      child: TextField(
                        controller: answerControllers[question["question_id"]],
                        decoration: InputDecoration(
                          hintText: "Write your answer...",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: kColorPrimary, width: 1), // Green Border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                          ),
                          contentPadding: EdgeInsets.all(vMin(context, 2)),
                        ),
                        maxLines: 3,
                      ),
                    ),

                    SizedBox(height: vMin(context, 2)),

                    // Submit Answer Button (Matches "See All Answers")
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () => submitAnswer(question["question_id"],
                            question['user']['user_id']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kColorPrimary,
                          padding: EdgeInsets.symmetric(
                              horizontal: vMin(context, 5),
                              vertical: vMin(context, 1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                7), // Custom Border Radius
                          ),
                          minimumSize: Size(0, vMin(context, 7)),
                        ),
                        child: const Text(
                          "Submit Answer",
                          style: TextStyle(
                            color: kColorWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],

                  // **Display Answers If Expanded**
                  if (expandedQuestions.contains(question["question_id"])) ...[
                    // Display User Answers
                    Column(
                      children: (question["answers"] as List<dynamic>?)
                              ?.where((answer) =>
                                  answer["isWho"] != "AI") // Exclude AI
                              .map(
                                (answer) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.all(vMin(context, 2)),
                                  decoration: BoxDecoration(
                                    color: kColorWhite,
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: kColorQuestionBorder, width: 1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                              "assets/images/icons/user.png"),
                                          SizedBox(width: vMin(context, 2)),
                                          Text(
                                            answer["user_name"]!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: kColorSecondary,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            getTimeAgo(answer["created_at"]),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: kColorPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: vMin(context, 2)),

                                      // User Answer Content
                                      Text(
                                        answer["answer"] ??
                                            "No answer provided.",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: kColorSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList() ??
                          [],
                    ),
                  ],

                  // Footer (Comments, Likes, Dislikes)
                  Row(
                    children: [
                      InkWell(
                        onTap: () => toggleAnswerInput(question["question_id"]),
                        child:
                            Image.asset("assets/images/icons/chat-message.png"),
                      ),
                      SizedBox(height: vMin(context, 2)),
                      SizedBox(width: vMin(context, 1)),
                      Text(
                        (question["answers"]?.length ?? 0).toString(),
                        style: const TextStyle(
                          fontFamily: 'Onset-Regular',
                          fontSize: 12,
                          color: kColorSecondary,
                        ),
                      ),
                      SizedBox(width: vMin(context, 4)),
                      InkWell(
                        onTap: () => handleLikeDislike(question['question_id'],
                            1, question['user']['user_id']),
                        child: Image.asset(
                          "assets/images/icons/like.png",
                          color: userReactionMap[question['question_id']] == 1
                              ? Colors.green // Highlighted color for like
                              : Colors.grey, // Default color
                        ),
                      ),
                      SizedBox(width: vMin(context, 1)),
                      Text(
                        likesCountMap[question['question_id']]?.toString() ??
                            "0",
                        style: const TextStyle(
                          fontFamily: 'Onset-Regular',
                          fontSize: 12,
                          color: kColorSecondary,
                        ),
                      ),
                      SizedBox(width: vMin(context, 4)),

                      // Dislike Button
                      InkWell(
                        onTap: () => handleLikeDislike(question['question_id'],
                            0, question['user']['user_id']),
                        child: Image.asset(
                          "assets/images/icons/dislike.png",
                          color: userReactionMap[question['question_id']] == 0
                              ? Colors.red // Highlighted color for dislike
                              : Colors.grey, // Default color
                        ),
                      ),
                      SizedBox(width: vMin(context, 1)),
                      Text(
                        dislikesCountMap[question['question_id']]?.toString() ??
                            "0",
                        style: const TextStyle(
                          fontFamily: 'Onset-Regular',
                          fontSize: 12,
                          color: kColorSecondary,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: vMin(context, 40),
                        child: ButtonWidget(
                          btnType: ButtonWidgetType.seeAllAnsersBtn,
                          borderColor: kColorPrimary,
                          textColor: kColorWhite,
                          fullColor: kColorPrimary,
                          size: false,
                          icon: true,
                          onPressed: () =>
                              toggleAnswers(question["question_id"]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
