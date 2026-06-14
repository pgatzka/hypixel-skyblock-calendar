package io.github.pgatzka.calendar;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/** Entry point for the Hypixel Skyblock calendar backend. */
@SpringBootApplication
public class CalendarApplication {

  public static void main(String[] args) {
    SpringApplication.run(CalendarApplication.class, args);
  }
}
