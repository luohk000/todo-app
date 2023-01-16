import "package:flutter/material.dart";

class Task {
  String title;
  String descrip;
  String time;
  String day;

  Task(this.title, this.descrip, this.time, this.day);

  void editTitle(String title) {
    this.title = title;
  }

  void editDescrip(String descrip) {
    this.descrip = descrip;
  }

  void editTime(String time) {
    this.time = time;
  }

  void editDay(String day) {
    this.day = day;
  }
}
