import 'package:flutter/material.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/home/home.screen.dart';
import 'package:laundromats/src/screen/search/search.screen.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:logger/logger.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laundromats/src/translate/en.dart';

class AnswerPage extends StatefulWidget {
  final Map<String, dynamic> question;
  final String frompage;

  const AnswerPage({super.key, required this.question, required this.frompage});

  @override
  AnswerPageState createState() => AnswerPageState();
}

class AnswerPageState extends State<AnswerPage> {
  List<dynamic> answers = [];
  final TextEditingController _answerController = TextEditingController();
  final logger = Logger();
  String? myId;
  int? userid;

  @override
  void initState() {
    super.initState();
    _getUserID();
  }

  Future<void> _getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myId = prefs.getString('userId');

    if (myId != null) {
      userid = int.tryParse(myId!); // Convert to integer safely
    }

    logger.i("User ID: $myId");

    // ✅ Fetch Answers AFTER user ID is set
    if (widget.question["answers"] != null) {
      List<dynamic> rawAnswers = widget.question["answers"];

      setState(() {
        answers = rawAnswers
            .where((a) => a["isWho"] != "AI") // Exclude AI answers
            .toList();
      });

      logger.i("Filtered Answers: $answers");
    }
  }

  String getTimeAgo(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      return "Unknown Date";
    }
    try {
      DateTime createdDate = DateTime.parse(createdAt);
      DateTime now = DateTime.now();
      Duration difference = now.difference(createdDate);

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

  Future<void> submitAnswer(int questionId, String userID) async {
    String answerText = _answerController.text.trim();
    logger.i(GlobalVariable.userName);

    // Early return if answer is empty
    if (answerText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Answer cannot be empty!"),
            backgroundColor: Colors.red),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing dialog when tapping outside
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(), // You can use any loading widget
        );
      },
    );

    try {
      final authService = AuthService();
      final response = await authService.submitAnswer(
        questionId: questionId,
        userId: int.parse(userID),
        answer: answerText,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      if (response["created"] == true) {
        // Make sure the state is updated with a new list
        setState(() {
          // Create a new list and add the answer
          widget.question["answers"] = List.from(widget.question["answers"])
            ..add({
              "answer_id": response["answer_id"],
              "answer": answerText,
              "user_id": userID,
              "answer_user_name": GlobalVariable.userName,
              "answer_user_image": GlobalVariable.userImageUrl,
              "created_at": DateTime.now().toIso8601String(),
            });
          answers.insert(
            0, // Insert at the beginning of the list
            {
              "answer_id": response["answer_id"],
              "answer": answerText,
              "user_id": userID,
              "answer_user_name": GlobalVariable.userName,
              "answer_user_image": GlobalVariable.userImageUrl,
              "created_at": DateTime.now().toIso8601String(),
            },
          );
        });

        _answerController.clear();

        // Show success message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Answer submitted successfully!")),
        );
      } else {
        // Show failure message from backend response
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response["message"] ?? "Failed to submit answer!")),
        );
      }
    } catch (e) {
      logger.i("Error submitting answer: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Unable to submit answer.")),
      );
    }
  }

  void editAnswer(int index) {
    TextEditingController controller =
        TextEditingController(text: answers[index]["answer"]);
    int answerId = answers[index]["answer_id"]; // Extract answer ID for update

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Edit Answer",
            style: TextStyle(fontSize: 20, color: kColorPrimary),
          ),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Update your answer...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: kColorPrimary),
              ),
            ),
            TextButton(
              onPressed: () async {
                String updatedAnswer = controller.text.trim();

                if (updatedAnswer.isEmpty) {
                  // Show error if empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Answer cannot be empty!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                final auth = AuthService();

                try {
                  final response = await auth.updateAnswer(
                    answerId: answerId,
                    updatedAnswer: updatedAnswer,
                  );

                  // Close loading dialog
                  if (mounted) Navigator.pop(context);

                  if (response['message'] == "Answer updated successfully") {
                    setState(() {
                      answers[index]["answer"] = updatedAnswer;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Answer updated successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Close edit dialog
                    if (mounted) Navigator.pop(context);
                  } else {
                    throw Exception("Failed to update answer");
                  }
                } catch (e) {
                  // Close loading dialog
                  if (mounted) Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error updating answer: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                "Update",
                style: TextStyle(color: kColorPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _backCliecked() {
    if (widget.frompage == "Home") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(0.0), // Adjust the height as needed
        child: AppBar(
          backgroundColor: kColorWhite,
          elevation: 0, // Removes shadow for a flat UI
          automaticallyImplyLeading: false, // Hides back button if unnecessary
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: kColorPrimary),
                    onPressed: _backCliecked,
                  ),
                  SizedBox(
                    width: vw(context, 1),
                  ),
                  Image.asset(
                    'assets/images/icons/icon.png',
                  ),
                  SizedBox(width: vMin(context, 3)),
                  Text(
                    appName.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Onset-Regular',
                      fontWeight: FontWeight.bold,
                      color: kColorPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Question",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kColorPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.question["question"] ?? "No question provided.",
                    style: const TextStyle(
                      fontSize: 14,
                      color: kColorSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true, // Show newest at the bottom
              itemCount: answers.length,
              itemBuilder: (context, index) {
                var answer = answers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: vh(context, 1),
                          ),
                          ClipOval(
                            child: answer["answer_user_image"] == null ||
                                    answer["answer_user_image"].isEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            kColorPrimary, // Set the color of the border
                                        width: 1, // Set the width of the border
                                      ),
                                    ),
                                    child: const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.person_2_rounded,
                                        color: kColorPrimary,
                                        size: 24,
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    answer["answer_user_image"],
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                          "assets/images/icons/account-1.png", // ✅ Fallback if error occurs
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20, // Adjust height as needed
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center, // Ensures vertical alignment
                                children: [
                                  Expanded(
                                    child: Text(
                                      answer["answer_user_name"] ??
                                          "Unknown User",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            14, // Ensure consistent font size
                                      ),
                                    ),
                                  ),
                                  Text(
                                    getTimeAgo(answer["created_at"]),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (myId != null &&
                                      userid == answer['answer_user_id']) ...[
                                    SizedBox(
                                      height:
                                          15, // Ensure icon stays within the row height
                                      child: IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: kColorPrimary, size: 20),
                                        onPressed: () => editAnswer(index),
                                        padding: EdgeInsets
                                            .zero, // Prevents extra spacing
                                        constraints:
                                            const BoxConstraints(), // Removes default constraints
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // answer["answer_user_image"] == null ||
                            //         answer["answer_user_image"].isEmpty
                            //     ? SizedBox(
                            //         height: vh(context, 0),
                            //       )
                            //     : SizedBox(
                            //         height: vh(context, 1),
                            //       ),
                            Text(
                              answer["answer"] ?? "No answer provided.",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _answerController,
                    decoration: InputDecoration(
                      hintText: "Write your answer...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: kColorPrimary),
                  onPressed: () async {
                    await submitAnswer(
                      widget.question["question_id"],
                      myId!,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
