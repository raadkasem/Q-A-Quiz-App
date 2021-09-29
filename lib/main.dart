import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'app_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

AppBrain appBrain = AppBrain();

void main() {
  runApp(ExamApp());
}

class ExamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
            centerTitle: true,
            title: Text('اختبر معلوماتك'),
            backgroundColor: Colors.grey),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ExamPage(),
        ),
      ),
    );
  }
}

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  List<Widget> answerResult = [];
  int rightAnswers = 0;

  void checkAnswer(bool whatuserpicked) {
    bool correctanswer = appBrain.getQuestionAnswer();
    setState(() {
      if (whatuserpicked == correctanswer) {
        rightAnswers++;
        answerResult.add(Row(
          children: <Widget>[
            Icon(
              Icons.thumb_up,
              color: Colors.green,
            ),
            SizedBox(width: 12,)
          ],
        ),);
      } else {
        answerResult.add(Row(
          children: <Widget>[
            Icon(
              Icons.thumb_down,
              color: Colors.red,
            ),
            SizedBox(width: 12,)
          ],
        ));
      }

      if (appBrain.isFinished() == true) {
        Alert(
          context: context,
          title: "انتهاء الاختبار",
          desc: "لقد أجبت على $rightAnswers أسئلة صحيحة من أصل 7 ",
          buttons: [
            DialogButton(
              child: Text(
                "ابدأ من جديد",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
        appBrain.reset();
        rightAnswers = 0;
        answerResult = [];
      } else {
        appBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 35,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                )
              ]),
          child: Row(
            children: answerResult,
          ),
        ),
        Expanded(
            child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(10,15),
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.7),
                    )
                  ]),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(appBrain.getQuestionImage())),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[400] ,
                  ),
              child: Text(
                appBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        )),

        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Row(
                  children: [
                    Icon(Icons.thumb_down, color:Colors.white),
                    Text(
                      ' خطـأ ',
                      style: TextStyle(fontSize: 22.0, color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  checkAnswer(false);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
              ),
              SizedBox(
                width: 50,
              ),

  
              ElevatedButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.thumb_up, color: Colors.white,),
                    Text(
                      ' صـح ',
                      style: TextStyle(fontSize: 22.0, color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  checkAnswer(true);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
              ),
            ],
          ),
        ),


        Container(
          alignment: Alignment.bottomCenter,
          child: MaterialButton(
            color: Colors.indigo[50],
            onPressed: () {
              launch(
                  'mailto:raadkasem1@gmail.com?subject=Flutter App Development &body=Hello Mr.Raad');
            },
            child: Text(
              'برمجة رعد قاسم',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
