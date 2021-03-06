import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'fact_message.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

class FlutterFactsChatBot extends StatefulWidget {
  FlutterFactsChatBot({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FlutterFactsChatBotState createState() => new _FlutterFactsChatBotState();
  }
  enum TtsState { playing }
class _FlutterFactsChatBotState extends State<FlutterFactsChatBot> {
    final List<Facts> messageList = <Facts>[];
    final TextEditingController _textController = new TextEditingController();
    FlutterTts flutterTts;
    stt.SpeechToText _speech;
    bool _isListening = false;
    TtsState ttsState = TtsState.playing;
    
        @override
        initState() {
          super.initState();
          initTts();
          _speech = stt.SpeechToText();
        }

        initTts() {
          flutterTts = FlutterTts();

        flutterTts.setStartHandler(() {
          setState(() {
            //print("playing");
            ttsState = TtsState.playing;
          });
        });
        }

  Widget _queryInputWidget(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.only(left:10.0, right: 8,top:10),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
               keyboardType: TextInputType.multiline,
               //minLines: 1
               //maxLength: 200,
               maxLines: 10,
                controller: _textController,
                onSubmitted: _submitQuery,
                decoration: InputDecoration.collapsed(hintText: "Add your working details"),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                  icon: Icon(Icons.send, color: Colors.blue[400],),
                  onPressed: () => (_textController.text.isNotEmpty)?_submitQuery(_textController.text) : null ),
            ),
             Container(
              
              child: AvatarGlow(
                
              animate: _isListening,
              glowColor: Theme.of(context).primaryColor,
              endRadius: 25.0,
              duration: const Duration(milliseconds:2000),
                repeatPauseDuration: const
                Duration(milliseconds: 100),
                repeat: true,
                  child: FloatingActionButton(
                     onPressed: () => (_textController.text.isNotEmpty)? () =>
                      _submitQuery(_textController.text) :_listen() ,
                                      //  _listen(),
                    child: Icon(_isListening ? Icons.mic :Icons.mic_none),
                    ),
                ),
            ),       
           ],
        ),
      ),
    );
  }

        void agentResponse(query) async {
          _textController.clear();
          AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/newagent-hw9t-e08fd778a12f.json").build();
          Dialogflow dialogFlow = Dialogflow(authGoogle: authGoogle, language: Language.english);
          AIResponse response = await dialogFlow.detectIntent(query);
          Facts message = Facts(
            text: response.getMessage() ??
                CardDialogflow(response.getListMessage()[0]).title,   
            name: "Flutter",
            type: false,
          );
          setState(() {
            messageList.insert(0, message);
              flutterTts.speak(response.getMessage().toString());
          });
        }
      void _listen() async {
        if (!_isListening) {
          bool available = await _speech.initialize(
            onStatus: (val) => print('onStatus: $val'),
            onError: (val) => print('onError: $val'),
          );
        if (available) {
          setState(() => _isListening = true);
            _speech.listen(
                onResult: (val) => setState(() {
                  _textController.text = val.recognizedWords;
                 
                }),
              );
            }
          } else {
              setState(() => _isListening = false);
                _speech.stop();
                  }
        }

            DateFormat dateFormat = DateFormat("yyyy/MM/dd   HH:mm:a");
            void _submitQuery(String text) {
              _textController.clear();

              Facts message = new Facts(
                text: text,
                name: "User",
                type: true,
                date:dateFormat.format(DateTime.now()).toString(),
             );
             setState(() {
              messageList.insert(0, message);
              });
               agentResponse(text);
            }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Attune TimeCard", style: TextStyle(color: Colors.blue[400]),),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(children: <Widget>[
         _queryInputWidget(context),
        Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: false, //To keep the latest messages at the top
              itemBuilder: (_, int index) => messageList[index],
              itemCount: messageList.length,
            )),
       
      ]),
    );
  }
}