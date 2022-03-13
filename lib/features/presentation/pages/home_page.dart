import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc_advance/features/presentation/bloc/number_trivia_bloc.dart';

import '../../../injection_container.dart';

class HomePageStl extends StatelessWidget {
  const HomePageStl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _numberController = TextEditingController();

  void _onTriviaClicked() {
    context.read<NumberTriviaBloc>().add(GetTriviaForConcreteNumber(_numberController.text.toString()));
  }

  void _onRandomTriviaClicked() {
    context.read<NumberTriviaBloc>().add(GetTriviaForRandomNumber());
  }

  @override
  void dispose() {
    _numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Loaded) {
                  return Text((state).trivia.text);
                } else if (state is Error) {
                  return Text(state.message);
                } else if(state is Loading){
                  return const CupertinoActivityIndicator();
                }else{
                  return const Text('-');
                }
              },
            ),
            CupertinoTextField(
              controller: _numberController,
            ),
            Row(
              children: [
                CupertinoButton(
                    child: const Text('Find Trivia'),
                    onPressed: () => _onTriviaClicked()),
                CupertinoButton(
                    child: const Text('Random Trivia'),
                    onPressed: () => _onRandomTriviaClicked())
              ],
            )
          ],
        ),
      ),
    );
  }
}
