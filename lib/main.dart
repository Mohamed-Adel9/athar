import 'package:flutter/material.dart';

import 'app.dart';
import 'core/service_locator/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const AtharApp());
}
