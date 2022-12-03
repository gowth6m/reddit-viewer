#!/bin/bash

#This will trigger the  autoroute code generation
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs