import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class NavigationEvent{

  int index;

  NavigationEvent(this.index);
}

class NightPatternEvent{

  bool isNight;

  NightPatternEvent(this.isNight);
}