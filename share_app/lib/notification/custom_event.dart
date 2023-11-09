import 'package:event_bus/event_bus.dart';

class CustomEvent{
  String? msg;
  CustomEvent(this.msg);
}
EventBus eventBus=EventBus();