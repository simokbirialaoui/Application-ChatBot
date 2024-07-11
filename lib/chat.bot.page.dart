import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// sk-proj-DLyAI0u5oFU40dgpWOS4T3BlbkFJfWI1IJTqeU33uu4LGPos

class ChatBotPage extends StatefulWidget {
  ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List messages = [
    {
      "message": "Hello",
      "type": "user",
    },
    {
      "message": "How can I help you",
      "type": "assistant",
    },
  ];

  TextEditingController queryController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Chat Bot",
          style: TextStyle(
            color: Theme.of(context).indicatorColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isUser = messages[index]['type'] == 'user';
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          trailing: isUser ? Icon(Icons.person) : null,
                          leading: !isUser ? Icon(Icons.support_agent) : null,
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: isUser ? 100 : 0,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      messages[index]['message'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    color: isUser
                                        ? Color.fromARGB(100, 0, 200, 0)
                                        : Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: isUser ? 0 : 100,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: queryController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.visibility),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String query = queryController.text;
                    var openAiLLMUri = Uri.https(
                      "api.openai.com",
                      "/v1/chat/completions",
                    );
                    Map<String, String> headers = {
                      "Content-Type": "application/json",
                      "Authorization":
                          "Bearer sk-proj-kack7rbpulGxemIwvhzBT3BlbkFJo5H3wfudQy9KSQGFW0KR",
                    };
                    var prompt = {
                      "model": "gpt-4-turbo",
                      "messages": [
                        {"role": "user", "content": query},
                      ],
                      "temperature": 0
                    };
                    http
                        .post(
                      openAiLLMUri,
                      headers: headers,
                      body: json.encode(prompt),
                    )
                        .then(
                      (resp) {
                        var responseBody = resp.body;
                        print(responseBody);
                        var llmResponse = json.decode(responseBody);
                        String responseContent =
                            llmResponse['choices'][0]['message']['content'];
                        setState(
                          () {
                            messages.add(
                              {
                                "message": query,
                                "type": "user",
                              },
                            );
                            messages.add(
                              {
                                "message": responseContent,
                                "type": "assistant",
                              },
                            );
                            scrollController.jumpTo(
                                scrollController.position.maxScrollExtent +
                                    200);
                          },
                        );
                      },
                      onError: (err) {
                        print("++++++++ ERROR +++++++++");
                        print(err);
                      },
                    );
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
