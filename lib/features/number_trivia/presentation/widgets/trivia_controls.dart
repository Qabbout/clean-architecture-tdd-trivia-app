import 'package:clean_arch_tdd_trivia_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputString;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onSubmitted: (_) {
            displatchConcrete();
          },
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            inputString = value;
          },
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: displatchConcrete,
                child: Text(
                  'Search',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: displatchRandom,
                child: Text(
                  'Get Random Trivia',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  void displatchConcrete() {
    controller.clear();
    if (inputString != '' && inputString != null) {
      BlocProvider.of<NumberTriviaBloc>(context)
          .add(GetTriviaForConcreteNumber(inputString));
      inputString = '';
    } else
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Please enter a number',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ));
  }

  void displatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
