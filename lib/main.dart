import 'package:flutter/material.dart';
import 'package:flutter_reflection_test/services/api.service.dart';
import 'annotations/DependecyInjection.dart';
import 'annotations/annotations.dart';

@Injectable(name: 'ServiceA', deps: [ServiceB])
class ServiceA {
  late ServiceB serviceB;

  String serviceCall() {
    return "HelloA";
  }

  int getCount(int i) {
    return i;
  }
}

@Injectable(name: 'ServiceB')
class ServiceB {
  String serviceCall() {
    return "HelloB";
  }
}

@Injectable(name: 'ServiceC')
class ServiceC {
  String serviceCall() {
    return "HelloC";
  }
}

@WidgetReflector()
class MyWidget {
  late ServiceA serviceA; // Auto inject

  MyWidget() {}

  void onInit(ServiceA serviceA) {
    this.serviceA = serviceA;
  }

  String getGreetings() {
    return serviceA.serviceCall();
  }
}


void main() {
  DependencyInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var service = getDI<ServiceA>();
  var apiService = getDI<ApiServiceIF>(byName: 'prod-apiservice');

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    if (apiService != null) {
      apiService?.handle();
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${service?.getCount(_counter)}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
